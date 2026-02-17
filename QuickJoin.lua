-- PVP Assist Quick Join Module
-- Provides quick access buttons to join PVP queues

local addonName, PVPAssist = ...

PVPAssist.QuickJoin = {}
local QuickJoin = PVPAssist.QuickJoin

-- Role types
local ROLE_TANK = "TANK"
local ROLE_HEALER = "HEALER"
local ROLE_DAMAGER = "DAMAGER"

-- Get localized role text
function QuickJoin:GetLocalizedRoleText(role)
    local L = PVPAssist.L
    
    if role == ROLE_TANK then
        return L["ROLE_TANK"] or "Tank"
    elseif role == ROLE_HEALER then
        return L["ROLE_HEALER"] or "Healer"
    elseif role == ROLE_DAMAGER then
        return L["ROLE_DPS"] or "DPS"
    end
    
    return "Unknown"
end

-- Get available specs for the player's class and their roles
function QuickJoin:GetPlayerSpecsAndRoles()
    local specs = {}
    local numSpecs = GetNumSpecializations()
    
    for i = 1, numSpecs do
        local specID, specName, _, _, role = GetSpecializationInfo(i)
        if specID and specName and role then
            table.insert(specs, {
                index = i,
                id = specID,
                name = specName,
                role = role
            })
        end
    end
    
    return specs
end

-- Get specs that match a specific role
function QuickJoin:GetSpecsForRole(role)
    local specs = self:GetPlayerSpecsAndRoles()
    local matchingSpecs = {}
    
    for _, spec in ipairs(specs) do
        if spec.role == role then
            table.insert(matchingSpecs, spec)
        end
    end
    
    return matchingSpecs
end

-- Change player's specialization
function QuickJoin:ChangeSpecialization(specIndex)
    if not specIndex then return false end
    
    -- Check if player is in combat
    if InCombatLockdown() then
        local L = PVPAssist.L
        print("|cffff0000PVP Assist:|r " .. (L["CANNOT_CHANGE_SPEC_COMBAT"] or "Cannot change specialization while in combat"))
        return false
    end
    
    -- Get current spec
    local currentSpec = GetSpecialization()
    if currentSpec == specIndex then
        -- Already in the correct spec
        return true
    end
    
    -- Change specialization
    SetSpecialization(specIndex)
    
    local L = PVPAssist.L
    local _, specName = GetSpecializationInfo(specIndex)
    print("|cff00ff00PVP Assist:|r " .. string.format(L["CHANGED_SPEC"] or "Changed specialization to %s", specName))
    
    return true
end

-- Get selected role from saved variables
function QuickJoin:GetSelectedRole()
    if not PVPAssistDB then return nil end
    return PVPAssistDB.selectedRole
end

-- Set selected role in saved variables
function QuickJoin:SetSelectedRole(role)
    if not PVPAssistDB then
        PVPAssistDB = {}
    end
    PVPAssistDB.selectedRole = role
end

-- Check and change spec based on selected role
-- Returns true if should continue with queue, false if should abort
function QuickJoin:CheckAndChangeSpecForSelectedRole()
    local L = PVPAssist.L
    local selectedRole = self:GetSelectedRole()
    
    if not selectedRole then
        return true -- No role selected, continue without changing spec
    end
    
    local specs = self:GetSpecsForRole(selectedRole)
    if #specs == 0 then
        print("|cffff0000PVP Assist:|r " .. (L["NO_SPEC_FOR_ROLE"] or "No specialization available for selected role"))
        return false -- Abort queue
    end
    
    -- Check if current spec already matches the selected role
    local currentSpec = GetSpecialization()
    local needsChange = true
    
    if currentSpec then
        local _, _, _, _, currentRole = GetSpecializationInfo(currentSpec)
        if currentRole == selectedRole then
            needsChange = false
        end
    end
    
    -- Only change if needed
    if needsChange then
        local success = self:ChangeSpecialization(specs[1].index)
        if not success then
            return false -- Abort queue if spec change failed
        end
    end
    
    return true -- Continue with queue
end

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
    
    -- Check and change spec based on selected role
    if not self:CheckAndChangeSpecForSelectedRole() then
        return -- Abort if spec change failed or no spec available
    end
    
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
    
    -- Check and change spec based on selected role
    if not self:CheckAndChangeSpecForSelectedRole() then
        return -- Abort if spec change failed or no spec available
    end
    
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
    
    -- Check and change spec based on selected role
    if not self:CheckAndChangeSpecForSelectedRole() then
        return -- Abort if spec change failed or no spec available
    end
    
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

