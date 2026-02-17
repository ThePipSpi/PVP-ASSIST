# API Integration Notes

## Current Implementation

The addon currently uses World of Warcraft's built-in API functions to track Honor and Conquest:

### WoW API Functions Used

1. **C_CurrencyInfo.GetCurrencyInfo(currencyID)**
   - Returns information about a specific currency
   - Used for Honor (ID: 1792) and Conquest (ID: 1602)
   - Provides: current amount, weekly earned, weekly max

2. **C_DateAndTime.GetSecondsUntilWeeklyReset()**
   - Returns seconds until the weekly PVP reset
   - Used to display reset timer

3. **C_QuestLog.IsQuestFlaggedCompleted(questID)**
   - Checks if a quest has been completed
   - Used for tracking weekly PVP quests

## Future Wowhead API Integration

The initial request mentioned integrating with Wowhead or similar APIs. Here are some possibilities:

### Wowhead Classic API

While Wowhead doesn't provide a public REST API for real-time game data, we could potentially:

1. **Static Data Integration**
   - Use Wowhead's tooltips/item database for reference data
   - Link activities to Wowhead guides
   - Display item/achievement information

2. **Community Data**
   - Aggregate player-reported data on honor/conquest gain rates
   - Track average rewards per activity type
   - Update recommendations based on current season

### Alternative API Options

1. **Blizzard Battle.net API**
   - Official API from Blizzard
   - Provides character statistics, PVP ratings, achievements
   - Requires OAuth authentication
   - Could be used to:
     - Verify weekly caps and season information
     - Get accurate conquest cap calculations
     - Track PVP bracket ratings
     - Show PVP achievements progress

2. **Raider.IO API**
   - Provides PVP leaderboard data
   - Could show rankings and compare progress
   - Track rating milestones

## Implementation Plan for API Integration

To add Blizzard API integration:

1. Register an application at https://develop.battle.net/
2. Implement OAuth flow (requires web interface)
3. Add HTTP request functionality
4. Cache API responses to minimize requests
5. Update UI to show additional data:
   - Current PVP rating
   - Season rankings
   - Accurate weekly caps based on rating
   - PVP achievements progress

### Example API Endpoint

```
GET https://us.api.blizzard.com/profile/wow/character/{realm}/{character}/pvp-bracket/{bracket}
```

Returns:
- Season statistics
- Rating information
- Weekly wins/losses
- Conquest earned

## Current Limitations

Without external API integration, the addon relies on:
- In-game client data only
- Hardcoded activity reward estimates
- Player-reported quest IDs
- Generic weekly cap information

## Benefits of API Integration

1. **Accurate Data**: Real-time caps and season information
2. **Personalized**: Character-specific recommendations
3. **Historical**: Track progress over multiple weeks/seasons
4. **Competitive**: Compare against server/region averages

## Note

For the initial version (1.0.0), the addon functions entirely within WoW using built-in APIs. This is intentional to keep it simple and working without external dependencies. API integration can be added in future versions based on user feedback and needs.
