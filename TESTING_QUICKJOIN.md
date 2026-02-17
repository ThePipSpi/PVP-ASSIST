# Testing Guide for PVP Assist Quick Join Feature

## New Features Added

### 1. Live Reward Tracking
- **Session tracking**: Displays honor and conquest earned during the current session
- **Automatic updates**: Updates when currency changes via CURRENCY_DISPLAY_UPDATE event
- **Reset capability**: Session tracking can be reset

### 2. Quick Join Buttons
Added quick access buttons for:
- **Random Battleground** - Join queue directly (~200-400 Honor per win)
- **Epic Battleground** - Join queue directly (~300-600 Honor per win)
- **Solo Shuffle** - Navigate to Solo Shuffle UI (~30-60 Conquest per round)
- **Rated Battleground** - Open Rated PVP frame (~50-100 Conquest per win)
- **Arena 2v2** - Opens Group Finder for LFG (~25-50 Conquest per win)
- **Arena 3v3** - Opens Group Finder for LFG (~25-50 Conquest per win)
- **Arena Skirmish** - Join arena skirmish queue (~15-30 Honor per win)

Each button displays:
- Activity name
- Reward range (color-coded: gold for honor, purple for conquest)
- Tooltip with detailed information on mouseover

### 3. Localization Support
- **English (enUS)**: Default language
- **Italian (itIT)**: Full Italian translation
- Automatically detects client locale
- All UI text is localized

### 4. Future Implementation Section
Shows planned features in both English and Italian:
- Historical statistics and performance tracking
- Alert notifications when near weekly cap
- PVP gear upgrade recommendations
- Arena/RBG rating progression tracker
- Compare progress with friends

## Testing in World of Warcraft

### Installation
1. Copy the PVP-ASSIST folder to:
   - Windows: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - Mac: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
2. Restart WoW or type `/reload`

### Testing Checklist

#### Basic Functionality
- [ ] Addon loads without errors (check for Lua errors on screen)
- [ ] Type `/pvpassist` or `/pvpa` to open the window
- [ ] Click minimap button to toggle window
- [ ] Window can be dragged around the screen
- [ ] Scroll functionality works for long content

#### Currency Display
- [ ] Current Honor displays correctly
- [ ] Current Conquest displays correctly
- [ ] Weekly earned amounts show
- [ ] Remaining to cap calculates correctly
- [ ] Weekly reset timer displays

#### Session Tracking
- [ ] Session tracking section appears after earning honor/conquest
- [ ] Session honor increments when honor is earned
- [ ] Session conquest increments when conquest is earned
- [ ] Tracking persists across UI reloads

#### Quick Join Buttons
- [ ] Random BG button joins random battleground queue
- [ ] Epic BG button joins epic battleground queue
- [ ] Solo Shuffle button navigates to Solo Shuffle UI
- [ ] Rated BG button opens Rated PVP frame
- [ ] Arena 2v2 button opens Group Finder
- [ ] Arena 3v3 button opens Group Finder
- [ ] Arena Skirmish button joins skirmish queue
- [ ] All buttons display correct reward information
- [ ] Tooltips show on button mouseover
- [ ] Tooltip information is accurate

#### Localization
- [ ] English text displays correctly on enUS client
- [ ] Italian text displays correctly on itIT client
- [ ] All UI elements are localized
- [ ] No missing translations (fallback to English if needed)

#### Future Implementation Section
- [ ] Section displays at bottom of window
- [ ] Shows all 5 planned features
- [ ] Text is properly formatted and readable
- [ ] Text is localized to client language

#### Performance
- [ ] No lag when opening/closing window
- [ ] UI updates smoothly
- [ ] No errors in chat when clicking buttons
- [ ] No memory leaks (use /reload multiple times)

## Known Limitations

1. **WoW API Calls**: Some API calls might not work exactly as intended if Blizzard changes the API
2. **Queue IDs**: The queue IDs used (1, 2, etc.) are based on common values but may vary
3. **Group Finder Navigation**: Opening specific Group Finder tabs might vary by patch
4. **Locale Detection**: Only supports enUS and itIT; other locales default to English

## Troubleshooting

### Common Issues

**"Attempt to call nil value" errors**:
- Check that all files are loaded in correct order in PVPAssist.toc
- Ensure WoW API functions exist in current game version

**Quick join buttons don't work**:
- Verify that C_PvP API is available
- Check that PVPUIFrame and related frames exist
- Some functions may require being in a capital city

**Session tracking doesn't update**:
- Make sure CURRENCY_DISPLAY_UPDATE event is firing
- Check that PVPAssistDB saved variables are being written
- Try `/reload` to refresh saved data

**Localization not working**:
- Verify GetLocale() returns expected value
- Check that Localization.lua loads before UI.lua
- Ensure L table is properly set up

### Debug Commands

Use these in-game to debug:
```lua
/dump GetLocale()  -- Check current locale
/dump C_PvP  -- Verify C_PvP API exists
/dump PVPAssistDB  -- Check saved variables
/dump PVPAssist.QuickJoin  -- Verify QuickJoin module loaded
/dump PVPAssist.L  -- Check localization table
```

## File Structure

```
PVP-ASSIST/
├── PVPAssist.toc          # Addon manifest (loads files in order)
├── Core.lua               # Core functionality and data management
├── Localization.lua       # Language support (EN/IT)
├── QuickJoin.lua          # Quick join queue functionality
├── UI.lua                 # User interface (updated with new features)
└── README.md              # Documentation
```

## API Functions Used

### Core WoW APIs
- `C_PvP.JoinBattlefield(id)` - Join battleground queue
- `C_PvP.JoinSkirmish()` - Join arena skirmish
- `C_CurrencyInfo.GetCurrencyInfo(id)` - Get currency data
- `C_DateAndTime.GetSecondsUntilWeeklyReset()` - Get reset time
- `GetLocale()` - Get client language

### UI Functions
- `CreateFrame()` - Create UI elements
- `GameTooltip` - Display tooltips
- `ShowUIPanel()` - Open UI panels
- `PVEFrame_ShowFrame()` - Navigate to PVE/PVP frames

## Future Development Notes

For future enhancements, consider:
1. Add configuration panel for customizing button layout
2. Implement historical tracking database
3. Add sound notifications for queue pops
4. Create custom keybindings for quick actions
5. Add support for more languages
6. Integrate with external APIs for real-time data
