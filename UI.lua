-- PVP Assist UI Module
-- Creates and manages the main UI window

local addonName, PVPAssist = ...

-- Create main frame
local mainFrame = CreateFrame("Frame", "PVPAssistMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 700)
mainFrame:SetPoint("CENTER")
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:Hide()

-- Set frame title (will be updated with localization)
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY")
mainFrame.title:SetFontObject("GameFontHighlight")
mainFrame.title:SetPoint("LEFT", mainFrame.TitleBg, "LEFT", 5, 0)

-- Create scroll frame for content
local scrollFrame = CreateFrame("ScrollFrame", nil, mainFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", mainFrame.InsetBg, "TOPLEFT", 4, -4)
scrollFrame:SetPoint("BOTTOMRIGHT", mainFrame.InsetBg, "BOTTOMRIGHT", -24, 4)

local scrollChild = CreateFrame("Frame")
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetWidth(scrollFrame:GetWidth())
scrollChild:SetHeight(1)

-- Content container
local contentFrame = scrollChild

-- Function to create a section header
local function CreateSectionHeader(parent, text, yOffset)
    local header = parent:CreateFontString(nil, "OVERLAY")
    header:SetFontObject("GameFontNormalLarge")
    header:SetPoint("TOPLEFT", 10, yOffset)
    header:SetText(text)
    return header
end

-- Function to create info text
local function CreateInfoText(parent, text, yOffset, color)
    local info = parent:CreateFontString(nil, "OVERLAY")
    info:SetFontObject("GameFontHighlightSmall")
    info:SetPoint("TOPLEFT", 20, yOffset)
    info:SetText(text)
    info:SetWidth(380)
    info:SetJustifyH("LEFT")
    info:SetWordWrap(true)
    
    if color then
        info:SetTextColor(color.r, color.g, color.b)
    end
    
    return info
end

-- Toggle main frame
function PVPAssist:ToggleMainFrame()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        self:UpdateUI()
        mainFrame:Show()
    end
end

-- Update UI with current data
function PVPAssist:UpdateUI()
    local L = PVPAssist.L or {}
    
    -- Update title with localized text
    mainFrame.title:SetText(L["TITLE"] or "PVP Assist - Honor & Conquest Tracker")
    
    -- Clear existing content
    for _, child in pairs({contentFrame:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    local yOffset = -10
    local spacing = -20
    
    -- Live Session Tracking
    if PVPAssist.QuickJoin then
        local trackingData = PVPAssist.QuickJoin:GetLiveRewardTracking()
        if trackingData.sessionHonor > 0 or trackingData.sessionConquest > 0 then
            CreateSectionHeader(contentFrame, "📊 Session Tracking", yOffset)
            yOffset = yOffset + spacing
            
            if trackingData.sessionHonor > 0 then
                local sessionText = string.format("  Session %s: +%d", L["HONOR"] or "Honor", trackingData.sessionHonor)
                CreateInfoText(contentFrame, sessionText, yOffset, {r=1, g=0.82, b=0})
                yOffset = yOffset + spacing
            end
            
            if trackingData.sessionConquest > 0 then
                local sessionText = string.format("  Session %s: +%d", L["CONQUEST"] or "Conquest", trackingData.sessionConquest)
                CreateInfoText(contentFrame, sessionText, yOffset, {r=0.64, g=0.21, b=0.93})
                yOffset = yOffset + spacing
            end
            
            yOffset = yOffset + spacing * 0.5
        end
    end
    
    -- Currency Status Section
    CreateSectionHeader(contentFrame, L["CURRENT_STATUS"] or "Current Status", yOffset)
    yOffset = yOffset + spacing
    
    local currency = self:GetCurrentCurrency()
    local remaining = self:GetRemainingPoints()
    
    -- Honor info
    local honorText = string.format("%s: %d (%s: %d / %d)", 
        L["HONOR"] or "Honor",
        currency.honor.current,
        L["WEEKLY"] or "Weekly",
        currency.honor.weeklyEarned,
        currency.honor.weeklyMax > 0 and currency.honor.weeklyMax or "No Cap")
    CreateInfoText(contentFrame, honorText, yOffset, {r=1, g=0.82, b=0})
    yOffset = yOffset + spacing
    
    if remaining.honorRemaining > 0 then
        local remainText = string.format("  → %s: %d %s", L["REMAINING_TO_CAP"] or "Remaining to cap", remaining.honorRemaining, L["HONOR"] or "Honor")
        CreateInfoText(contentFrame, remainText, yOffset, {r=0.5, g=1, b=0.5})
        yOffset = yOffset + spacing
    else
        CreateInfoText(contentFrame, "  → " .. string.format(L["CAP_REACHED"] or "Weekly %s cap reached!", L["HONOR"] or "Honor"), yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Conquest info
    local conquestText = string.format("%s: %d (%s: %d / %d)", 
        L["CONQUEST"] or "Conquest",
        currency.conquest.current,
        L["WEEKLY"] or "Weekly",
        currency.conquest.weeklyEarned,
        currency.conquest.weeklyMax > 0 and currency.conquest.weeklyMax or "No Cap")
    CreateInfoText(contentFrame, conquestText, yOffset, {r=0.64, g=0.21, b=0.93})
    yOffset = yOffset + spacing
    
    if remaining.conquestRemaining > 0 then
        local remainText = string.format("  → %s: %d %s", L["REMAINING_TO_CAP"] or "Remaining to cap", remaining.conquestRemaining, L["CONQUEST"] or "Conquest")
        CreateInfoText(contentFrame, remainText, yOffset, {r=0.5, g=1, b=0.5})
        yOffset = yOffset + spacing
    else
        CreateInfoText(contentFrame, "  → " .. string.format(L["CAP_REACHED"] or "Weekly %s cap reached!", L["CONQUEST"] or "Conquest"), yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Time until reset
    local resetTime = self:GetTimeUntilReset()
    CreateInfoText(contentFrame, string.format(L["WEEKLY_RESET"] or "Weekly reset in: %s", resetTime), yOffset, {r=0.8, g=0.8, b=0.8})
    yOffset = yOffset + spacing * 1.5
    
    -- Quick Join Section
    if PVPAssist.QuickJoin then
        CreateSectionHeader(contentFrame, "⚔️ " .. (L["QUICK_JOIN"] or "Quick Join"), yOffset)
        yOffset = yOffset + spacing
        
        -- Add quick join buttons for various activities
        local qj = PVPAssist.QuickJoin
        
        -- Random BG
        local _, newOffset = qj:CreateQuickJoinButton(contentFrame, "RANDOM_BG", yOffset)
        yOffset = newOffset
        
        -- Epic BG
        _, newOffset = qj:CreateQuickJoinButton(contentFrame, "EPIC_BG", yOffset)
        yOffset = newOffset
        
        -- Solo Shuffle
        _, newOffset = qj:CreateQuickJoinButton(contentFrame, "SOLO_SHUFFLE", yOffset)
        yOffset = newOffset
        
        -- Rated BG
        _, newOffset = qj:CreateQuickJoinButton(contentFrame, "RATED_BG", yOffset)
        yOffset = newOffset
        
        -- Arena 2v2 (opens LFG)
        _, newOffset = qj:CreateArenaButton(contentFrame, "2V2", yOffset)
        yOffset = newOffset
        
        -- Arena 3v3 (opens LFG)
        _, newOffset = qj:CreateArenaButton(contentFrame, "3V3", yOffset)
        yOffset = newOffset
        
        -- Arena Skirmish
        _, newOffset = qj:CreateQuickJoinButton(contentFrame, "ARENA_SKIRMISH", yOffset)
        yOffset = newOffset
        
        yOffset = yOffset + spacing * 0.5
    end
    
    -- Recommended Activities Section
    CreateSectionHeader(contentFrame, L["RECOMMENDED_ACTIVITIES"] or "Recommended Activities", yOffset)
    yOffset = yOffset + spacing
    
    local activities = self:GetRecommendedActivities()
    
    if #activities == 0 then
        CreateInfoText(contentFrame, L["ALL_CAPS_REACHED"] or "✓ All weekly caps reached! Great job!", yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    else
        -- Sort by type and priority
        table.sort(activities, function(a, b)
            if a.type == b.type then
                return a.priority < b.priority
            end
            return a.type < b.type
        end)
        
        local lastType = nil
        for _, activity in ipairs(activities) do
            -- Type header
            if activity.type ~= lastType then
                local typeColor = activity.type == "honor" and {r=1, g=0.82, b=0} or {r=0.64, g=0.21, b=0.93}
                local typeHeader = activity.type == "honor" and "Honor Activities:" or "Conquest Activities:"
                CreateInfoText(contentFrame, typeHeader, yOffset, typeColor)
                yOffset = yOffset + spacing
                lastType = activity.type
            end
            
            -- Activity name
            local activityText = string.format("• %s", activity.name)
            CreateInfoText(contentFrame, activityText, yOffset, {r=1, g=1, b=1})
            yOffset = yOffset + spacing
            
            -- Activity details
            local detailsText = string.format("  %s - %s", activity.reward, activity.description)
            CreateInfoText(contentFrame, detailsText, yOffset, {r=0.7, g=0.7, b=0.7})
            yOffset = yOffset + spacing + -5
        end
    end
    
    yOffset = yOffset + spacing * 0.5
    
    -- Weekly Quests Section
    CreateSectionHeader(contentFrame, L["WEEKLY_QUESTS"] or "Weekly PVP Quests", yOffset)
    yOffset = yOffset + spacing
    
    local quests = self:GetWeeklyQuestStatus()
    
    if #quests > 0 then
        for _, quest in ipairs(quests) do
            local status = quest.completed and "✓" or "○"
            local statusColor = quest.completed and {r=0, g=1, b=0} or {r=1, g=1, b=0}
            
            local questText = string.format("%s %s", status, quest.name)
            CreateInfoText(contentFrame, questText, yOffset, statusColor)
            yOffset = yOffset + spacing
            
            local rewardText = string.format("  Reward: %s - %s", quest.reward, quest.description)
            CreateInfoText(contentFrame, rewardText, yOffset, {r=0.7, g=0.7, b=0.7})
            yOffset = yOffset + spacing + -5
        end
    else
        CreateInfoText(contentFrame, "No weekly quests tracked", yOffset, {r=0.7, g=0.7, b=0.7})
        yOffset = yOffset + spacing
    end
    
    yOffset = yOffset + spacing * 0.5
    
    -- Tips Section
    CreateSectionHeader(contentFrame, L["TIPS"] or "Tips", yOffset)
    yOffset = yOffset + spacing
    
    CreateInfoText(contentFrame, L["TIP_1"] or "• Complete daily/weekly quests for bonus rewards", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["TIP_2"] or "• Enable War Mode for 10-30% bonus honor", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["TIP_3"] or "• Rated content gives better conquest rewards", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["TIP_4"] or "• Check group finder for active PVP groups", yOffset)
    yOffset = yOffset + spacing * 1.5
    
    -- Future Implementation Section
    CreateSectionHeader(contentFrame, "🔮 " .. (L["FUTURE_IMPLEMENTATION"] or "Future Implementation"), yOffset)
    yOffset = yOffset + spacing
    
    CreateInfoText(contentFrame, L["FUTURE_FEATURES"] or "Planned Features:", yOffset, {r=0.7, g=0.9, b=1})
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["FUTURE_STAT_TRACKING"] or "• Historical statistics and performance tracking", yOffset, {r=0.6, g=0.6, b=0.6})
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["FUTURE_NOTIFICATIONS"] or "• Alert notifications when near weekly cap", yOffset, {r=0.6, g=0.6, b=0.6})
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["FUTURE_GEAR_GUIDE"] or "• PVP gear upgrade recommendations", yOffset, {r=0.6, g=0.6, b=0.6})
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["FUTURE_RATING_TRACKER"] or "• Arena/RBG rating progression tracker", yOffset, {r=0.6, g=0.6, b=0.6})
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, L["FUTURE_LEADERBOARD"] or "• Compare progress with friends", yOffset, {r=0.6, g=0.6, b=0.6})
    yOffset = yOffset + spacing * 1.5
    
    -- Footer
    CreateInfoText(contentFrame, "Addon by ThePipSpi - Version " .. PVPAssist.version, yOffset, {r=0.5, g=0.5, b=0.5})
    yOffset = yOffset + spacing
    
    -- Set scroll child height
    scrollChild:SetHeight(math.abs(yOffset) + 20)
end

-- Create minimap button (optional feature)
local minimapButton = CreateFrame("Button", "PVPAssistMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)
minimapButton:SetPoint("TOPRIGHT", -10, -10)
minimapButton:SetMovable(true)
minimapButton:EnableMouse(true)
minimapButton:RegisterForDrag("LeftButton")
minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

-- Minimap button icon
local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\Achievement_BG_winWSG")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", 0, 1)

-- Minimap button border
local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(54, 54)
border:SetPoint("TOPLEFT")

-- Minimap button click handler
minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        PVPAssist:ToggleMainFrame()
    end
end)

-- Minimap button tooltip
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("PVP Assist", 1, 1, 1)
    GameTooltip:AddLine("Left-click to open tracker", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Refresh button
local refreshButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
refreshButton:SetSize(100, 25)
refreshButton:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 10, 10)
refreshButton:SetScript("OnClick", function()
    PVPAssist:UpdateUI()
    local L = PVPAssist.L or {}
    print("|cff00ff00PVP Assist:|r " .. (L["DATA_REFRESHED"] or "Data refreshed!"))
end)

-- Update button text when UI updates
local function UpdateRefreshButton()
    local L = PVPAssist.L or {}
    refreshButton:SetText(L["REFRESH"] or "Refresh")
end

-- Hook into UpdateUI to update button text
local originalUpdateUI = PVPAssist.UpdateUI
PVPAssist.UpdateUI = function(self)
    originalUpdateUI(self)
    UpdateRefreshButton()
end

-- Close button is already provided by BasicFrameTemplateWithInset
