-- PVP Assist Quick Join Module
-- Provides quick access buttons to join PVP queues

local addonName, PVPAssist = ...

PVPAssist.QuickJoin = {}
local QuickJoin = PVPAssist.QuickJoin

-- Queue types and their configurations
local QUEUE_TYPES = {
    RANDOM_BG = {
        id = 1, -- Random Battleground
        type = "battleground",
        honorMin = 200,
        honorMax = 400,
        conquestMin = 0,
        conquestMax = 0,
    },
    EPIC_BG = {
        id = 2, -- Epic Battleground  
        type = "battleground",
        honorMin = 300,
        honorMax = 600,
        conquestMin = 0,
        conquestMax = 0,
    },
    RATED_BG = {
        id = 3, -- Rated Battleground
        type = "rated",
        honorMin = 0,
        honorMax = 0,
        conquestMin = 50,
        conquestMax = 100,
    },
    SOLO_SHUFFLE = {
        id = 4, -- Solo Shuffle
        type = "soloqueue",
        honorMin = 0,
        honorMax = 0,
        conquestMin = 30,
        conquestMax = 60,
    },
    ARENA_SKIRMISH = {
        id = 5, -- Arena Skirmish
        type = "arena",
        honorMin = 15,
        honorMax = 30,
        conquestMin = 0,
        conquestMax = 0,
    },
}

-- Join a battleground queue
function QuickJoin:JoinBattleground(bgType)
    local L = PVPAssist.L
    
    if not C_PvP then
        print("|cffff0000PVP Assist:|r C_PvP API not available")
        return
    end
    
    if bgType == "RANDOM_BG" then
        -- Join random battleground
        C_PvP.JoinBattlefield(1) -- Random BG
        print("|cff00ff00PVP Assist:|r " .. string.format(L["JOINED_QUEUE"], L["RANDOM_BG"]))
    elseif bgType == "EPIC_BG" then
        -- Join epic battleground
        C_PvP.JoinBattlefield(2) -- Epic BG
        print("|cff00ff00PVP Assist:|r " .. string.format(L["JOINED_QUEUE"], L["EPIC_BG"]))
    elseif bgType == "RATED_BG" then
        -- Open rated battleground finder
        if PVEFrame_ShowFrame then
            PVEFrame_ShowFrame("PVPUIFrame", "RatedPvPFrame")
            print("|cff00ff00PVP Assist:|r " .. L["OPENING_LFG"] .. " " .. L["RATED_BG"])
        else
            print("|cffff0000PVP Assist:|r Unable to open Rated PVP frame")
        end
    end
end

-- Join solo shuffle queue
function QuickJoin:JoinSoloShuffle()
    local L = PVPAssist.L
    
    -- Open PVP UI to Solo Shuffle
    if PVPUIFrame then
        ShowUIPanel(PVPUIFrame)
        -- Navigate to Solo Shuffle tab
        if PVPQueueFrame and PVPQueueFrame.CategoryButton3 then
            PVPQueueFrame_SetCategoryButtonState(PVPQueueFrame.CategoryButton3)
        end
        print("|cff00ff00PVP Assist:|r " .. string.format(L["JOINED_QUEUE"], L["SOLO_SHUFFLE"]))
    else
        print("|cffff0000PVP Assist:|r Unable to open PVP UI")
    end
end

-- Join arena skirmish
function QuickJoin:JoinArenaSkirmish()
    local L = PVPAssist.L
    
    -- Join arena skirmish queue
    if C_PvP and C_PvP.JoinSkirmish then
        C_PvP.JoinSkirmish()
        print("|cff00ff00PVP Assist:|r " .. string.format(L["JOINED_QUEUE"], L["ARENA_SKIRMISH"]))
    else
        print("|cffff0000PVP Assist:|r Arena skirmish not available")
    end
end

-- Open LFG for arena (2v2 or 3v3)
function QuickJoin:OpenArenaLFG(arenaType)
    local L = PVPAssist.L
    
    -- Open the group finder to arena section
    if PVEFrame and PVEFrame_ShowFrame then
        PVEFrame_ShowFrame("GroupFinderFrame", "GroupFinderFrame")
        
        -- Try to navigate to the Premade Groups tab
        if LFGListFrame and LFGListFrame_SetActivePanel then
            LFGListFrame_SetActivePanel(LFGListFrame, LFGListFrame.CategorySelection)
            -- Category 4 is typically PvP
            if C_LFGList then
                C_LFGList.SetSearchToQuestActiveOnly(false)
            end
        end
        
        local arenaName = arenaType == "2v2" and L["ARENA_2V2"] or L["ARENA_3V3"]
        print("|cff00ff00PVP Assist:|r " .. string.format(L["OPENING_LFG"], arenaName))
    else
        print("|cffff0000PVP Assist:|r Unable to open Group Finder")
    end
end

-- Get reward information for an activity
function QuickJoin:GetRewardInfo(activityKey)
    local config = QUEUE_TYPES[activityKey]
    if not config then return "" end
    
    local L = PVPAssist.L
    local rewardText = ""
    
    if config.honorMax > 0 then
        rewardText = string.format(L["HONOR_REWARD"], config.honorMin, config.honorMax)
    elseif config.conquestMax > 0 then
        rewardText = string.format(L["CONQUEST_REWARD"], config.conquestMin, config.conquestMax)
    else
        rewardText = L["VARIABLE_REWARD"]
    end
    
    return rewardText
end

