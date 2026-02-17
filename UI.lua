-- PVP Assist UI Module
-- Creates and manages the main UI window

local addonName, PVPAssist = ...

-- Create main frame
local mainFrame = CreateFrame("Frame", "PVPAssistMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(450, 550)
mainFrame:SetPoint("CENTER")
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:Hide()

-- Set frame title
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY")
mainFrame.title:SetFontObject("GameFontHighlight")
mainFrame.title:SetPoint("LEFT", mainFrame.TitleBg, "LEFT", 5, 0)
mainFrame.title:SetText("PVP Assist - Honor & Conquest Tracker")

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
    -- Clear existing content
    for _, child in pairs({contentFrame:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    local yOffset = -10
    local spacing = -20
    
    -- Currency Status Section
    CreateSectionHeader(contentFrame, "Current Status", yOffset)
    yOffset = yOffset + spacing
    
    local currency = self:GetCurrentCurrency()
    local remaining = self:GetRemainingPoints()
    
    -- Honor info
    local honorText = string.format("Honor: %d (Weekly: %d / %d)", 
        currency.honor.current,
        currency.honor.weeklyEarned,
        currency.honor.weeklyMax > 0 and currency.honor.weeklyMax or "No Cap")
    CreateInfoText(contentFrame, honorText, yOffset, {r=1, g=0.82, b=0})
    yOffset = yOffset + spacing
    
    if remaining.honorRemaining > 0 then
        local remainText = string.format("  → Remaining to cap: %d Honor", remaining.honorRemaining)
        CreateInfoText(contentFrame, remainText, yOffset, {r=0.5, g=1, b=0.5})
        yOffset = yOffset + spacing
    else
        CreateInfoText(contentFrame, "  → Weekly Honor cap reached!", yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Conquest info
    local conquestText = string.format("Conquest: %d (Weekly: %d / %d)", 
        currency.conquest.current,
        currency.conquest.weeklyEarned,
        currency.conquest.weeklyMax > 0 and currency.conquest.weeklyMax or "No Cap")
    CreateInfoText(contentFrame, conquestText, yOffset, {r=0.64, g=0.21, b=0.93})
    yOffset = yOffset + spacing
    
    if remaining.conquestRemaining > 0 then
        local remainText = string.format("  → Remaining to cap: %d Conquest", remaining.conquestRemaining)
        CreateInfoText(contentFrame, remainText, yOffset, {r=0.5, g=1, b=0.5})
        yOffset = yOffset + spacing
    else
        CreateInfoText(contentFrame, "  → Weekly Conquest cap reached!", yOffset, {r=0, g=1, b=0})
        yOffset = yOffset + spacing
    end
    
    -- Time until reset
    local resetTime = self:GetTimeUntilReset()
    CreateInfoText(contentFrame, "Weekly reset in: " .. resetTime, yOffset, {r=0.8, g=0.8, b=0.8})
    yOffset = yOffset + spacing * 1.5
    
    -- Recommended Activities Section
    CreateSectionHeader(contentFrame, "Recommended Activities", yOffset)
    yOffset = yOffset + spacing
    
    local activities = self:GetRecommendedActivities()
    
    if #activities == 0 then
        CreateInfoText(contentFrame, "✓ All weekly caps reached! Great job!", yOffset, {r=0, g=1, b=0})
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
    CreateSectionHeader(contentFrame, "Weekly PVP Quests", yOffset)
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
    CreateSectionHeader(contentFrame, "Tips", yOffset)
    yOffset = yOffset + spacing
    
    CreateInfoText(contentFrame, "• Complete daily/weekly quests for bonus rewards", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, "• Enable War Mode for 10-30% bonus honor", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, "• Rated content gives better conquest rewards", yOffset)
    yOffset = yOffset + spacing
    CreateInfoText(contentFrame, "• Check group finder for active PVP groups", yOffset)
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
refreshButton:SetText("Refresh")
refreshButton:SetScript("OnClick", function()
    PVPAssist:UpdateUI()
    print("|cff00ff00PVP Assist:|r Data refreshed!")
end)

-- Close button is already provided by BasicFrameTemplateWithInset
