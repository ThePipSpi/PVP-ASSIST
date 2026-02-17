# PVP Assist - Technical Architecture

## File Structure

```
PVP-ASSIST/
├── PVPAssist.toc          # Addon table of contents (required by WoW)
├── Core.lua               # Core functionality and data management
├── UI.lua                 # User interface and display logic
├── .gitignore             # Git ignore rules
├── README.md              # Main documentation (English)
├── INSTALLAZIONE.md       # Installation guide (Italian)
├── QUICKSTART.md          # Quick reference guide
├── UI_GUIDE.md            # UI visual documentation
├── API_NOTES.md           # API integration notes
└── CHANGELOG.md           # Version history
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PVPAssist.toc                             │
│  (Addon Manifest - Loaded First by WoW)                     │
│  - Defines addon metadata                                    │
│  - Lists files to load: Core.lua → UI.lua                   │
│  - Declares SavedVariables: PVPAssistDB                     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                       Core.lua                               │
│  (Data Layer - Business Logic)                              │
├─────────────────────────────────────────────────────────────┤
│  Functions:                                                  │
│  • InitDB() - Initialize saved data                         │
│  • GetCurrentCurrency() - Query WoW API for Honor/Conquest │
│  • GetRemainingPoints() - Calculate caps                    │
│  • GetRecommendedActivities() - Generate activity list      │
│  • GetWeeklyQuestStatus() - Check quest completion         │
│  • GetTimeUntilReset() - Format reset timer                │
├─────────────────────────────────────────────────────────────┤
│  Event Handlers:                                             │
│  • ADDON_LOADED - Initialize on load                        │
│  • PLAYER_ENTERING_WORLD - Setup on world enter            │
│  • CURRENCY_DISPLAY_UPDATE - Refresh on currency change    │
├─────────────────────────────────────────────────────────────┤
│  Slash Commands:                                             │
│  • /pvpassist - Toggle main window                          │
│  • /pvpa - Short version                                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                        UI.lua                                │
│  (Presentation Layer - User Interface)                       │
├─────────────────────────────────────────────────────────────┤
│  UI Components:                                              │
│  • mainFrame - Main window (450x550)                        │
│  • scrollFrame - Scrollable content area                    │
│  • minimapButton - Minimap icon                             │
│  • refreshButton - Manual refresh trigger                   │
├─────────────────────────────────────────────────────────────┤
│  Functions:                                                  │
│  • ToggleMainFrame() - Show/hide window                     │
│  • UpdateUI() - Refresh display with current data           │
│  • CreateSectionHeader() - Format section titles            │
│  • CreateInfoText() - Format info rows                      │
├─────────────────────────────────────────────────────────────┤
│  Event Handlers:                                             │
│  • OnDragStart/OnDragStop - Window dragging                 │
│  • OnClick - Button interactions                            │
│  • OnEnter/OnLeave - Tooltip display                        │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Action (Open Window or Currency Change)
              ↓
┌─────────────────────────────┐
│  Core.lua Event Handlers    │
│  - Detect trigger           │
│  - Call UpdateUI()          │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  Core.lua Data Functions    │
│  - GetCurrentCurrency()     │
│  - GetRemainingPoints()     │
│  - GetRecommendedActivities()│
│  - GetWeeklyQuestStatus()   │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  WoW API Calls              │
│  - C_CurrencyInfo           │
│  - C_DateAndTime            │
│  - C_QuestLog               │
└─────────────────────────────┘
              ↓
┌─────────────────────────────┐
│  UI.lua UpdateUI()          │
│  - Clear old content        │
│  - Generate new display     │
│  - Format with colors       │
│  - Show to user             │
└─────────────────────────────┘
              ↓
        User sees updated UI
```

## WoW API Integration

### Currency System
```lua
C_CurrencyInfo.GetCurrencyInfo(1792)  -- Honor
└─> Returns: {
    quantity: current amount,
    maxQuantity: weekly cap,
    totalEarned: earned this week
}

C_CurrencyInfo.GetCurrencyInfo(1602)  -- Conquest
└─> Returns: same structure
```

