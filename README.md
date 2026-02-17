# PVP-ASSIST

A World of Warcraft addon that helps players track and maximize their Honor and Conquest points in PVP.

## Features

- **Real-time Currency Tracking**: Monitor your current Honor and Conquest points
- **Weekly Cap Monitoring**: See how much you've earned vs the weekly cap
- **Smart Activity Recommendations**: Get prioritized suggestions for earning points efficiently
- **Weekly Quest Tracking**: Track PVP weekly quests and their completion status
- **Reset Timer**: Know exactly when the weekly reset occurs
- **Easy Access**: Minimap button and slash commands for quick access

## Installation

1. Download the addon files
2. Extract the `PVP-ASSIST` folder to your World of Warcraft addons directory:
   - Windows: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - Mac: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
3. Restart World of Warcraft or reload UI with `/reload`

## Usage

### Opening the Tracker

Use any of these methods:
- Click the minimap button (PVP sword icon)
- Type `/pvpassist` or `/pvpa` in chat

### Understanding the Interface

The tracker shows several sections:

#### Current Status
- Your current Honor and Conquest totals
- Weekly earned amounts vs caps
- Remaining points needed to reach weekly caps
- Time until weekly reset

#### Recommended Activities

Based on your remaining caps, you'll see suggestions for:

**Honor Activities:**
- Random Battlegrounds (~200-400 per win)
- Epic Battlegrounds (~300-600 per win)
- World PVP with War Mode enabled

**Conquest Activities:**
- Rated Battlegrounds (~50-100 per win)
- Arena matches 2v2/3v3 (~25-50 per win)
- Rated Solo Shuffle (~30-60 per round)
- Weekly PVP Brawl (bonus conquest)

#### Weekly Quests
Track your progress on weekly PVP quests that offer bonus rewards.

#### Tips
Helpful reminders for maximizing your PVP gains.

## Slash Commands

- `/pvpassist` - Toggle the main tracker window
- `/pvpa` - Short version of /pvpassist

## Technical Details

### Currency IDs
- Honor: 1792
- Conquest: 1602

### Compatibility
- Designed for WoW Retail (Dragonflight/The War Within)
- Interface version: 110002

### Data Storage
The addon saves minimal data in `PVPAssistDB` including:
- Weekly tracking information
- Last update timestamp
- Tracked activities

## Future Enhancements

Potential features for future versions:
- Integration with Wowhead API for real-time cap updates
- Historical tracking of weekly earnings
- Customizable activity recommendations
- Alert notifications when near cap
- Season-specific conquest tracking
- PVP gear upgrade recommendations

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Author

ThePipSpi

## Version

1.0.0

## License

This addon is free to use and modify.
