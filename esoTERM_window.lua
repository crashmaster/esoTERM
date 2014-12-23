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

local function get_chat_font()
    local face = ZoFontChat:GetFontInfo()
    local font_size = GetChatFontSize()
    if font_size <= 14 then
        return string.format("%s|%s|%s", face, font_size, "soft-shadow-thin")
    end
    return string.format("%s|%s|%s", face, font_size, "soft-shadow-thick")
end

local function hide_etw()
    if not MouseIsOver(esoTERM_window.etw) then
        esoTERM_window.fade_anim:SetMinMaxAlpha(0.0, 1.0)
        esoTERM_window.fade_anim:FadeOut(3000, 300)
    end
end

local function show_etw()
    if MouseIsOver(esoTERM_window.etw) then
        esoTERM_window.fade_anim:SetMinMaxAlpha(0.0, 1.0)
        esoTERM_window.fade_anim:FadeIn(0, 300)
    end
end

function esoTERM_window.create()
    local etw = WINDOW_MANAGER:CreateTopLevelWindow()
    etw:SetMouseEnabled(true)
    etw:SetMovable(true)
    etw:SetHidden(true)
    etw:SetClampedToScreen(true)
    etw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 450)
    etw:SetDimensions(400, 300)
    etw:SetDimensionConstraints(300, 200, 500, 800)
    etw:SetResizeHandleSize(16)
    etw:SetHandler("OnMouseExit", function()
        if not MouseIsOver(etw) then
            esoTERM_window.fade_anim:SetMinMaxAlpha(0.0, 1.0)
            esoTERM_window.fade_anim:FadeOut(3000, 300)
        end
    end)
    etw:SetHandler("OnMouseEnter", function()
        if MouseIsOver(etw) then
            esoTERM_window.fade_anim:SetMinMaxAlpha(0.0, 1.0)
            esoTERM_window.fade_anim:FadeIn(0, 300)
        end
    end)

    local bg = WINDOW_MANAGER:CreateControl(nil, etw, CT_BACKDROP)
    bg:SetAnchor(TOPLEFT, etw, TOPLEFT, -8, -8)
    bg:SetAnchor(BOTTOMRIGHT, etw, BOTTOMRIGHT, 8, 8)
    bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 512, 512, 32)
    bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    bg:SetInsets(32, 32, -32, -32)

    local divider = WINDOW_MANAGER:CreateControl(nil, etw, CT_TEXTURE)
    divider:SetDimensions(4, 4)
    divider:SetAnchor(TOPLEFT, etw, TOPLEFT, 20, 40)
    divider:SetAnchor(TOPRIGHT, etw, TOPRIGHT, -20, 40)
    divider:SetTexture("EsoUI/Art/Miscellaneous/horizontalDivider.dds")
    divider:SetTextureCoords(0.2, 0.8, 0, 1)

    local tb = WINDOW_MANAGER:CreateControl(nil, etw, CT_TEXTBUFFER)
    tb:SetMouseEnabled(true)
    tb:SetLinkEnabled(true)
    tb:SetAnchor(TOPLEFT, etw, TOPLEFT, 20, 42)
    tb:SetAnchor(BOTTOMRIGHT, etw, BOTTOMRIGHT, -35, -20)
    tb:SetFont(get_chat_font())
    tb:SetClearBufferAfterFadeout(false)
    tb:SetMaxHistoryLines(10000)
    tb:SetLineFade(60, 1)
    tb:SetHandler("OnLinkMouseUp", function(self, _, link, button)
        return ZO_LinkHandler_OnLinkMouseUp(link, button, self)
    end)
    tb:SetHandler("OnMouseEnter", function()
        tb:ShowFadedLines()
    end)
    tb:SetHandler("OnMouseWheel", function(self, delta, ctrl, alt, shift)
        tb:SetScrollPosition(tb:GetScrollPosition() + delta)
    end)

    esoTERM_window.fade_anim = ZO_AlphaAnimation:New(etw)
    esoTERM_window.etw = etw
    esoTERM_window.tb = tb

    hide_etw()
end

function esoTERM_window.print_message(message)
    esoTERM_window.tb:AddMessage(message)
end

function esoTERM_window.initialize()
    esoTERM_window.create()
    esoTERM_window.set_window_visibility()
    GAME_MENU_SCENE:RegisterCallback("StateChange", function(old_state, new_state)
        if new_state == SCENE_HIDDEN then
            -- TODO: call if other than before
            esoTERM_window.tb:SetFont(get_chat_font())
        end
    end)
end

return esoTERM_window