-- Create a quick join button
function QuickJoin:CreateQuickJoinButton(parent, activityKey, yOffset)
    local L = PVPAssist.L
    local config = QUEUE_TYPES[activityKey]
    
    if not config then return nil, yOffset end
    
    -- Create button container
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(380, 35)
    container:SetPoint("TOPLEFT", 10, yOffset)
    
    -- Activity name label
    local nameLabel = container:CreateFontString(nil, "OVERLAY")
    nameLabel:SetFontObject("GameFontNormal")
    nameLabel:SetPoint("LEFT", 5, 0)
    nameLabel:SetText(L[activityKey])
    
    -- Reward label
    local rewardLabel = container:CreateFontString(nil, "OVERLAY")
    rewardLabel:SetFontObject("GameFontHighlightSmall")
    rewardLabel:SetPoint("LEFT", nameLabel, "LEFT", 0, -15)
    rewardLabel:SetText(self:GetRewardInfo(activityKey))
    
    if config.honorMax > 0 then
        rewardLabel:SetTextColor(1, 0.82, 0) -- Gold for honor
    elseif config.conquestMax > 0 then
        rewardLabel:SetTextColor(0.64, 0.21, 0.93) -- Purple for conquest
    else
        rewardLabel:SetTextColor(0.7, 0.7, 0.7)
    end
    
    -- Quick join button
    local button = CreateFrame("Button", nil, container, "UIPanelButtonTemplate")
    button:SetSize(90, 25)
    button:SetPoint("RIGHT", -5, 0)
    button:SetText(L["JOIN_QUEUE"])
    
    -- Set up button functionality
    button:SetScript("OnClick", function()
        if activityKey == "RANDOM_BG" or activityKey == "EPIC_BG" or activityKey == "RATED_BG" then
            self:JoinBattleground(activityKey)
        elseif activityKey == "SOLO_SHUFFLE" then
            self:JoinSoloShuffle()
        elseif activityKey == "ARENA_SKIRMISH" then
            self:JoinArenaSkirmish()
        end
    end)
    
    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L[activityKey], 1, 1, 1, 1, true)
        GameTooltip:AddLine(L["TOOLTIP_" .. activityKey], nil, nil, nil, true)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    return container, yOffset - 40
end

-- Create arena LFG button (special case for 2v2/3v3)
function QuickJoin:CreateArenaButton(parent, arenaType, yOffset)
    local L = PVPAssist.L
    
    -- Create button container
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(380, 35)
    container:SetPoint("TOPLEFT", 10, yOffset)
    
    -- Arena name label
    local nameLabel = container:CreateFontString(nil, "OVERLAY")
    nameLabel:SetFontObject("GameFontNormal")
    nameLabel:SetPoint("LEFT", 5, 0)
    nameLabel:SetText(L["ARENA_" .. arenaType])
    
    -- Reward label
    local rewardLabel = container:CreateFontString(nil, "OVERLAY")
    rewardLabel:SetFontObject("GameFontHighlightSmall")
    rewardLabel:SetPoint("LEFT", nameLabel, "LEFT", 0, -15)
    rewardLabel:SetText(string.format(L["CONQUEST_REWARD"], 25, 50))
    rewardLabel:SetTextColor(0.64, 0.21, 0.93) -- Purple for conquest
    
    -- Open LFG button
    local button = CreateFrame("Button", nil, container, "UIPanelButtonTemplate")
    button:SetSize(90, 25)
    button:SetPoint("RIGHT", -5, 0)
    button:SetText(L["OPEN_LFG"])
    
    -- Set up button functionality
    button:SetScript("OnClick", function()
        self:OpenArenaLFG(arenaType)
    end)
    
    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["ARENA_" .. arenaType], 1, 1, 1, 1, true)
        GameTooltip:AddLine(L["TOOLTIP_ARENA_" .. arenaType], nil, nil, nil, true)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    return container, yOffset - 40
end

-- Get live reward tracking data
function QuickJoin:GetLiveRewardTracking()
    -- Track honor and conquest changes over time
    local currency = PVPAssist:GetCurrentCurrency()
    
    -- Check if we have previous data to compare
    if not PVPAssistDB.lastHonor then
        PVPAssistDB.lastHonor = currency.honor.current
        PVPAssistDB.lastConquest = currency.conquest.current
        PVPAssistDB.sessionHonor = 0
        PVPAssistDB.sessionConquest = 0
    end
    
    -- Calculate session gains
    local honorGain = currency.honor.current - PVPAssistDB.lastHonor
    local conquestGain = currency.conquest.current - PVPAssistDB.lastConquest
    
    -- Update session totals if positive gain
    if honorGain > 0 then
        PVPAssistDB.sessionHonor = (PVPAssistDB.sessionHonor or 0) + honorGain
        PVPAssistDB.lastHonor = currency.honor.current
    end
    
    if conquestGain > 0 then
        PVPAssistDB.sessionConquest = (PVPAssistDB.sessionConquest or 0) + conquestGain
        PVPAssistDB.lastConquest = currency.conquest.current
    end
    
    return {
        sessionHonor = PVPAssistDB.sessionHonor or 0,
        sessionConquest = PVPAssistDB.sessionConquest or 0,
        lastHonorGain = honorGain,
        lastConquestGain = conquestGain,
    }
end

-- Reset session tracking
function QuickJoin:ResetSessionTracking()
    PVPAssistDB.sessionHonor = 0
    PVPAssistDB.sessionConquest = 0
    local currency = PVPAssist:GetCurrentCurrency()
    PVPAssistDB.lastHonor = currency.honor.current
    PVPAssistDB.lastConquest = currency.conquest.current
end
