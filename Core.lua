-- PVP Assist Core Module
-- This addon helps players track and complete tasks to maximize Honor and Conquest points

local addonName, PVPAssist = ...

-- Initialize addon namespace
PVPAssist = PVPAssist or {}
PVPAssist.version = "1.0.0"

-- Default database structure
local defaults = {
    weeklyHonor = 0,
    weeklyConquest = 0,
    lastUpdate = 0,
    trackedActivities = {}
}

-- Initialize database
function PVPAssist:InitDB()
    if not PVPAssistDB then
        PVPAssistDB = {}
    end
    
    for key, value in pairs(defaults) do
        if PVPAssistDB[key] == nil then
            PVPAssistDB[key] = value
        end
    end
end

-- Get current Honor and Conquest points
function PVPAssist:GetCurrentCurrency()
    local honorInfo = C_CurrencyInfo.GetCurrencyInfo(1792) -- Honor currency ID
    local conquestInfo = C_CurrencyInfo.GetCurrencyInfo(1602) -- Conquest currency ID
    
    local data = {
        honor = {
            current = honorInfo and honorInfo.quantity or 0,
            weeklyMax = honorInfo and honorInfo.maxQuantity or 0,
            weeklyEarned = honorInfo and honorInfo.totalEarned or 0
        },
        conquest = {
            current = conquestInfo and conquestInfo.quantity or 0,
            weeklyMax = conquestInfo and conquestInfo.maxQuantity or 0,
            weeklyEarned = conquestInfo and conquestInfo.totalEarned or 0
        }
    }
    
    return data
end

-- Calculate remaining points needed for weekly cap
function PVPAssist:GetRemainingPoints()
    local currency = self:GetCurrentCurrency()
    
    return {
        honorRemaining = math.max(0, currency.honor.weeklyMax - currency.honor.weeklyEarned),
        conquestRemaining = math.max(0, currency.conquest.weeklyMax - currency.conquest.weeklyEarned)
    }
end

-- Get recommended PVP activities
function PVPAssist:GetRecommendedActivities()
    local remaining = self:GetRemainingPoints()
    local activities = {}
    
    -- Honor activities
    if remaining.honorRemaining > 0 then
        table.insert(activities, {
            type = "honor",
            name = "Random Battlegrounds",
            reward = "~200-400 Honor per win",
            priority = 1,
            description = "Quick honor gains through battlegrounds"
        })
        
        table.insert(activities, {
            type = "honor",
            name = "Epic Battlegrounds",
            reward = "~300-600 Honor per win",
            priority = 2,
            description = "Larger scale battles with good honor rewards"
        })
        
        table.insert(activities, {
            type = "honor",
            name = "World PVP / War Mode",
            reward = "Variable Honor",
            priority = 3,
            description = "World quests and kills with War Mode enabled"
        })
    end
    
    -- Conquest activities
    if remaining.conquestRemaining > 0 then
        table.insert(activities, {
            type = "conquest",
            name = "Rated Battlegrounds",
            reward = "~50-100 Conquest per win",
            priority = 1,
            description = "Rated PVP with guaranteed conquest"
        })
        
        table.insert(activities, {
            type = "conquest",
            name = "Arena (2v2, 3v3)",
            reward = "~25-50 Conquest per win",
            priority = 2,
            description = "Competitive arena matches"
        })
        
        table.insert(activities, {
            type = "conquest",
            name = "Rated Solo Shuffle",
            reward = "~30-60 Conquest per round",
            priority = 3,
            description = "Solo queue rated arena"
        })
        
        table.insert(activities, {
            type = "conquest",
            name = "Weekly PVP Brawl",
            reward = "Conquest bonus",
            priority = 4,
            description = "Special weekly event with conquest rewards"
        })
    end
    
    return activities
end

-- Get weekly quest status
function PVPAssist:GetWeeklyQuestStatus()
    local quests = {
        {
            name = "Preserving in PvP",
            questID = 72722, -- Example quest ID
            reward = "Conquest + Honor",
            description = "Complete PVP activities"
        },
        {
            name = "Arena Skirmishes",
            questID = 72723, -- Example quest ID
            reward = "Conquest",
            description = "Win arena skirmishes"
        }
    }
    
    local questStatus = {}
    for _, quest in ipairs(quests) do
        local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(quest.questID)
        table.insert(questStatus, {
            name = quest.name,
            completed = isCompleted,
            reward = quest.reward,
            description = quest.description
        })
    end
    
    return questStatus
end

-- Format time until reset
function PVPAssist:GetTimeUntilReset()
    local resetTime = C_DateAndTime.GetSecondsUntilWeeklyReset()
    
    if resetTime then
        local days = math.floor(resetTime / 86400)
        local hours = math.floor((resetTime % 86400) / 3600)
        local minutes = math.floor((resetTime % 3600) / 60)
        
        return string.format("%dd %dh %dm", days, hours, minutes)
    end
    
    return "Unknown"
end

-- Event handler frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            PVPAssist:InitDB()
            print("|cff00ff00PVP Assist loaded!|r Type /pvpassist to open the tracker.")
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        PVPAssist:InitDB()
    elseif event == "CURRENCY_DISPLAY_UPDATE" then
        -- Update UI when currency changes
        if PVPAssist.UpdateUI then
            PVPAssist:UpdateUI()
        end
    end
end)

-- Slash command
SLASH_PVPASSIST1 = "/pvpassist"
SLASH_PVPASSIST2 = "/pvpa"
SlashCmdList["PVPASSIST"] = function(msg)
    if PVPAssist.ToggleMainFrame then
        PVPAssist:ToggleMainFrame()
    end
end

-- Export to global namespace
_G["PVPAssist"] = PVPAssist
