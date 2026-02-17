-- PVP Assist Localization Module
-- Supports English and Italian languages

local addonName, PVPAssist = ...

PVPAssist.L = {}
local L = PVPAssist.L

-- Detect client locale
local locale = GetLocale()

-- Default to English
local currentLang = "enUS"
if locale == "itIT" then
    currentLang = "itIT"
end

-- English translations
local enUS = {
    -- Main UI
    ["TITLE"] = "PVP Assist - Honor & Conquest Tracker",
    ["CURRENT_STATUS"] = "Current Status",
    ["RECOMMENDED_ACTIVITIES"] = "Recommended Activities",
    ["QUICK_JOIN"] = "Quick Join",
    ["WEEKLY_QUESTS"] = "Weekly PVP Quests",
    ["TIPS"] = "Tips",
    ["FUTURE_IMPLEMENTATION"] = "Future Implementation",
    
    -- Currency
    ["HONOR"] = "Honor",
    ["CONQUEST"] = "Conquest",
    ["WEEKLY"] = "Weekly",
    ["REMAINING_TO_CAP"] = "Remaining to cap",
    ["CAP_REACHED"] = "Weekly %s cap reached!",
    ["WEEKLY_RESET"] = "Weekly reset in: %s",
    
    -- Activities
    ["RANDOM_BG"] = "Random Battleground",
    ["EPIC_BG"] = "Epic Battleground",
    ["RATED_BG"] = "Rated Battleground",
    ["SOLO_SHUFFLE"] = "Solo Shuffle",
    ["ARENA_2V2"] = "Arena 2v2",
    ["ARENA_3V3"] = "Arena 3v3",
    ["ARENA_SKIRMISH"] = "Arena Skirmish",
    ["WORLD_PVP"] = "World PVP / War Mode",
    ["WEEKLY_BRAWL"] = "Weekly PVP Brawl",
    
    -- Rewards
    ["HONOR_REWARD"] = "~%d-%d Honor per win",
    ["CONQUEST_REWARD"] = "~%d-%d Conquest per win",
    ["VARIABLE_REWARD"] = "Variable rewards",
    
    -- Tooltips
    ["TOOLTIP_RANDOM_BG"] = "Click to join Random Battleground queue\nReward: ~200-400 Honor per win\nQuick honor gains",
    ["TOOLTIP_EPIC_BG"] = "Click to join Epic Battleground queue\nReward: ~300-600 Honor per win\nLarger scale battles",
    ["TOOLTIP_RATED_BG"] = "Click to join Rated Battleground queue\nReward: ~50-100 Conquest per win\nCompetitive rated PVP",
    ["TOOLTIP_SOLO_SHUFFLE"] = "Click to join Solo Shuffle queue\nReward: ~30-60 Conquest per round\nSolo queue rated arena",
    ["TOOLTIP_ARENA_2V2"] = "Click to open LFG for 2v2 Arena\nReward: ~25-50 Conquest per win\nFind arena partners",
    ["TOOLTIP_ARENA_3V3"] = "Click to open LFG for 3v3 Arena\nReward: ~25-50 Conquest per win\nFind arena partners",
    ["TOOLTIP_ARENA_SKIRMISH"] = "Click to join Arena Skirmish\nReward: ~15-30 Honor per win\nPractice arena battles",
    
    -- Buttons
    ["REFRESH"] = "Refresh",
    ["JOIN_QUEUE"] = "Join Queue",
    ["OPEN_LFG"] = "Open LFG",
    
    -- Role Selection
    ["SELECT_ROLE"] = "Select Role:",
    ["ROLE_TANK"] = "Tank",
    ["ROLE_HEALER"] = "Healer",
    ["ROLE_DPS"] = "DPS",
    ["CHANGED_SPEC"] = "Changed specialization to %s",
    ["CANNOT_CHANGE_SPEC_COMBAT"] = "Cannot change specialization while in combat",
    ["NO_SPEC_FOR_ROLE"] = "No specialization available for selected role",
    ["TOOLTIP_WILL_CHANGE_SPEC"] = "Will change to %s spec: %s",
    
    -- Tips
    ["TIP_1"] = "Complete daily/weekly quests for bonus rewards",
    ["TIP_2"] = "Enable War Mode for 10-30% bonus honor",
    ["TIP_3"] = "Rated content gives better conquest rewards",
    ["TIP_4"] = "Check group finder for active PVP groups",
    
    -- Future features
    ["FUTURE_FEATURES"] = "Planned Features:",
    ["FUTURE_STAT_TRACKING"] = "• Historical statistics and performance tracking",
    ["FUTURE_NOTIFICATIONS"] = "• Alert notifications when near weekly cap",
    ["FUTURE_GEAR_GUIDE"] = "• PVP gear upgrade recommendations",
    ["FUTURE_RATING_TRACKER"] = "• Arena/RBG rating progression tracker",
    ["FUTURE_LEADERBOARD"] = "• Compare progress with friends",
    
    -- Messages
    ["ALL_CAPS_REACHED"] = "All weekly caps reached! Great job!",
    ["DATA_REFRESHED"] = "Data refreshed!",
    ["JOINED_QUEUE"] = "Joining %s queue...",
    ["OPENING_LFG"] = "Opening Group Finder for %s...",
}

