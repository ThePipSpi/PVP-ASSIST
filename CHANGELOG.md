# Changelog

All notable changes to PVP Assist will be documented in this file.

## [1.0.0] - 2026-02-17

### Added
- Initial release of PVP Assist addon
- Real-time Honor and Conquest tracking
- Weekly cap monitoring and calculations
- Smart activity recommendations based on remaining caps
- Honor activity suggestions:
  - Random Battlegrounds
  - Epic Battlegrounds
  - World PVP / War Mode
- Conquest activity suggestions:
  - Rated Battlegrounds
  - Arena (2v2, 3v3)
  - Rated Solo Shuffle
  - Weekly PVP Brawl
- Weekly PVP quest tracking
- Weekly reset countdown timer
- Main UI window with scrollable content
- Minimap button for easy access
- Slash commands `/pvpassist` and `/pvpa`
- Refresh button to update data manually
- Automatic UI updates on currency changes
- SavedVariables for data persistence
- Comprehensive documentation:
  - Installation guide (English)
  - Installation guide (Italian - INSTALLAZIONE.md)
  - API integration notes
  - UI guide with visual descriptions
  - README with features and usage

### Technical Details
- Uses WoW API: C_CurrencyInfo, C_DateAndTime, C_QuestLog
- Interface version: 110002 (Dragonflight/The War Within)
- Honor currency ID: 1792
- Conquest currency ID: 1602
- Fully self-contained, no external dependencies

### Future Considerations
- Potential Wowhead API integration
- Blizzard Battle.net API integration for character data
- Historical tracking of weekly earnings
- Customizable recommendations
- Alert notifications
- Season-specific tracking

---

## Future Versions

### [Planned] - API Integration
- Integration with Blizzard Battle.net API
- Real-time season and cap information
- Character-specific PVP statistics
- Rating-based recommendations
- Achievement progress tracking

### [Planned] - Enhanced Tracking
- Historical data visualization
- Weekly/monthly/seasonal statistics
- Comparison with previous weeks
- Goal setting and progress tracking

### [Planned] - Notifications
- Alert when approaching weekly cap
- Reminder for incomplete weekly quests
- Season end notifications
- New PVP content alerts

### [Planned] - Customization
- Configurable activity priorities
- Custom reward estimates
- UI theme options
- Minimap button position customization
