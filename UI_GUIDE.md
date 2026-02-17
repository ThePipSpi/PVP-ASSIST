# PVP Assist - User Interface Guide

## Main Window Layout

The PVP Assist window is a 500x700 pixel frame with the following sections:

### Window Header
```
+------------------------------------------+
|  PVP Assist - Honor & Conquest Tracker   |
|  [Minimize] [Close]                       |
+------------------------------------------+
```

### Section 1: Quick Join (Accesso Rapido)

Quick access buttons to join PVP activities:

```
⚔️ Quick Join
------------------
Select Role: [Tank] [Healer] [DPS]

Random Battleground                [Join Queue]
  ~200-400 Honor per win

Epic Battleground                  [Join Queue]
  ~300-600 Honor per win

Solo Shuffle                       [Join Queue]
  ~30-60 Conquest per round

Rated Battleground                 [Join Queue]
  ~50-100 Conquest per win

Arena 2v2                          [Open LFG]
  ~25-50 Conquest per win

Arena 3v3                          [Open LFG]
  ~25-50 Conquest per win

Arena Skirmish                     [Join Queue]
  ~15-30 Honor per win
```

**Features:**
- Role selector to automatically switch spec before joining
- One-click queue buttons
- Color-coded rewards (Gold for Honor, Purple for Conquest)
- Wider buttons (110px) to properly fit button text

### Section 2: Session Tracking (Optional)

Shows current session gains (only appears if you've gained honor/conquest):

```
📊 Session Tracking
------------------
  Session Honor: +450
  Session Conquest: +120
```

### Section 3: Current Status (Stato Attuale)

Shows real-time currency information with icons:

```
💰 Current Status
------------------
🏅 Honor: 15,432 (Weekly: 3,200 / 15,000)
  → Remaining to cap: 11,800 Honor

⚔️ Conquest: 892 (Weekly: 450 / 1,350)
  → Remaining to cap: 900 Conquest

⏰ Weekly reset in: 3d 15h 42m
```

**Color Coding:**
- Honor values: Gold/Yellow (#FFD100)
- Conquest values: Purple (#A356EE)
- Remaining amounts: Light Green when incomplete
- Cap reached: Bright Green with ✓ checkmark

### Section 4: Weekly PVP Quests (Missioni PVP Settimanali)

Tracks completion of weekly quests with helpful guidance:

```
📜 Weekly PVP Quests
------------------
✓ Preserving in PvP
  🎁 Reward: Conquest + Honor - Complete PVP activities

○ Arena Skirmishes
  🎁 Reward: Conquest - Win arena skirmishes
```

If no quests are tracked, shows helpful guidance:
```
📜 Weekly PVP Quests
------------------
ℹ️ How to get weekly PVP quests:
• Visit your faction's PVP area
• Check the Adventure Guide (Shift+J)
• Look for quests near PVP vendors
```

**Symbols:**
- ✓ = Completed (Green)
- ○ = Not completed (Yellow)
- 🎁 = Reward icon

### Window Footer

```
+------------------------------------------+
| [Refresh]                                 |
| Addon by ThePipSpi - Version 1.0.0        |
+------------------------------------------+
```

## Changes from Previous Version

**Removed Sections:**
- ❌ "Recommended Activities" - Not useful, redundant with Quick Join buttons
- ❌ "Tips" section - Not needed
- ❌ "Future Implementation" section - Not useful for users

**Improved Sections:**
- ✅ "Quick Join" moved to top for better accessibility
- ✅ "Current Status" now appears under Quick Join with more icons
- ✅ "Weekly PVP Quests" improved with helpful guidance when no quests are tracked
- ✅ Icons added throughout the UI (⚔️, 💰, 🏅, ⏰, 📜, 🎁, ℹ️, ✓)
- ✅ Button width increased from 90px to 110px to prevent text overflow

## Minimap Button

A small circular button appears on the minimap with a PVP sword icon.

**Interactions:**
- **Left-click**: Open/close the main window
- **Hover**: Shows tooltip with addon name and controls

**Tooltip:**
```
PVP Assist
Left-click to open tracker
```

## Access Methods

1. **Minimap Button**: Click the PVP sword icon near the minimap
2. **Slash Command**: Type `/pvpassist` or `/pvpa` in chat
3. **Keybind**: (Can be set in WoW's keybinding interface)

## Dynamic Updates

The interface updates automatically when:
- Currency values change (honor/conquest gained)
- Weekly reset occurs
- Quests are completed
- Player clicks "Refresh" button

## Window Features

- **Movable**: Drag the title bar to reposition
- **Scrollable**: Content area scrolls if it exceeds window height
- **Persistent**: Position saved between sessions
- **Responsive**: Updates in real-time as you play

## States

### All Caps Reached
When both weekly caps are reached:
```
💰 Current Status
------------------
🏅 Honor: 28,450 (Weekly: 15,000 / 15,000)
  ✓ Weekly Honor cap reached!

⚔️ Conquest: 2,134 (Weekly: 1,350 / 1,350)
  ✓ Weekly Conquest cap reached!
```

### Fresh Week (After Reset)
```
💰 Current Status
------------------
🏅 Honor: 24,328 (Weekly: 0 / 15,000)
  → Remaining to cap: 15,000 Honor

⚔️ Conquest: 1,567 (Weekly: 0 / 1,350)
  → Remaining to cap: 1,350 Conquest

⏰ Weekly reset in: 6d 23h 58m
```

## Color Scheme

- **Background**: Dark grey/black (standard WoW UI)
- **Borders**: Gold (standard WoW frame border)
- **Text**: White (primary), Grey (secondary)
- **Honor**: Gold (#FFD100)
- **Conquest**: Purple (#A356EE)
- **Success/Complete**: Green (#00FF00)
- **Pending**: Yellow (#FFFF00)

## Integration with WoW UI

The addon uses Blizzard's standard UI templates:
- **BasicFrameTemplateWithInset**: Main window frame
- **UIPanelScrollFrameTemplate**: Scrollable content
- **UIPanelButtonTemplate**: Refresh button
- Standard WoW fonts and styling throughout

This ensures the addon looks and feels like a native part of the WoW interface.
