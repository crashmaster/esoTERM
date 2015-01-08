esoTERM_window = {}
esoTERM_window.default_settings = {
    window_width = 400,
    window_height = 300,
    window_x = 20,
    window_y = 450
}

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

local function on_resize_stop()
    local settings = esoTERM_window.settings
    settings.window_width, settings.window_height = esoTERM_window.etw:GetDimensions()
end

local function on_move_stop()
    local settings = esoTERM_window.settings
    _, _, _, _, settings.window_x, settings.window_y = esoTERM_window.etw:GetAnchor(0)
end

local function create_top_level_window()
    local etw = WINDOW_MANAGER:CreateTopLevelWindow()
    etw:SetMouseEnabled(true)
    etw:SetMovable(true)
    etw:SetHidden(true)
    etw:SetClampedToScreen(true)
    local x = esoTERM_window.settings.window_x or
              esoTERM_window.default_settings.window_x
    local y = esoTERM_window.settings.window_y or
              esoTERM_window.default_settings.window_y
    etw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
    local width = esoTERM_window.settings.window_width or
                  esoTERM_window.default_settings.window_width
    local height = esoTERM_window.settings.window_height or
                   esoTERM_window.default_settings.window_height
    etw:SetDimensions(width, height)
    etw:SetDimensionConstraints(300, 200, 500, 800)
    etw:SetResizeHandleSize(16)
    etw:SetHandler("OnMouseExit", hide_etw)
    etw:SetHandler("OnMouseEnter", show_etw)
    etw:SetHandler("OnResizeStop", on_resize_stop)
    etw:SetHandler("OnMoveStop", on_move_stop)
    return etw
end

local function create_window_background()
    local bg = WINDOW_MANAGER:CreateControl(nil, esoTERM_window.etw, CT_BACKDROP)
    bg:SetAnchor(TOPLEFT, esoTERM_window.etw, TOPLEFT, 0, 0)
    bg:SetAnchor(BOTTOMRIGHT, esoTERM_window.etw, BOTTOMRIGHT, 0, 0)
    bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 512, 512, 32)
    bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    bg:SetInsets(32, 32, -32, -32)
    return bg
end

local function create_window_divider()
    local divider = WINDOW_MANAGER:CreateControl(nil, esoTERM_window.etw, CT_TEXTURE)
    divider:SetDimensions(4, 4)
    divider:SetAnchor(TOPLEFT, esoTERM_window.etw, TOPLEFT, 20, 40)
    divider:SetAnchor(TOPRIGHT, esoTERM_window.etw, TOPRIGHT, -20, 40)
    divider:SetTexture("EsoUI/Art/Miscellaneous/horizontalDivider.dds")
    divider:SetTextureCoords(0.2, 0.8, 0, 1)
    return divider
end

local function create_lock_button()
    local button = WINDOW_MANAGER:CreateControl(nil, esoTERM_window.etw, CT_BUTTON)
    button:SetDimensions(48, 48)
    button:SetPressedOffset(2, 2)
    button:SetAnchor(TOPLEFT, esoTERM_window.etw, TOPLEFT, 0, 0)
    button:SetNormalTexture("/esoui/art/progression/progression_crafting_locked_up.dds")
    button:SetPressedTexture("/esoui/art/progression/progression_crafting_locked_down.dds")
    button:SetMouseOverTexture("/esoui/art/progression/progression_crafting_locked_over.dds")
    button:SetHandler("OnClicked", function(self, ...)
        d("OnClicked")
    end)
    return button
end

local function create_window_text_buffer()
    local tb = WINDOW_MANAGER:CreateControl(nil, esoTERM_window.etw, CT_TEXTBUFFER)
    tb:SetMouseEnabled(true)
    tb:SetLinkEnabled(true)
    tb:SetAnchor(TOPLEFT, esoTERM_window.etw, TOPLEFT, 30, 45)
    tb:SetAnchor(BOTTOMRIGHT, esoTERM_window.etw, BOTTOMRIGHT, -30, -25)
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
    return tb
end

function esoTERM_window.create()
    esoTERM_window.etw = create_top_level_window()
    esoTERM_window.fade_anim = ZO_AlphaAnimation:New(esoTERM_window.etw)
    esoTERM_window.etw_bg = create_window_background()
    esoTERM_window.etw_divider = create_window_divider()
    esoTERM_window.etw_button_lock = create_lock_button()
    esoTERM_window.tb = create_window_text_buffer()

    hide_etw()
end

function esoTERM_window.print_message(message)
    esoTERM_window.tb:AddMessage(message)
end

function esoTERM_window.initialize()
    esoTERM_window.settings = ZO_SavedVars:New("esoTERM_settings",
                                               1, nil,
                                               esoTERM_window.default_settings)
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
