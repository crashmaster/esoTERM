local CACHE_CHAR = esoTERM_char.cache
local CACHE_PVE = esoTERM_pve.cache
local CACHE_PVP = esoTERM_pvp.cache

esoTERM_output = {}
esoTERM_output.PROMPT = "[esoTERM] "
esoTERM_output.message_buffers = {}

local function _clear_message_buffers()
    esoTERM_output.message_buffers.combat_state_messages = {}
    esoTERM_output.message_buffers.stdout = {}
    esoTERM_output.message_buffers.sysout = {}
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

local function _activate_real_print_functions()
    esoTERM_output.stdout = esoTERM_output.real_stdout
end

function esoTERM_output.on_player_activated(event)
    _activate_real_print_functions()
    _print_message_buffers()
    _clear_message_buffers()
end

function esoTERM_output.initialize()
    _clear_message_buffers()
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   esoTERM_output.on_player_activated)
end

esoTERM_output.combat_state_to_chat_tab = store_combat_state_message_before_player_activated

function esoTERM_output.real_stdout(message)
    esoTERM_window.print_message(message)
end

function esoTERM_output.real_sysout(message)
    d(esoTERM_output.PROMPT .. message)
end

function store_stdout_messages_before_player_activated(message)
    table.insert(esoTERM_output.message_buffers.stdout, message)
end

function store_sysout_messages_before_player_activated(message)
    table.insert(esoTERM_output.message_buffers.sysout, message)
end

esoTERM_output.stdout = store_stdout_messages_before_player_activated
esoTERM_output.sysout = store_sysout_messages_before_player_activated

return esoTERM_output