-- Create role selection UI
function QuickJoin:CreateRoleSelector(parent, yOffset)
    local L = PVPAssist.L
    
    -- Create container frame
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(380, 30)
    container:SetPoint("TOPLEFT", 10, yOffset)
    
    -- Role label
    local label = container:CreateFontString(nil, "OVERLAY")
    label:SetFontObject("GameFontNormal")
    label:SetPoint("LEFT", 5, 0)
    label:SetText(L["SELECT_ROLE"] or "Select Role:")
    
    -- Get available specs and roles
    local specs = self:GetPlayerSpecsAndRoles()
    local availableRoles = {}
    for _, spec in ipairs(specs) do
        availableRoles[spec.role] = true
    end
    
    -- Calculate starting position for checkboxes
    local checkboxStartX = 120
    local checkboxSpacing = 90
    local currentX = checkboxStartX
    
    -- Tank checkbox
    if availableRoles[ROLE_TANK] then
        local tankCheck = CreateFrame("CheckButton", nil, container, "UICheckButtonTemplate")
        tankCheck:SetSize(24, 24)
        tankCheck:SetPoint("LEFT", currentX, 0)
        tankCheck.text:SetText(L["ROLE_TANK"] or "Tank")
        tankCheck.text:SetFontObject("GameFontHighlightSmall")
        
        -- Load saved state
        local selectedRole = self:GetSelectedRole()
        if selectedRole == ROLE_TANK then
            tankCheck:SetChecked(true)
        end
        
        tankCheck:SetScript("OnClick", function(self)
            if self:GetChecked() then
                QuickJoin:SetSelectedRole(ROLE_TANK)
                -- Uncheck other roles
                if container.healerCheck then container.healerCheck:SetChecked(false) end
                if container.dpsCheck then container.dpsCheck:SetChecked(false) end
            else
                QuickJoin:SetSelectedRole(nil)
            end
        end)
        
        container.tankCheck = tankCheck
        currentX = currentX + checkboxSpacing
    end
    
    -- Healer checkbox
    if availableRoles[ROLE_HEALER] then
        local healerCheck = CreateFrame("CheckButton", nil, container, "UICheckButtonTemplate")
        healerCheck:SetSize(24, 24)
        healerCheck:SetPoint("LEFT", currentX, 0)
        healerCheck.text:SetText(L["ROLE_HEALER"] or "Healer")
        healerCheck.text:SetFontObject("GameFontHighlightSmall")
        
        -- Load saved state
        local selectedRole = self:GetSelectedRole()
        if selectedRole == ROLE_HEALER then
            healerCheck:SetChecked(true)
        end
        
        healerCheck:SetScript("OnClick", function(self)
            if self:GetChecked() then
                QuickJoin:SetSelectedRole(ROLE_HEALER)
                -- Uncheck other roles
                if container.tankCheck then container.tankCheck:SetChecked(false) end
                if container.dpsCheck then container.dpsCheck:SetChecked(false) end
            else
                QuickJoin:SetSelectedRole(nil)
            end
        end)
        
        container.healerCheck = healerCheck
        currentX = currentX + checkboxSpacing
    end
    
    -- DPS checkbox
    if availableRoles[ROLE_DAMAGER] then
        local dpsCheck = CreateFrame("CheckButton", nil, container, "UICheckButtonTemplate")
        dpsCheck:SetSize(24, 24)
        dpsCheck:SetPoint("LEFT", currentX, 0)
        dpsCheck.text:SetText(L["ROLE_DPS"] or "DPS")
        dpsCheck.text:SetFontObject("GameFontHighlightSmall")
        
        -- Load saved state
        local selectedRole = self:GetSelectedRole()
        if selectedRole == ROLE_DAMAGER then
            dpsCheck:SetChecked(true)
        end
        
        dpsCheck:SetScript("OnClick", function(self)
            if self:GetChecked() then
                QuickJoin:SetSelectedRole(ROLE_DAMAGER)
                -- Uncheck other roles
                if container.tankCheck then container.tankCheck:SetChecked(false) end
                if container.healerCheck then container.healerCheck:SetChecked(false) end
            else
                QuickJoin:SetSelectedRole(nil)
            end
        end)
        
        container.dpsCheck = dpsCheck
    end
    
    return container, yOffset - 35
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
        
        -- Add spec change information if a role is selected
        local selectedRole = QuickJoin:GetSelectedRole()
        if selectedRole then
            local specs = QuickJoin:GetSpecsForRole(selectedRole)
            if #specs > 0 then
                local roleText = QuickJoin:GetLocalizedRoleText(selectedRole)
                GameTooltip:AddLine(" ", nil, nil, nil, true)
                GameTooltip:AddLine(string.format(L["TOOLTIP_WILL_CHANGE_SPEC"] or "Will change to %s spec: %s", roleText, specs[1].name), 0.5, 1, 0.5, true)
            end
        end
        
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
