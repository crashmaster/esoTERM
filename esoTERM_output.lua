local CACHE_CHAR = esoTERM_char.cache
local CACHE_PVE = esoTERM_pve.cache
local CACHE_PVP = esoTERM_pvp.cache

esoTERM_output = {}
esoTERM_output.PROMPT = "[esoTERM] "
esoTERM_output.message_buffers = {}

local function _clear_message_buffers()
    esoTERM_output.message_buffers.stdout = {}
    esoTERM_output.message_buffers.sysout = {}
end

local function _print_message_buffers()
    for _, message in ipairs(esoTERM_output.message_buffers.stdout) do
        esoTERM_output.stdout(message)
    end
    for _, message in ipairs(esoTERM_output.message_buffers.sysout) do
        esoTERM_output.sysout(message)
    end
end

local function _activate_real_print_functions()
    esoTERM_output.stdout = esoTERM_output.real_stdout
    esoTERM_output.sysout = esoTERM_output.real_sysout
end

function esoTERM_output.on_player_activated(event)
    _activate_real_print_functions()
    _print_message_buffers()
    _clear_message_buffers()
end

function store_stdout_messages_before_player_activated(message)
    table.insert(esoTERM_output.message_buffers.stdout, message)
end

function esoTERM_output.real_stdout(message)
    esoTERM_window.print_message(message)
end

function store_sysout_messages_before_player_activated(message)
    table.insert(esoTERM_output.message_buffers.sysout, message)
end

function esoTERM_output.real_sysout(message)
    d(esoTERM_output.PROMPT .. message)
end

function esoTERM_output.initialize()
    _clear_message_buffers()

    esoTERM_output.stdout = store_stdout_messages_before_player_activated
    esoTERM_output.sysout = store_sysout_messages_before_player_activated

    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   esoTERM_output.on_player_activated)
end

return esoTERM_output
