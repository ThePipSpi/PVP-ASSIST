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
    
    -- Quick Join Section
    if PVPAssist.QuickJoin then
        CreateSectionHeader(contentFrame, "⚔️ " .. (L["QUICK_JOIN"] or "Quick Join"), yOffset)
        yOffset = yOffset + spacing
        
        -- Add role selector
        local qj = PVPAssist.QuickJoin
        local _, newOffset = qj:CreateRoleSelector(contentFrame, yOffset)
        yOffset = newOffset
        
        -- Add quick join buttons for various activities
        
        -- Random BG
        _, newOffset = qj:CreateQuickJoinButton(contentFrame, "RANDOM_BG", yOffset)
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
    
    -- Live Session Tracking
    if PVPAssist.QuickJoin then
        local trackingData = PVPAssist.QuickJoin:GetLiveRewardTracking()
        if trackingData.sessionHonor > 0 or trackingData.sessionConquest > 0 then
            CreateSectionHeader(contentFrame, "📊 " .. (L["SESSION_TRACKING"] or "Session Tracking"), yOffset)
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
    
    -- Currency Status Section (moved under Quick Join)
    CreateSectionHeader(contentFrame, "💰 " .. (L["CURRENT_STATUS"] or "Current Status"), yOffset)
    yOffset = yOffset + spacing
    
    local currency = self:GetCurrentCurrency()
    local remaining = self:GetRemainingPoints()
    
    -- Honor info
    local honorText = string.format("🏅 %s: %d (%s: %d / %d)", 
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
        CreateInfoText(contentFrame, "  ✓ " .. string.format(L["CAP_REACHED"] or "Weekly %s cap reached!", L["HONOR"] or "Honor"), yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Conquest info
    local conquestText = string.format("⚔️ %s: %d (%s: %d / %d)", 
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
        CreateInfoText(contentFrame, "  ✓ " .. string.format(L["CAP_REACHED"] or "Weekly %s cap reached!", L["CONQUEST"] or "Conquest"), yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Time until reset
    local resetTime = self:GetTimeUntilReset()
    CreateInfoText(contentFrame, "⏰ " .. string.format(L["WEEKLY_RESET"] or "Weekly reset in: %s", resetTime), yOffset, {r=0.8, g=0.8, b=0.8})
    yOffset = yOffset + spacing * 1.5
    
    -- Weekly Quests Section (improved with guidance)
    CreateSectionHeader(contentFrame, "📜 " .. (L["WEEKLY_QUESTS"] or "Weekly PVP Quests"), yOffset)
    yOffset = yOffset + spacing
    
    local quests = self:GetWeeklyQuestStatus()
    
    if #quests > 0 then
        for _, quest in ipairs(quests) do
            local status = quest.completed and "✓" or "○"
            local statusColor = quest.completed and {r=0, g=1, b=0} or {r=1, g=1, b=0}
            
            local questText = string.format("%s %s", status, quest.name)
            CreateInfoText(contentFrame, questText, yOffset, statusColor)
            yOffset = yOffset + spacing
            
            local rewardText = string.format("  🎁 Reward: %s - %s", quest.reward, quest.description)
            CreateInfoText(contentFrame, rewardText, yOffset, {r=0.7, g=0.7, b=0.7})
            yOffset = yOffset + spacing + -5
        end
    else
        -- Provide helpful guidance when no quests are tracked
        CreateInfoText(contentFrame, "ℹ️ " .. (L["QUEST_HELP_TITLE"] or "How to get weekly PVP quests:"), yOffset, {r=0.5, g=0.9, b=1})
        yOffset = yOffset + spacing
        
        CreateInfoText(contentFrame, "• " .. (L["QUEST_HELP_1"] or "Visit your faction's PVP area"), yOffset, {r=0.7, g=0.7, b=0.7})
        yOffset = yOffset + spacing
        
        CreateInfoText(contentFrame, "• " .. (L["QUEST_HELP_2"] or "Check the Adventure Guide (Shift+J)"), yOffset, {r=0.7, g=0.7, b=0.7})
        yOffset = yOffset + spacing
        
        CreateInfoText(contentFrame, "• " .. (L["QUEST_HELP_3"] or "Look for quests near PVP vendors"), yOffset, {r=0.7, g=0.7, b=0.7})
        yOffset = yOffset + spacing
    end
    
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

-- Set initial button text
local function UpdateRefreshButtonText()
    local L = PVPAssist.L or {}
    refreshButton:SetText(L["REFRESH"] or "Refresh")
end

refreshButton:SetScript("OnClick", function()
    PVPAssist:UpdateUI()
    local L = PVPAssist.L or {}
    print("|cff00ff00PVP Assist:|r " .. (L["DATA_REFRESHED"] or "Data refreshed!"))
end)

-- Initialize button text
UpdateRefreshButtonText()

-- Close button is already provided by BasicFrameTemplateWithInset
