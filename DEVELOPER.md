# Developer Guide - PVP Assist

## For Contributors and Modders

This guide is for developers who want to contribute to or modify PVP Assist.

## Development Environment Setup

### Prerequisites

1. **World of Warcraft** (Retail version)
2. **Text Editor** (VS Code, Sublime, Atom, etc.)
3. **Git** (for version control)
4. **Optional:** Lua language server for IDE support

### Recommended VS Code Extensions

- Lua Language Server (sumneko.lua)
- WoW Bundle (Septh/wow-bundle)
- GitLens

### Setting Up Development Workflow

1. **Clone the repository**
   ```bash
   git clone https://github.com/ThePipSpi/PVP-ASSIST.git
   ```

2. **Create symbolic link to WoW AddOns folder**
   
   **Windows (PowerShell as Admin):**
   ```powershell
   New-Item -ItemType SymbolicLink -Path "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\PVP-ASSIST" -Target "C:\path\to\PVP-ASSIST"
   ```
   
   **Mac/Linux:**
   ```bash
   ln -s /path/to/PVP-ASSIST "/Applications/World of Warcraft/_retail_/Interface/AddOns/PVP-ASSIST"
   ```

3. **Enable script errors in WoW**
   ```
   /console scriptErrors 1
   ```

4. **Use /reload frequently**
   After each code change, use `/reload` in-game to test

## Project Structure

```
PVP-ASSIST/
├── PVPAssist.toc      # Addon manifest
├── Core.lua           # Business logic
├── UI.lua             # User interface
└── [Documentation]    # README, guides, etc.
```

## Coding Standards

### Lua Style Guide

```lua
-- Use camelCase for functions
function PVPAssist:GetCurrentData()
    -- Implementation
end

-- Use camelCase for local variables
local currentHonor = 0
local weeklyMax = 15000

-- Use descriptive names
local playerName = UnitName("player")  -- Good
local pn = UnitName("player")          -- Bad

-- Add comments for complex logic
-- Calculate remaining honor needed for weekly cap
local remaining = math.max(0, weeklyMax - earned)

-- Use early returns to reduce nesting
if not data then
    return nil
end
-- Continue with main logic

-- Constants in UPPER_CASE (if used)
local HONOR_CURRENCY_ID = 1792
local CONQUEST_CURRENCY_ID = 1602
```

### WoW API Best Practices

```lua
-- Always check if API functions exist
if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
    local info = C_CurrencyInfo.GetCurrencyInfo(1792)
end

-- Cache API results when possible
local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(1792)
if currencyInfo then
    self.cachedHonor = currencyInfo.quantity
end

-- Use events instead of polling
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

-- Clean up frames and events on disable
frame:UnregisterAllEvents()
```

## Adding New Features

### Example: Adding a New Activity

**1. Define the activity in Core.lua:**

```lua
function PVPAssist:GetRecommendedActivities()
    -- ... existing code ...
    
    -- Add new activity
    table.insert(activities, {
        type = "honor",
        name = "Ashran",
        reward = "~400-800 Honor per completion",
        priority = 2,
        description = "Large scale PVP event"
    })
    
    -- ... existing code ...
end
```

**2. Test in-game:**
- Use `/reload`
- Open tracker with `/pvpassist`
- Verify new activity appears in correct section

### Example: Adding a Configuration Option

**1. Add to SavedVariables in Core.lua:**

```lua
local defaults = {
    weeklyHonor = 0,
    weeklyConquest = 0,
    lastUpdate = 0,
    trackedActivities = {},
    -- New option
    showMinimapButton = true
}
```

**2. Add UI control in UI.lua:**

```lua
local checkbox = CreateFrame("CheckButton", nil, settingsFrame, "UICheckButtonTemplate")
checkbox:SetChecked(PVPAssistDB.showMinimapButton)
checkbox:SetScript("OnClick", function(self)
    PVPAssistDB.showMinimapButton = self:GetChecked()
    minimapButton:SetShown(PVPAssistDB.showMinimapButton)
end)
```

## Testing Your Changes

### Manual Testing Checklist

After making changes:

1. **Syntax Check**
   - Save file
   - Look for editor warnings
   
2. **In-Game Test**
   ```
   /reload
   [Test your feature]
   [Check for Lua errors]
   ```

3. **Edge Cases**
   - Test with 0 honor/conquest
   - Test with max caps reached
   - Test with missing data

### Debugging Techniques

```lua
-- Print debugging
print("Debug:", variableName)

-- Dump tables
DevTools_Dump(tableVariable)

-- Or use /dump command
/dump PVPAssist:GetCurrentCurrency()

-- Check if value is nil
if value then
    print("Has value:", value)
else
    print("Value is nil or false")
end
```

### Common Pitfalls

❌ **Don't do this:**
```lua
local value = PVPAssist.data.honor  -- Might be nil
print(value.amount)  -- Error if value is nil
```

✅ **Do this:**
```lua
local value = PVPAssist.data.honor
if value and value.amount then
    print(value.amount)
end
```

## WoW API Reference

### Essential APIs Used

**Currency Information:**
```lua
C_CurrencyInfo.GetCurrencyInfo(currencyID)
-- Returns: CurrencyInfo table
-- Fields: name, quantity, iconFileID, maxQuantity, totalEarned, etc.
```

**Date and Time:**
```lua
C_DateAndTime.GetSecondsUntilWeeklyReset()
-- Returns: seconds (number) until Tuesday reset
```