-- Italian translations
local itIT = {
    -- Main UI
    ["TITLE"] = "PVP Assist - Tracker Onore & Conquista",
    ["CURRENT_STATUS"] = "Stato Attuale",
    ["RECOMMENDED_ACTIVITIES"] = "Attività Consigliate",
    ["QUICK_JOIN"] = "Accesso Rapido",
    ["WEEKLY_QUESTS"] = "Missioni PVP Settimanali",
    ["TIPS"] = "Suggerimenti",
    ["FUTURE_IMPLEMENTATION"] = "Implementazioni Future",
    
    -- Currency
    ["HONOR"] = "Onore",
    ["CONQUEST"] = "Conquista",
    ["WEEKLY"] = "Settimanale",
    ["REMAINING_TO_CAP"] = "Rimanente al limite",
    ["CAP_REACHED"] = "Limite settimanale di %s raggiunto!",
    ["WEEKLY_RESET"] = "Reset settimanale tra: %s",
    
    -- Activities
    ["RANDOM_BG"] = "Campo di Battaglia Casuale",
    ["EPIC_BG"] = "Campo di Battaglia Epico",
    ["RATED_BG"] = "Campo di Battaglia Valutato",
    ["SOLO_SHUFFLE"] = "Solo Shuffle",
    ["ARENA_2V2"] = "Arena 2v2",
    ["ARENA_3V3"] = "Arena 3v3",
    ["ARENA_SKIRMISH"] = "Schermaglia Arena",
    ["WORLD_PVP"] = "PVP Mondiale / Modalità Guerra",
    ["WEEKLY_BRAWL"] = "Rissa PVP Settimanale",
    
    -- Rewards
    ["HONOR_REWARD"] = "~%d-%d Onore per vittoria",
    ["CONQUEST_REWARD"] = "~%d-%d Conquista per vittoria",
    ["VARIABLE_REWARD"] = "Ricompense variabili",
    
    -- Tooltips
    ["TOOLTIP_RANDOM_BG"] = "Clicca per entrare in coda Campo di Battaglia Casuale\nRicompensa: ~200-400 Onore per vittoria\nGuadagni rapidi di onore",
    ["TOOLTIP_EPIC_BG"] = "Clicca per entrare in coda Campo di Battaglia Epico\nRicompensa: ~300-600 Onore per vittoria\nBattaglie su larga scala",
    ["TOOLTIP_RATED_BG"] = "Clicca per entrare in coda Campo di Battaglia Valutato\nRicompensa: ~50-100 Conquista per vittoria\nPVP competitivo valutato",
    ["TOOLTIP_SOLO_SHUFFLE"] = "Clicca per entrare in coda Solo Shuffle\nRicompensa: ~30-60 Conquista per round\nArena valutata in coda singola",
    ["TOOLTIP_ARENA_2V2"] = "Clicca per aprire Ricerca Gruppo per Arena 2v2\nRicompensa: ~25-50 Conquista per vittoria\nTrova compagni di arena",
    ["TOOLTIP_ARENA_3V3"] = "Clicca per aprire Ricerca Gruppo per Arena 3v3\nRicompensa: ~25-50 Conquista per vittoria\nTrova compagni di arena",
    ["TOOLTIP_ARENA_SKIRMISH"] = "Clicca per entrare in Schermaglia Arena\nRicompensa: ~15-30 Onore per vittoria\nBattaglie di pratica in arena",
    
    -- Buttons
    ["REFRESH"] = "Aggiorna",
    ["JOIN_QUEUE"] = "Entra in Coda",
    ["OPEN_LFG"] = "Apri Ricerca Gruppo",
    
    -- Role Selection
    ["SELECT_ROLE"] = "Seleziona Ruolo:",
    ["ROLE_TANK"] = "Tank",
    ["ROLE_HEALER"] = "Healer",
    ["ROLE_DPS"] = "DPS",
    ["CHANGED_SPEC"] = "Specializzazione cambiata in %s",
    ["CANNOT_CHANGE_SPEC_COMBAT"] = "Impossibile cambiare specializzazione durante il combattimento",
    ["NO_SPEC_FOR_ROLE"] = "Nessuna specializzazione disponibile per il ruolo selezionato",
    ["TOOLTIP_WILL_CHANGE_SPEC"] = "Cambierà in spec %s: %s",
    
    -- Tips
    ["TIP_1"] = "Completa missioni giornaliere/settimanali per ricompense bonus",
    ["TIP_2"] = "Attiva Modalità Guerra per 10-30% bonus onore",
    ["TIP_3"] = "I contenuti valutati danno migliori ricompense conquista",
    ["TIP_4"] = "Controlla il cercatore di gruppi per gruppi PVP attivi",
    
    -- Future features
    ["FUTURE_FEATURES"] = "Funzionalità Pianificate:",
    ["FUTURE_STAT_TRACKING"] = "• Statistiche storiche e tracciamento prestazioni",
    ["FUTURE_NOTIFICATIONS"] = "• Notifiche di avviso vicino al limite settimanale",
    ["FUTURE_GEAR_GUIDE"] = "• Raccomandazioni per miglioramenti equipaggiamento PVP",
    ["FUTURE_RATING_TRACKER"] = "• Tracker progressione rating Arena/CdB Valutato",
    ["FUTURE_LEADERBOARD"] = "• Confronta progressi con gli amici",
    
    -- Messages
    ["ALL_CAPS_REACHED"] = "Tutti i limiti settimanali raggiunti! Ottimo lavoro!",
    ["DATA_REFRESHED"] = "Dati aggiornati!",
    ["JOINED_QUEUE"] = "Entrando in coda %s...",
    ["OPENING_LFG"] = "Apertura Ricerca Gruppo per %s...",
}

-- Set up localization table
local translations = {
    enUS = enUS,
    itIT = itIT
}

-- Metatable for localization
setmetatable(L, {
    __index = function(t, key)
        return translations[currentLang][key] or translations["enUS"][key] or key
    end
})

-- Function to get current language
function PVPAssist:GetLocale()
    return currentLang
end

-- Function to change language (optional)
function PVPAssist:SetLocale(lang)
    if translations[lang] then
        currentLang = lang
        return true
    end
    return false
end
