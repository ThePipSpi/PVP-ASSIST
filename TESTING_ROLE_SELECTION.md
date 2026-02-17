# Testing Guide for Role Selection and Automatic Spec Switching

## Overview
This guide covers testing the new role selection feature that allows users to select their desired role (Tank, Healer, DPS) and automatically switches specializations when joining PVP queues.

## New Features

### 1. Role Selection UI
- **Location**: Quick Join section at the top
- **Components**: Checkboxes for Tank, Healer, and DPS roles
- **Behavior**: 
  - Only roles available for your class are displayed
  - Only one role can be selected at a time
  - Selection is saved in SavedVariables (PVPAssistDB.selectedRole)
  - Selection persists between sessions and UI reloads

### 2. Automatic Spec Switching
- **Trigger**: When clicking any Quick Join queue button
- **Behavior**:
  - Checks if a role is selected
  - Finds specs that match the selected role
  - Changes to the first matching spec if current spec doesn't match
  - Skips spec change if already in correct spec
  - Shows error if no spec available for selected role
  - Prevents spec change while in combat

### 3. Enhanced Tooltips
- **Location**: On all Quick Join queue buttons
- **Display**: Shows which spec will be used based on selected role
- **Format**: "Will change to [Role] spec: [Spec Name]"

## Testing Checklist

### Basic UI Tests
- [ ] Open addon with `/pvpassist`
- [ ] Verify role selector appears in Quick Join section
- [ ] Verify only roles available to your class are shown
  - Example: Paladin should see Tank, Healer, DPS
  - Example: Mage should only see DPS
  - Example: Warrior should see Tank and DPS
- [ ] Click Tank checkbox (if available) - should check it
- [ ] Click Healer checkbox (if available) - Tank should uncheck
- [ ] Click DPS checkbox (if available) - Healer should uncheck
- [ ] Click the same checkbox again - should uncheck and clear selection
- [ ] Close and reopen addon - selected role should persist

### Spec Switching Tests

#### Test Case 1: DPS to Tank (If Available)
1. Start with a DPS spec active
2. Select Tank role in addon
3. Click "Join Queue" on Random Battleground
4. **Expected**: Spec changes to Tank spec, then joins queue
5. **Verify**: Message shows "Changed specialization to [Tank Spec Name]"

#### Test Case 2: Already Correct Spec
1. Be in Tank spec
2. Select Tank role
3. Click "Join Queue" on any activity
4. **Expected**: No spec change message, directly joins queue

#### Test Case 3: Multiple Specs for Same Role
1. Play a class with multiple DPS specs (e.g., Mage, Hunter)
2. Select DPS role
3. Click any queue button
4. **Expected**: Changes to first DPS spec in list (usually spec index 1)

#### Test Case 4: No Role Selected
1. Uncheck all role checkboxes
2. Click any queue button
3. **Expected**: Joins queue without changing spec

#### Test Case 5: Combat Prevention
1. Enter combat with a training dummy
2. Select a different role than current spec
3. Click queue button while in combat
4. **Expected**: Error message "Cannot change specialization while in combat"
5. After leaving combat, try again - should work

#### Test Case 6: Invalid Role for Class
This should not happen in normal use, but can test by:
1. Select a valid role
2. Join queue successfully
3. **Expected**: Works correctly

### Tooltip Tests
- [ ] Hover over Random BG button with no role selected
  - Should show standard tooltip
- [ ] Select Tank role and hover over Random BG button
  - Should show "Will change to Tank spec: [Spec Name]"
- [ ] Select Healer role and hover over Solo Shuffle button
  - Should show "Will change to Healer spec: [Spec Name]"
- [ ] Select DPS role and hover over Arena Skirmish button
  - Should show "Will change to DPS spec: [Spec Name]"

### Persistence Tests
- [ ] Select Tank role
- [ ] Type `/reload` to reload UI
- [ ] Reopen addon
- [ ] **Expected**: Tank is still selected
- [ ] Log out and log back in
- [ ] **Expected**: Tank is still selected
- [ ] Switch characters
- [ ] **Expected**: Each character has independent role selection

### Localization Tests