**Quest Log:**
```lua
C_QuestLog.IsQuestFlaggedCompleted(questID)
-- Returns: boolean
```

**Unit Info:**
```lua
UnitName("player")  -- Player's name
UnitLevel("player")  -- Player's level
```

### Finding Currency IDs

To find a currency ID:
1. Open currency tab in-game
2. Hover over currency
3. Use this macro:
   ```lua
   /run local id=1; while C_CurrencyInfo.GetCurrencyInfo(id) do local info=C_CurrencyInfo.GetCurrencyInfo(id); if info.name=="Honor" then print("Honor ID:",id) end; id=id+1; end
   ```

### Finding Quest IDs

To find a quest ID:
1. Complete or accept the quest
2. Use this addon or macro:
   ```lua
   /dump C_QuestLog.GetInfo(C_QuestLog.GetLogIndexForQuestID(questID))
   ```

## Extending the Addon

### Adding API Integration

To integrate external APIs (future enhancement):

**1. Create API module:**

```lua
-- API.lua (new file)
local _, PVPAssist = ...

PVPAssist.API = {}

function PVPAssist.API:FetchSeasonData()
    -- Implement HTTP request
    -- Note: WoW addons can't make HTTP requests directly
    -- Would need to use external tool or Blizzard API via OAuth
end
```

**2. Update .toc file:**
```
Core.lua
API.lua
UI.lua
```

**3. Use in Core.lua:**
```lua
function PVPAssist:GetCurrentCurrency()
    -- Try API first
    local apiData = self.API:FetchSeasonData()
    if apiData then
        return apiData
    end
    
    -- Fallback to local API
    -- ... existing code ...
end
```

### Adding a Settings Panel

```lua
-- Settings.lua (new file)
local settingsFrame = CreateFrame("Frame", "PVPAssistSettings", UIParent)
settingsFrame.name = "PVP Assist"

-- Register with Interface Options
InterfaceOptions_AddCategory(settingsFrame)

-- Add controls
local title = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("PVP Assist Settings")

-- Add checkboxes, sliders, etc.
```

## Version Management

### Updating Version Number

When releasing a new version:

1. **Update PVPAssist.toc:**
   ```
   ## Version: 1.1.0
   ```

2. **Update Core.lua:**
   ```lua
   PVPAssist.version = "1.1.0"
   ```

3. **Update CHANGELOG.md:**
   ```markdown
   ## [1.1.0] - 2026-XX-XX
   ### Added
   - New feature X
   ```

### Semantic Versioning

Follow semver (MAJOR.MINOR.PATCH):
- **MAJOR:** Breaking changes (2.0.0)
- **MINOR:** New features (1.1.0)
- **PATCH:** Bug fixes (1.0.1)

## Contributing Guidelines

### Pull Request Process

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow coding standards
   - Test thoroughly
   - Update documentation

4. **Commit with clear messages**
   ```bash
   git commit -m "Add: New feature description"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Format

```
Type: Brief description

Detailed description if needed

- Bullet points for changes
- Another change
```

**Types:** Add, Fix, Update, Remove, Refactor, Docs

## Performance Optimization

### Best Practices

```lua
-- Cache global lookups
local math_max = math.max
local math_floor = math.floor

-- Reuse tables instead of creating new ones
local resultTable = {}
function GetData()
    wipe(resultTable)  -- Clear instead of creating new
    -- Populate resultTable
    return resultTable
end

-- Avoid unnecessary table creations in loops
-- Bad:
for i = 1, 1000 do
    local temp = {value = i}
end

-- Good:
local temp = {}
for i = 1, 1000 do
    temp.value = i
end
```

### Profiling

Use CPU profiler addons to find bottlenecks:
- !CPU Usage
- FrameXML Profiler

## Security Considerations

### Don't Do:

- ❌ Execute strings from user input
- ❌ Store passwords or tokens in SavedVariables
- ❌ Make external HTTP requests (not possible anyway)
- ❌ Access files outside WoW sandbox

### Do:

- ✅ Validate all user input
- ✅ Sanitize strings before display
- ✅ Use Blizzard's secure templates for actions
- ✅ Handle errors gracefully

## Resources

### Official Documentation

- [WoW API Documentation](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)
- [WoW UI Widget API](https://wowpedia.fandom.com/wiki/Widget_API)
- [Lua 5.1 Reference](https://www.lua.org/manual/5.1/)

### Community Resources

- [WoW Interface Forums](https://www.wowinterface.com/forums/)
- [MMO-Champion Addon Forum](https://www.mmo-champion.com/forums/245-UI-Addons)
- [WoW Addon Discord Servers](https://discord.gg/wow-addons)

### Useful Tools

- [BLPConverter](https://www.wowinterface.com/downloads/info22128) - For custom textures
- [WoW UI Designer](https://wowuidesigner.github.io/) - Visual UI builder
- [FrameXML Browser](https://www.townlong-yak.com/framexml/live) - Blizzard's UI code

## Getting Help

If you're stuck:

1. Check WoW API documentation
2. Search WoWInterface forums
3. Ask in Discord communities
4. Check similar addons' source code
5. Open an issue on GitHub

## License

This project is open source and free to modify. When contributing:
- Your code becomes part of the project
- Credit original authors
- Maintain the open source nature

---

**Happy Coding! May your code be bug-free and your FPS high!** 🖥️⚔️
