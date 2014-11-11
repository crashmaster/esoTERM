local CACHE_CHAR = esoTERM_char.cache
local CACHE_PVE = esoTERM_pve.cache
local CACHE_PVP = esoTERM_pvp.cache

esoTERM_output = {}
esoTERM_output.PROMPT = "[esoTERM] "
esoTERM_output.default_settings = {chat_tab_number = 1}
esoTERM_output.message_buffers = {}

local function _initialize_message_buffers()
    esoTERM_output.message_buffers.combat_state_messages = {}
    esoTERM_output.message_buffers.stdout = {}
    esoTERM_output.message_buffers.sysout = {}
end

function esoTERM_output.set_n_th_chat_tab_as_output(chat_tab_number)
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
    esoTERM_output.set_n_th_chat_tab_as_output(chat_tab_number)
end

local function _activate_real_print_functions()
    esoTERM_output.combat_state_to_chat_tab = print_combat_state_message
end

local function _print_message_buffers()
    for _, buffer in pairs(esoTERM_output.message_buffers) do
        for _, message in ipairs(buffer) do
            esoTERM_output.stdout(message)
        end
    end
end

local function _combat_enter_message()
    return string.format("%s entered combat",
                         esoTERM_char.get_name(CACHE_CHAR))
end

local function _combat_left_message()
    local length = esoTERM_char.get_combat_lenght(CACHE_CHAR) >= 1000 and
                   esoTERM_char.get_combat_lenght(CACHE_CHAR) or 1000
    return string.format(
        "%s left combat (lasted: %.2fs, dps: %.2f)",
        esoTERM_char.get_name(CACHE_CHAR),
        esoTERM_char.get_combat_lenght(CACHE_CHAR) / 1000,
        -- TODO: consider the zo_callLater delay
        esoTERM_char.get_combat_damage(CACHE_CHAR) * 1000 / length)
end

local function _combat_state_message()
    if esoTERM_char.get_combat_state(CACHE_CHAR) then
        return _combat_enter_message()
    else
        return _combat_left_message()
    end
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

esoTERM_output.combat_state_to_chat_tab = store_combat_state_message_before_player_activated

function esoTERM_output.stdout(message)
    esoTERM_window.tb:AddMessage(message)
end

function esoTERM_output.sysout(message)
    d(esoTERM_output.PROMPT .. message)
end

-- function store_stdout_messages_before_player_activated(message)
--     table.insert(esoTERM_output.message_buffers.stdout, message)
-- end
-- 
-- function store_sysout_messages_before_player_activated(message)
--     table.insert(esoTERM_output.message_buffers.sysout, message)
-- end
-- 
-- esoTERM_output.stdout = store_stdout_messages_before_player_activated
-- esoTERM_output.sysout = store_sysout_messages_before_player_activated

return esoTERM_output