#### English (enUS)
- [ ] Set client to English
- [ ] Verify "Select Role:" label
- [ ] Verify "Tank", "Healer", "DPS" labels
- [ ] Verify tooltip shows "Will change to [Role] spec: [Name]"
- [ ] Verify messages in English

#### Italian (itIT)
- [ ] Set client to Italian
- [ ] Verify "Seleziona Ruolo:" label
- [ ] Verify role labels are correct
- [ ] Verify tooltip shows Italian text
- [ ] Verify error messages in Italian

### Edge Cases

#### Edge Case 1: Spec Change Cooldown
Some situations have cooldowns on spec changes:
1. Change spec manually
2. Immediately try to queue with different role
3. **Expected**: May show cooldown error from WoW (not addon's fault)

#### Edge Case 2: Queue Already Active
1. Join a queue manually
2. Try to join another queue with different role selected
3. **Expected**: May show error from WoW about already being queued

#### Edge Case 3: Instanced Area
1. Be in an instance (dungeon/raid)
2. Try to change spec via queue button
3. **Expected**: WoW may prevent spec change (instance restriction)

### Class-Specific Testing

Test with different classes to ensure role detection works:

- [ ] **Death Knight**: Tank (Blood), DPS (Frost, Unholy)
- [ ] **Demon Hunter**: Tank (Vengeance), DPS (Havoc)
- [ ] **Druid**: Tank (Guardian), Healer (Restoration), DPS (Balance, Feral)
- [ ] **Evoker**: Healer (Preservation), DPS (Devastation, Augmentation)
- [ ] **Hunter**: DPS only (Beast Mastery, Marksmanship, Survival)
- [ ] **Mage**: DPS only (Arcane, Fire, Frost)
- [ ] **Monk**: Tank (Brewmaster), Healer (Mistweaver), DPS (Windwalker)
- [ ] **Paladin**: Tank (Protection), Healer (Holy), DPS (Retribution)
- [ ] **Priest**: Healer (Discipline, Holy), DPS (Shadow)
- [ ] **Rogue**: DPS only (Assassination, Outlaw, Subtlety)
- [ ] **Shaman**: Healer (Restoration), DPS (Elemental, Enhancement)
- [ ] **Warlock**: DPS only (Affliction, Demonology, Destruction)
- [ ] **Warrior**: Tank (Protection), DPS (Arms, Fury)

### Performance Tests
- [ ] Open and close addon 10 times quickly - no lag
- [ ] Select different roles rapidly - no lag
- [ ] Click multiple queue buttons in succession - no errors
- [ ] `/reload` multiple times with role selected - no issues

## Known Limitations

1. **Spec Change Restrictions**: The addon respects all WoW restrictions on spec changes:
   - Cannot change in combat
   - May have cooldowns after manual changes
   - May be restricted in certain instances

2. **First Matching Spec**: When multiple specs have the same role, the addon uses the first one (lowest index)
   - For pure DPS classes, this is typically the first spec

3. **API Availability**: Uses WoW API functions:
   - `GetNumSpecializations()`
   - `GetSpecializationInfo()`
   - `SetSpecialization()`
   - `InCombatLockdown()`

## Debugging

If issues occur, use these debug commands in-game:

```lua
-- Check current spec
/dump GetSpecialization()

-- Check all specs
/dump GetNumSpecializations()

-- Check selected role
/dump PVPAssistDB.selectedRole

-- Check spec info
/run for i=1,GetNumSpecializations() do local id,name,_,_,role=GetSpecializationInfo(i); print(i,name,role) end
```

## Success Criteria

The feature is working correctly if:
1. ✓ Role selector displays only available roles for player's class
2. ✓ Only one role can be selected at a time
3. ✓ Selection persists across sessions
4. ✓ Spec changes automatically when joining queue with role selected
5. ✓ Spec change is skipped if already in correct spec
6. ✓ Combat check prevents spec change during combat
7. ✓ Tooltips show which spec will be used
8. ✓ All localization strings display correctly
9. ✓ No Lua errors occur during normal usage
10. ✓ SavedVariables are properly stored and loaded

## Reporting Issues

When reporting issues, please include:
- Your class and current spec
- Which role was selected
- Which queue button was clicked
- Any error messages displayed
- Steps to reproduce the issue
- Screenshot if possible
