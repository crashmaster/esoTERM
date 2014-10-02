local CACHE = pinfo.CACHE

pinfo_output = {}
pinfo_output.PROMPT = "[pinfo] "
pinfo_output.default_settings = {chat_tab_number = 1}
pinfo_output.message_buffers = {}

local function _initialize_message_buffers()
    pinfo_output.message_buffers.xp_messages = {}
    pinfo_output.message_buffers.ap_messages = {}
    pinfo_output.message_buffers.loot_messages = {}
    pinfo_output.message_buffers.combat_state_messages = {}
end

local function _set_n_th_chat_tab_as_output(chat_tab_number)
    local chat_tab = string.format("ZO_ChatWindowTemplate%d", chat_tab_number)
    local chat_tab_name = string.format("ZO_ChatWindowTabTemplate%dText", chat_tab_number)

    if _G[chat_tab] == nil or _G[chat_tab_name] == nil then
        pinfo_output.text_box = _G["ZO_ChatWindowTemplate1"].buffer
        pinfo_output.chat_tab_name = _G["ZO_ChatWindowTabTemplate1Text"]:GetText()
    else
        pinfo_output.text_box = _G[chat_tab].buffer
        pinfo_output.chat_tab_name = _G[chat_tab_name]:GetText()
    end
    if chat_tab_number ~= pinfo_output.settings.chat_tab_number then
        pinfo_output.settings.chat_tab_number = chat_tab_number
        pinfo_output.sysout("Output chat tab set to: " .. pinfo_output.chat_tab_name)
    end
end

local function _set_output_to_chat_tab()
    local chat_tab_number = pinfo_output.default_settings.chat_tab_number
    if pinfo_output.settings.chat_tab_number ~= nil then
        chat_tab_number = pinfo_output.settings.chat_tab_number
    end
    _set_n_th_chat_tab_as_output(chat_tab_number)
end

local function _activate_real_print_functions()
    pinfo_output.xp_to_chat_tab = print_xp_message
    pinfo_output.ap_to_chat_tab = print_ap_message
    pinfo_output.loot_to_chat_tab = print_loot_message
    pinfo_output.combat_state_to_chat_tab = print_combat_state_message
end

local function _print_message_buffers()
    for _, buffer in pairs(pinfo_output.message_buffers) do
        for _, message in ipairs(buffer) do
            pinfo_output.stdout(message)
        end
    end
end

local function _xp_message()
    return string.format("%s gained %d XP (%.2f%%)",
                         pinfo_char.get_name(CACHE),
                         pinfo_char.get_xp_gain(CACHE),
                         pinfo_char.get_level_xp_percent(CACHE))
end

local function _ap_message()
    return string.format("%s gained %d AP (%.2f%%)",
                         pinfo_char.get_name(CACHE),
                         pinfo_char.get_ap_gain(CACHE),
                         pinfo_char.get_ava_rank_points_percent(CACHE))
end

local function _loot_message(item, quantity)
    return string.format("%s received %d %s",
                         pinfo_char.get_name(CACHE),
                         quantity,
                         zo_strformat("<<t:1>>", item))
end

local function _combat_enter_message()
    return string.format("%s entered combat",
                         pinfo_char.get_name(CACHE))
end

local function _combat_left_message()
    return string.format("%s left combat (lasted: %.2f s)",
                         pinfo_char.get_name(CACHE),
                         pinfo_char.get_combat_lenght(CACHE) / 1000)
end

local function _combat_state_message()
    if pinfo_char.get_combat_state(CACHE) then
        return _combat_enter_message()
    else
        return _combat_left_message()
    end
end

local function store_xp_message_before_player_activated()
    table.insert(pinfo_output.message_buffers.xp_messages, _xp_message())
end

local function print_xp_message()
    pinfo_output.stdout(_xp_message())
end

local function store_ap_message_before_player_activated()
    table.insert(pinfo_output.message_buffers.ap_messages, _ap_message())
end

local function print_ap_message()
    pinfo_output.stdout(_ap_message())
end

local function store_loot_message_before_player_activated(item, quantity)
    table.insert(pinfo_output.message_buffers.loot_messages, _loot_message(item, quantity))
end

local function print_loot_message(item, quantity)
    pinfo_output.stdout(_loot_message(item, quantity))
end

local function store_combat_state_message_before_player_activated()
    table.insert(pinfo_output.message_buffers.combat_state_messages, _combat_state_message())
end

local function print_combat_state_message()
    pinfo_output.stdout(_combat_state_message())
end

function pinfo_output.on_player_activated(event)
    _set_output_to_chat_tab()
    _activate_real_print_functions()
    _print_message_buffers()
    _initialize_message_buffers()
end

function pinfo_output.initialize()
    _initialize_message_buffers()
    pinfo_output.settings = ZO_SavedVars:New("pinfo_saved_variables",
                                             1,
                                             nil,
                                             pinfo_output.default_settings)
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   pinfo_output.on_player_activated)
end

pinfo_output.xp_to_chat_tab = store_xp_message_before_player_activated
pinfo_output.ap_to_chat_tab = store_ap_message_before_player_activated
pinfo_output.loot_to_chat_tab = store_loot_message_before_player_activated
pinfo_output.combat_state_to_chat_tab = store_combat_state_message_before_player_activated

function pinfo_output.stdout(message)
    pinfo_output.text_box:AddMessage(message)
end

function pinfo_output.sysout(message)
    d(pinfo_output.PROMPT .. message)
end

return pinfo_output
