# Testing and Verification Guide

## Pre-Installation Checks

### 1. Verify File Integrity

```bash
# All required files should be present:
PVPAssist.toc  ← Must have
Core.lua       ← Must have
UI.lua         ← Must have
```

### 2. Check .toc File Format

Open `PVPAssist.toc` and verify:
- Interface number matches your WoW version (110002 for Dragonflight/TWW)
- SavedVariables is declared
- Lua files are listed in correct order

## Installation Verification

### Step 1: Check File Location

**Windows:**
```
C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\PVP-ASSIST\
```

**Mac:**
```
/Applications/World of Warcraft/_retail_/Interface/AddOns/PVP-ASSIST/
```

Folder must be named exactly `PVP-ASSIST` (case-sensitive on Mac/Linux).

### Step 2: Launch WoW and Check Addon List

1. Launch World of Warcraft
2. At character selection, click "AddOns" button
3. Look for "PVP Assist" in the list
4. Ensure it's checked (enabled)
5. If you see a version number, that's a good sign!

### Step 3: Log Into Character

Upon login, you should see in chat:
```
|cff00ff00PVP Assist loaded!|r Type /pvpassist to open the tracker.
```

If you don't see this message:
1. Check for Lua errors (see troubleshooting below)
2. Verify files are in correct location
3. Try `/reload` command

## Basic Functionality Tests

### Test 1: Slash Commands

```
/pvpassist  → Should open main window
/pvpa       → Should also open main window
```

**Expected Result:** A window titled "PVP Assist - Honor & Conquest Tracker" appears in center of screen.

### Test 2: Minimap Button

1. Look for a PVP sword icon near your minimap
2. Left-click it
3. Window should toggle open/closed

**Expected Result:** Same window as slash command.

### Test 3: Window Interaction

With the window open:
- ✅ Drag title bar → Window should move
- ✅ Click "Refresh" button → Data should update
- ✅ Click X → Window should close
- ✅ Scroll if content is long → Should scroll smoothly

### Test 4: Data Display

The window should show:
1. **Current Status Section**
   - Honor amount (number)
   - Conquest amount (number)
   - Weekly progress (X / Y format)
   - Remaining amounts
   - Reset timer

2. **Recommended Activities Section**
   - List of honor activities (if honor cap not reached)
   - List of conquest activities (if conquest cap not reached)
   - OR "All caps reached" message

3. **Weekly Quests Section**
   - Quest names with ✓ or ○ symbols
   - Reward information

4. **Tips Section**
   - Helpful PVP tips

### Test 5: Real-Time Updates

1. Open the window
2. Do a battleground or arena
3. Earn some honor or conquest
4. Check if the window updates automatically

**Expected Result:** Currency values update without needing to click refresh.

## Advanced Testing

### Test 6: SavedVariables Persistence

1. Open the window, note your current values
2. Close WoW completely
3. Navigate to:
   ```
   WoW/_retail_/WTF/Account/[ACCOUNT]/SavedVariables/PVPAssist.lua
   ```
4. Check that `PVPAssistDB` exists in this file
5. Restart WoW
6. Values should be the same as before

### Test 7: Weekly Reset Simulation

1. Note time until reset shown in addon
2. Wait a few minutes
3. Refresh the window
4. Time should have decreased

### Test 8: Cap Reached Scenario

If you've reached your weekly cap:
- Honor or Conquest section should show "cap reached" message
- Activities for that currency should not appear in recommendations
- If both caps reached, should show "All weekly caps reached! Great job!"

### Test 9: Fresh Week (After Reset)

After weekly reset (Tuesday morning in US):
- Weekly earned should reset to 0
- Full cap should be available again
- All activities should be recommended again
- Reset timer should show ~7 days

## Troubleshooting Tests

### Check for Lua Errors

1. Type `/console scriptErrors 1`
2. Reload UI with `/reload`
3. Look for any red error messages
4. If errors appear, note the exact message

**Common Errors:**
- "attempt to call field 'X' (a nil value)" → WoW API changed
- "PVPAssist.toc not found" → File location wrong
- "SavedVariables error" → Data corruption, delete PVPAssist.lua from SavedVariables

