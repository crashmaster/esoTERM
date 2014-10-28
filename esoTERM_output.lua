local CACHE = esoTERM.CACHE

esoTERM_output = {}
esoTERM_output.PROMPT = "[esoTERM] "
esoTERM_output.default_settings = {chat_tab_number = 1}
esoTERM_output.message_buffers = {}

local function _initialize_message_buffers()
    esoTERM_output.message_buffers.xp_messages = {}
    esoTERM_output.message_buffers.ap_messages = {}
    esoTERM_output.message_buffers.loot_messages = {}
    esoTERM_output.message_buffers.combat_state_messages = {}
end

local function _set_n_th_chat_tab_as_output(chat_tab_number)
    local chat_tab = string.format("ZO_ChatWindowTemplate%d", chat_tab_number)
    local chat_tab_name = string.format("ZO_ChatWindowTabTemplate%dText", chat_tab_number)

    if _G[chat_tab] == nil or _G[chat_tab_name] == nil then
        esoTERM_output.text_box = _G["ZO_ChatWindowTemplate1"].buffer
        esoTERM_output.chat_tab_name = _G["ZO_ChatWindowTabTemplate1Text"]:GetText()
    else
        esoTERM_output.text_box = _G[chat_tab].buffer
        esoTERM_output.chat_tab_name = _G[chat_tab_name]:GetText()
    end
    if chat_tab_number ~= esoTERM_output.settings.chat_tab_number then
        esoTERM_output.settings.chat_tab_number = chat_tab_number
        esoTERM_output.sysout("Output chat tab set to: " .. esoTERM_output.chat_tab_name)
    end
end

local function _set_output_to_chat_tab()
    local chat_tab_number = esoTERM_output.default_settings.chat_tab_number
    if esoTERM_output.settings.chat_tab_number ~= nil then
        chat_tab_number = esoTERM_output.settings.chat_tab_number
    end
    _set_n_th_chat_tab_as_output(chat_tab_number)
end

local function _activate_real_print_functions()
    esoTERM_output.xp_to_chat_tab = print_xp_message
    esoTERM_output.ap_to_chat_tab = print_ap_message
    esoTERM_output.loot_to_chat_tab = print_loot_message
    esoTERM_output.combat_state_to_chat_tab = print_combat_state_message
end

local function _print_message_buffers()
    for _, buffer in pairs(esoTERM_output.message_buffers) do
        for _, message in ipairs(buffer) do
            esoTERM_output.stdout(message)
        end
    end
end

local function _xp_message()
    return string.format("%s gained %d XP (%.2f%%)",
                         esoTERM_char.get_name(CACHE),
                         esoTERM_char.get_xp_gain(CACHE),
                         esoTERM_char.get_level_xp_percent(CACHE))
end

local function _ap_message()
    return string.format("%s gained %d AP (%.2f%%)",
                         esoTERM_char.get_name(CACHE),
                         esoTERM_char.get_ap_gain(CACHE),
                         esoTERM_char.get_ava_rank_points_percent(CACHE))
end

local function _loot_message(item, quantity)
    return string.format("%s received %d %s",
                         esoTERM_char.get_name(CACHE),
                         quantity,
                         zo_strformat(SI_TOOLTIP_ITEM_NAME, item))
end

local function _combat_enter_message()
    return string.format("%s entered combat",
                         esoTERM_char.get_name(CACHE))
end

local function _combat_left_message()
    local length = esoTERM_char.get_combat_lenght(CACHE) >= 1000 and
                   esoTERM_char.get_combat_lenght(CACHE) or 1000
    return string.format(
        "%s left combat (lasted: %.2fs, dps: %.2f)",
        esoTERM_char.get_name(CACHE),
        esoTERM_char.get_combat_lenght(CACHE) / 1000,
        -- TODO: consider the zo_callLater delay
        esoTERM_char.get_combat_damage(CACHE) * 1000 / length)
end

local function _combat_state_message()
    if esoTERM_char.get_combat_state(CACHE) then
        return _combat_enter_message()
    else
        return _combat_left_message()
    end
end

function store_xp_message_before_player_activated()
    table.insert(esoTERM_output.message_buffers.xp_messages, _xp_message())
end

function print_xp_message()
    esoTERM_output.stdout(_xp_message())
end

function store_ap_message_before_player_activated()
    table.insert(esoTERM_output.message_buffers.ap_messages, _ap_message())
end

function print_ap_message()
    esoTERM_output.stdout(_ap_message())
end

function store_loot_message_before_player_activated(item, quantity)
    table.insert(esoTERM_output.message_buffers.loot_messages, _loot_message(item, quantity))
end

function print_loot_message(item, quantity)
    esoTERM_output.stdout(_loot_message(item, quantity))
end

function store_combat_state_message_before_player_activated()
    table.insert(esoTERM_output.message_buffers.combat_state_messages, _combat_state_message())
end

function print_combat_state_message()
    esoTERM_output.stdout(_combat_state_message())
end

function esoTERM_output.on_player_activated(event)
    _set_output_to_chat_tab()
    _activate_real_print_functions()
    _print_message_buffers()
    _initialize_message_buffers()
end

function esoTERM_output.initialize()
    _initialize_message_buffers()
    esoTERM_output.settings = ZO_SavedVars:New("esoTERM_saved_variables",
                                             1,
                                             nil,
                                             esoTERM_output.default_settings)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   esoTERM_output.on_player_activated)
end

esoTERM_output.xp_to_chat_tab = store_xp_message_before_player_activated
esoTERM_output.ap_to_chat_tab = store_ap_message_before_player_activated
esoTERM_output.loot_to_chat_tab = store_loot_message_before_player_activated
esoTERM_output.combat_state_to_chat_tab = store_combat_state_message_before_player_activated

function esoTERM_output.stdout(message)
    esoTERM_output.text_box:AddMessage(message)
end

function esoTERM_output.sysout(message)
    d(esoTERM_output.PROMPT .. message)
end

return esoTERM_output
