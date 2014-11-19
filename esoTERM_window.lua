esoTERM_window = {}

function esoTERM_window.set_window_visibility()
    local fragment = ZO_SimpleSceneFragment:New(esoTERM_window.etw)

    local scenes = {
        "achievements",
        "cadwellsAlmanac",
        "campaignBrowser",
        "campaignOverview",
        "friendsList",
        "groupList",
        "groupingTools",
        "guildHistory",
        "guildHome",
        "guildRanks",
        "guildRoster",
        "helpCustomerSupport",
        "helpTutorials",
        "hud",
        "hudui",
        "ignoreList",
        "leaderboards",
        "loreLibrary",
        "mailInbox",
        "mailSend",
        "notifications",
        "questJournal",
        "skills",
        "stats",
    }

    for i, scene in ipairs(scenes) do
        SCENE_MANAGER:GetScene(scene):AddFragment(fragment)
    end
end

function esoTERM_window.create()
    local etw = WINDOW_MANAGER:CreateTopLevelWindow()
    etw:SetMouseEnabled(true)
    etw:SetMovable(false)
    etw:SetDimensions(500, 305)
    etw:SetResizeHandleSize(8)
    etw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 450)
    etw:SetHidden(true)

    local tb = WINDOW_MANAGER:CreateControl(nil, etw, CT_TEXTBUFFER)
    tb:SetMouseEnabled(true)
    tb:SetLinkEnabled(true)
    tb:SetFont("ZoFontChat")
    tb:SetHandler("OnLinkMouseUp", function(self, _, link, button) return ZO_LinkHandler_OnLinkMouseUp(link, button, self) end)
    tb:SetHandler("OnMouseEnter", function() tb:ShowFadedLines() end)
    tb:SetHidden(false)
    tb:SetClearBufferAfterFadeout(false)
    tb:SetMaxHistoryLines(10000)
    tb:SetAnchorFill(etw)
    tb:SetLineFade(60, 1)

    esoTERM_window.etw = etw
    esoTERM_window.tb = tb
end

function esoTERM_window.print_message(message)
    esoTERM_window.tb:AddMessage(message)
end

function esoTERM_window.initialize()
    esoTERM_window.create()
    esoTERM_window.set_window_visibility()
end

return esoTERM_window
