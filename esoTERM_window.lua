esoTERM_window = {}

local function set_window_visibility(window)
    local fragment = ZO_SimpleSceneFragment:New(window)

    SCENE_MANAGER:GetScene("achievements"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("cadwellsAlmanac"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("campaignBrowser"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("campaignOverview"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("friendsList"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("groupList"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("groupingTools"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("guildHistory"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("guildHome"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("guildRanks"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("guildRoster"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("helpCustomerSupport"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("helpTutorials"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("ignoreList"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("leaderboards"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("loreLibrary"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("mailInbox"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("mailSend"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("notifications"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("questJournal"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("skills"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("stats"):AddFragment(fragment)
end

function esoTERM_window.create()
    etw = WINDOW_MANAGER:CreateTopLevelWindow()
    etw:SetMouseEnabled(true)
    etw:SetMovable(false)
    etw:SetDimensions(500, 305)
    etw:SetResizeHandleSize(8)
    etw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 450)
    etw:SetHidden(true)

    esoTERM_window.tb = WINDOW_MANAGER:CreateControl(nil, etw, CT_TEXTBUFFER)
    esoTERM_window.tb:SetMouseEnabled(true)
    esoTERM_window.tb:SetLinkEnabled(true)
    esoTERM_window.tb:SetFont("ZoFontChat")
    esoTERM_window.tb:SetHandler("OnLinkMouseUp", function(self, _, link, button) return ZO_LinkHandler_OnLinkMouseUp(link, button, self) end)
    esoTERM_window.tb:SetHandler("OnMouseEnter", function() esoTERM_window.tb:ShowFadedLines() end)
    esoTERM_window.tb:SetHidden(false)
    esoTERM_window.tb:SetClearBufferAfterFadeout(false)
    esoTERM_window.tb:SetMaxHistoryLines(10000)
    esoTERM_window.tb:SetAnchorFill(etw)
    esoTERM_window.tb:SetLineFade(60, 1)

    set_window_visibility(etw)
end

function esoTERM_window.print_message(message)
    esoTERM_window.tb:AddMessage(message)
end

function esoTERM_window.initialize()
    esoTERM_window.create()
end

return esoTERM_window