### Check Addon Loading Order

If the addon seems to load but doesn't work:

1. Type `/dump PVPAssist`
2. Should return a table, not nil
3. If nil, addon didn't load properly

### Verify WoW API Availability

Test if WoW APIs work:

```lua
/dump C_CurrencyInfo.GetCurrencyInfo(1792)
```

Should return honor currency info. If nil, you might be on Classic WoW (this addon is for Retail only).

### Test Individual Functions

```lua
/dump PVPAssist:GetCurrentCurrency()
/dump PVPAssist:GetRemainingPoints()
/dump PVPAssist:GetTimeUntilReset()
```

Each should return appropriate data structures.

## Performance Tests

### Memory Usage

```
/dump collectgarbage("count")  -- Before opening window
[Open window]
/dump collectgarbage("count")  -- After opening window
```

Memory increase should be minimal (<100KB).

### FPS Impact

1. Note your FPS before installing addon
2. Install and enable addon
3. Check FPS again
4. Should be negligible difference (<1 FPS)

## Compatibility Tests

### Test with Other Addons

Common addons to test compatibility with:
- WeakAuras
- ElvUI / TukUI
- Bartender
- DBM / BigWigs
- Details!

**Expected Result:** No conflicts, all addons work together.

### Test in Different Scenarios

- ✅ In capital city (Stormwind/Orgrimmar)
- ✅ In battleground
- ✅ In arena
- ✅ In open world
- ✅ In dungeon/raid (addon should still work)

## Validation Checklist

Use this checklist to verify complete functionality:

- [ ] Addon appears in addon list
- [ ] No Lua errors on login
- [ ] Success message appears in chat
- [ ] `/pvpassist` command works
- [ ] `/pvpa` short command works
- [ ] Minimap button appears
- [ ] Minimap button is clickable
- [ ] Main window opens
- [ ] Window can be dragged
- [ ] Window can be closed
- [ ] Honor values display correctly
- [ ] Conquest values display correctly
- [ ] Weekly progress shows correct ratio
- [ ] Remaining amounts calculate correctly
- [ ] Reset timer shows reasonable time
- [ ] Activities list appears (or "cap reached" message)
- [ ] Honor activities listed when honor available
- [ ] Conquest activities listed when conquest available
- [ ] Weekly quests show with correct symbols
- [ ] Tips section displays
- [ ] Footer shows version number
- [ ] Refresh button works
- [ ] UI updates when currency changes
- [ ] Scroll bar works (if content is long)
- [ ] SavedVariables file created
- [ ] Settings persist after restart
- [ ] No FPS drop
- [ ] No memory leak
- [ ] Works with other addons
- [ ] Tooltip appears on minimap button hover

## Expected Data Ranges

To verify data is reasonable:

| Item | Expected Range | Notes |
|------|----------------|-------|
| Honor | 0 - 200,000 | Max carry-over from previous weeks |
| Conquest | 0 - 10,000 | Depends on rating and season |
| Weekly Honor Cap | 0 - 15,000 | May vary by season |
| Weekly Conquest Cap | 0 - 1,500+ | Increases with rating |
| Reset Timer | 0d - 7d | Until next Tuesday |
| Activity Rewards | 25 - 600 | Per win/round |

## When to Report Issues

Report an issue if:
1. ❌ Addon doesn't load
2. ❌ Lua errors appear
3. ❌ Data shows as 0 when you have currency
4. ❌ Window doesn't open
5. ❌ Buttons don't respond
6. ❌ Data doesn't update after earning currency
7. ❌ Significant FPS drop
8. ❌ Conflicts with other addons
9. ❌ SavedVariables don't persist

Include in your report:
- WoW version
- Addon version
- Other addons installed
- Exact error message (if any)
- Steps to reproduce

## Success Criteria

The addon is working correctly if:
✅ Loads without errors
✅ Displays current honor/conquest
✅ Shows accurate weekly progress
✅ Recommends appropriate activities
✅ Updates in real-time
✅ UI is responsive and smooth
✅ Data persists between sessions
✅ No performance impact