### Time System
```lua
C_DateAndTime.GetSecondsUntilWeeklyReset()
└─> Returns: seconds until next Tuesday reset
    └─> Format to "Xd Xh Xm"
```

### Quest System
```lua
C_QuestLog.IsQuestFlaggedCompleted(questID)
└─> Returns: true/false
    └─> Display as ✓ or ○
```

## Saved Data Structure

```lua
PVPAssistDB = {
    weeklyHonor = 0,           -- Tracked honor (fallback)
    weeklyConquest = 0,        -- Tracked conquest (fallback)
    lastUpdate = 0,            -- Last update timestamp
    trackedActivities = {}     -- Activity history
}
```

## Activity Recommendation Logic

```
Check Remaining Points
        ↓
┌──────────────────┐
│ Honor Remaining? │ → Yes → Add Honor Activities (by priority)
│      > 0         │          1. Random BGs
└──────────────────┘          2. Epic BGs
        ↓ No                  3. World PVP
        
┌──────────────────┐
│Conquest Remain?  │ → Yes → Add Conquest Activities (by priority)
│      > 0         │          1. Rated BGs
└──────────────────┘          2. Solo Shuffle
        ↓ No                  3. Arena
                              4. Weekly Brawl
        
All Caps Reached
└─> Show success message
```

## UI Update Triggers

```
Automatic Updates:
• CURRENCY_DISPLAY_UPDATE event (when honor/conquest changes)
• Window opened via slash command or minimap button

Manual Updates:
• "Refresh" button clicked
• /reload command used
```

## Color Coding System

```lua
Honor Colors:     {r=1,   g=0.82, b=0}     -- Gold
Conquest Colors:  {r=0.64, g=0.21, b=0.93} -- Purple
Success/Complete: {r=0,   g=1,    b=0}     -- Green
Pending:          {r=1,   g=1,    b=0}     -- Yellow
Info:             {r=0.7, g=0.7,  b=0.7}   -- Grey
```

## Performance Considerations

1. **Lazy Loading**: UI only updates when visible
2. **Event-Driven**: No constant polling, only on currency changes
3. **Minimal Data**: Lightweight SavedVariables structure
4. **Efficient Rendering**: Reuses UI elements where possible

## Security & Privacy

```
Data Storage: Local Only
    └─> SavedVariables in WoW folder
    
Network Access: None
    └─> No external API calls in v1.0.0
    
User Data: Minimal
    └─> Only currency tracking, no personal info
```

## Extension Points (Future)

```
1. API Integration Layer
   └─> Add HTTP request handler
   └─> Implement OAuth for Battle.net API
   └─> Cache API responses

2. Historical Tracking
   └─> Expand PVPAssistDB structure
   └─> Add weekly history arrays
   └─> Create statistics calculations

3. Configuration UI
   └─> Add settings panel
   └─> Customization options
   └─> Saved preferences

4. Notifications
   └─> Add alert system
   └─> Pop-up messages
   └─> Sound effects
```

## Compatibility Matrix

| Component | Requirement | Status |
|-----------|-------------|--------|
| WoW Version | Retail (110002+) | ✅ |
| Lua Version | 5.1 (WoW embedded) | ✅ |
| Dependencies | None | ✅ |
| Libraries | None (uses WoW API only) | ✅ |
| SavedVariables | PVPAssistDB | ✅ |

## Error Handling

```lua
Currency Info:
    if honorInfo then → Use data
    else → Default to 0

Quest Status:
    Try C_QuestLog.IsQuestFlaggedCompleted()
    Catch errors → Show as uncompleted

UI Creation:
    Create frames with fallbacks
    Check parent existence before adding children
```

## Testing Checklist

- [ ] Install in AddOns folder
- [ ] Check for Lua errors on load
- [ ] Verify slash commands work
- [ ] Test minimap button click
- [ ] Verify currency displays correctly
- [ ] Check activity recommendations
- [ ] Test window dragging
- [ ] Verify refresh button
- [ ] Check weekly reset timer
- [ ] Test after earning honor/conquest
- [ ] Verify after weekly reset
- [ ] Check SavedVariables persistence
