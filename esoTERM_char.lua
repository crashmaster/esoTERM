local PLAYER_UNIT_TAG = "player"

esoTERM_char = {}
esoTERM_char.cache = {}
esoTERM_char.event_register = {}

esoTERM_char.module_name = "esoTERM-character"
esoTERM_char.is_active = false

local CACHE = esoTERM_char.cache
local EVENT_REGISTER = esoTERM_char.event_register
local EXIT_COMBAT_CALL_DELAY = 500

function esoTERM_char.get_gender(cache)
    if cache.gender ~= nil then
        return cache.gender
    else
        return GetUnitGender(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_class(cache)
    if cache.class ~= nil then
        return cache.class
    else
        return GetUnitClass(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_name(cache)
    if cache.name ~= nil then
        return cache.name
    else
        return GetUnitName(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_combat_state(cache)
    if cache.combat_state ~= nil then
        return cache.combat_state
    else
        return IsUnitInCombat(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_combat_start_time(cache)
    if cache.combat_start_time ~= nil then
        return cache.combat_start_time
    else
        return 0
    end
end

function esoTERM_char.get_combat_lenght(cache)
    if cache.combat_lenght ~= nil and cache.combat_lenght > 0 then
        return cache.combat_lenght
    else
        return 0
    end
end

function esoTERM_char.get_combat_damage(cache)
    if cache.combat_damage ~= nil then
        return cache.combat_damage
    else
        return 0
    end
end

function esoTERM_char.on_combat_state_update(event, combat_state)
    if esoTERM_char.get_combat_state(CACHE) ~= combat_state then
        CACHE.combat_state = combat_state
        if combat_state then
            esoTERM_char.enter_combat()
        else
            zo_callLater(esoTERM_char.exit_combat, EXIT_COMBAT_CALL_DELAY)
        end
    end
end

function esoTERM_char.on_combat_event_update(event,
                                             result,
                                             event_not_ok,
                                             ability_name,
                                             ability_graphic,
                                             action_slot_type,
                                             source_name,
                                             source_type,
                                             target_name,
                                             target_type,
                                             hit_value,
                                             power_type,
                                             damage_type,
                                             log)

    if result ~= ACTION_RESULT_DAMAGE and
       result ~= ACTION_RESULT_CRITICAL_DAMAGE and
       result ~= ACTION_RESULT_DOT_TICK and
       result ~= ACTION_RESULT_DOT_TICK_CRITICAL then return end

    if event_not_ok then return end

    if source_name == "" then return end

    if target_name == "" then return end

    if source_type ~= COMBAT_UNIT_TYPE_PLAYER and
       source_type ~= COMBAT_UNIT_TYPE_PLAYER_PET then return end

    if hit_value < 1 then return end

    if power_type == POWERTYPE_INVALID then return end

    if damage_type < 1 then return end

    CACHE.combat_damage = CACHE.combat_damage + hit_value
    local message = string.format("Dealt damage with %s for: %d",
                                  ability_name,
                                  hit_value)
    esoTERM_output.stdout(message)
end

local function get_combat_enter_message()
    return "Entered combat"
end

function esoTERM_char.enter_combat()
    CACHE.combat_start_time = GetGameTimeMilliseconds()
    CACHE.combat_damage = 0

    esoTERM_common.register_for_event(EVENT_REGISTER,
                                      EVENT_COMBAT_EVENT,
                                      esoTERM_char.on_combat_event_update)

    esoTERM_output.stdout(get_combat_enter_message())
end

local function get_combat_left_message()
    local net_length = esoTERM_char.get_combat_lenght(CACHE) - EXIT_COMBAT_CALL_DELAY
    local length = net_length >= 1000 and net_length or 1000
    return string.format(
        "Left combat (lasted: %.2fs, dps: %.2f)",
        (net_length) / 1000,
        esoTERM_char.get_combat_damage(CACHE) * 1000 / (length))
end

function esoTERM_char.exit_combat()
    local combat_start_time = esoTERM_char.get_combat_start_time(CACHE)
    CACHE.combat_lenght = GetGameTimeMilliseconds() - combat_start_time

    esoTERM_common.unregister_from_event(EVENT_REGISTER, EVENT_COMBAT_EVENT)

    esoTERM_output.stdout(get_combat_left_message())

    CACHE.combat_start_time = 0
    CACHE.combat_damage = 0
end

function esoTERM_char.on_unit_death_state_change(event, unit, is_dead)
    if unit == PLAYER_UNIT_TAG then
        if is_dead then
            esoTERM_output.stdout("Died, you are pathetic!")
            esoTERM_char.on_combat_state_update(nil, false)
        else
            esoTERM_output.stdout("Resurrected, watch out next time!")
            CACHE.combat_state = IsUnitInCombat(PLAYER_UNIT_TAG)
            esoTERM_char.on_combat_state_update(nil, esoTERM_char.get_combat_state(CACHE))
        end
    end
end

function esoTERM_char.initialize()
    CACHE.gender = esoTERM_char.get_gender(CACHE)
    CACHE.class = esoTERM_char.get_class(CACHE)
    CACHE.name = esoTERM_char.get_name(CACHE)
    CACHE.combat_state = esoTERM_char.get_combat_state(CACHE)
    CACHE.combat_start_time = esoTERM_char.get_combat_start_time(CACHE)
    CACHE.combat_lenght = esoTERM_char.get_combat_lenght(CACHE)
    CACHE.combat_damage = esoTERM_char.get_combat_damage(CACHE)

    esoTERM_common.register_for_event(EVENT_REGISTER,
                                      EVENT_PLAYER_COMBAT_STATE,
                                      esoTERM_char.on_combat_state_update)
    esoTERM_common.register_for_event(EVENT_REGISTER,
                                      EVENT_UNIT_DEATH_STATE_CHANGED,
                                      esoTERM_char.on_unit_death_state_change)

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_char)

    esoTERM_char.is_active = true
end

function esoTERM_char.deactivate()
    esoTERM_common.unregister_from_all_events(EVENT_REGISTER)

    esoTERM_char.is_active = false
end

return esoTERM_char
