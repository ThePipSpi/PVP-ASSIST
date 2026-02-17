# PVP Assist - User Interface Guide

## Main Window Layout

The PVP Assist window is a 450x550 pixel frame with the following sections:

### Window Header
```
+------------------------------------------+
|  PVP Assist - Honor & Conquest Tracker   |
|  [Minimize] [Close]                       |
+------------------------------------------+
```

### Section 1: Current Status

Shows real-time currency information:

```
Current Status
------------------
Honor: 15,432 (Weekly: 3,200 / 15,000)
  → Remaining to cap: 11,800 Honor

Conquest: 892 (Weekly: 450 / 1,350)
  → Remaining to cap: 900 Conquest

Weekly reset in: 3d 15h 42m
```

**Color Coding:**
- Honor values: Gold/Yellow (#FFD100)
- Conquest values: Purple (#A356EE)
- Remaining amounts: Light Green when incomplete
- Cap reached: Bright Green

### Section 2: Recommended Activities

Prioritized list based on what you need:

```
Recommended Activities
------------------
Honor Activities:
• Random Battlegrounds
  ~200-400 Honor per win - Quick honor gains through battlegrounds

• Epic Battlegrounds
  ~300-600 Honor per win - Larger scale battles with good honor rewards

• World PVP / War Mode
  Variable Honor - World quests and kills with War Mode enabled

Conquest Activities:
• Rated Battlegrounds
  ~50-100 Conquest per win - Rated PVP with guaranteed conquest

• Arena (2v2, 3v3)
  ~25-50 Conquest per win - Competitive arena matches

• Rated Solo Shuffle
  ~30-60 Conquest per round - Solo queue rated arena

• Weekly PVP Brawl
  Conquest bonus - Special weekly event with conquest rewards
```

### Section 3: Weekly PVP Quests

Tracks completion of weekly quests:

```
Weekly PVP Quests
------------------
✓ Preserving in PvP
  Reward: Conquest + Honor - Complete PVP activities

○ Arena Skirmishes
  Reward: Conquest - Win arena skirmishes
```

**Symbols:**
- ✓ = Completed (Green)
- ○ = Not completed (Yellow)

### Section 4: Tips

Helpful reminders:

```
Tips
------------------
• Complete daily/weekly quests for bonus rewards
• Enable War Mode for 10-30% bonus honor
• Rated content gives better conquest rewards
• Check group finder for active PVP groups
```

### Window Footer

```
+------------------------------------------+
| [Refresh]                                 |
| Addon by ThePipSpi - Version 1.0.0        |
+------------------------------------------+
```

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
Current Status
------------------
Honor: 28,450 (Weekly: 15,000 / 15,000)
  → Weekly Honor cap reached!

Conquest: 2,134 (Weekly: 1,350 / 1,350)
  → Weekly Conquest cap reached!

Recommended Activities
------------------
✓ All weekly caps reached! Great job!
```

### Fresh Week (After Reset)
```
Current Status
------------------
Honor: 24,328 (Weekly: 0 / 15,000)
  → Remaining to cap: 15,000 Honor

Conquest: 1,567 (Weekly: 0 / 1,350)
  → Remaining to cap: 1,350 Conquest

Weekly reset in: 6d 23h 58m
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
