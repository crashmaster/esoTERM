esoTERM_char = {}

esoTERM_char.cache = {}
esoTERM_char.event_register = {}
esoTERM_char.module_name = "esoTERM-character"
esoTERM_char.is_active = false

local ESOTERM_CHAR_CACHE = esoTERM_char.cache
local PLAYER_UNIT_TAG = "player"
local EXIT_COMBAT_CALL_DELAY = 500

function esoTERM_char.get_gender()
    if ESOTERM_CHAR_CACHE.gender ~= nil then
        return ESOTERM_CHAR_CACHE.gender
    else
        return GetUnitGender(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_class()
    if ESOTERM_CHAR_CACHE.class ~= nil then
        return ESOTERM_CHAR_CACHE.class
    else
        return GetUnitClass(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_name()
    if ESOTERM_CHAR_CACHE.name ~= nil then
        return ESOTERM_CHAR_CACHE.name
    else
        return GetUnitName(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_combat_state()
    if ESOTERM_CHAR_CACHE.combat_state ~= nil then
        return ESOTERM_CHAR_CACHE.combat_state
    else
        return IsUnitInCombat(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_combat_start_time()
    if ESOTERM_CHAR_CACHE.combat_start_time ~= nil then
        return ESOTERM_CHAR_CACHE.combat_start_time
    else
        return 0
    end
end

function esoTERM_char.get_combat_lenght()
    if ESOTERM_CHAR_CACHE.combat_lenght ~= nil and ESOTERM_CHAR_CACHE.combat_lenght > 0 then
        return ESOTERM_CHAR_CACHE.combat_lenght
    else
        return 0
    end
end

function esoTERM_char.get_combat_damage()
    if ESOTERM_CHAR_CACHE.combat_damage ~= nil then
        return ESOTERM_CHAR_CACHE.combat_damage
    else
        return 0
    end
end

function esoTERM_char.on_combat_state_update(event, combat_state)
    if esoTERM_char.get_combat_state() ~= combat_state then
        ESOTERM_CHAR_CACHE.combat_state = combat_state
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

    ESOTERM_CHAR_CACHE.combat_damage = ESOTERM_CHAR_CACHE.combat_damage + hit_value
    local message = string.format("Dealt damage with %s for: %d",
                                  ability_name,
                                  hit_value)
    esoTERM_output.stdout(message)
end

local function get_combat_enter_message()
    return "Entered combat"
end

function esoTERM_char.enter_combat()
    ESOTERM_CHAR_CACHE.combat_start_time = GetGameTimeMilliseconds()
    ESOTERM_CHAR_CACHE.combat_damage = 0

    esoTERM_common.register_for_event(esoTERM_char,
                                      EVENT_COMBAT_EVENT,
                                      esoTERM_char.on_combat_event_update)

    esoTERM_output.stdout(get_combat_enter_message())
end

local function get_combat_left_message()
    local net_length = esoTERM_char.get_combat_lenght() - EXIT_COMBAT_CALL_DELAY
    local length = net_length >= 1000 and net_length or 1000
    local damage = esoTERM_char.get_combat_damage()
    return string.format(
        "Left combat (lasted: %.2fs, damage: %d, dps: %.2f)",
        (net_length) / 1000, damage, damage * 1000 / (length))
end

function esoTERM_char.exit_combat()
    local combat_start_time = esoTERM_char.get_combat_start_time()
    ESOTERM_CHAR_CACHE.combat_lenght = GetGameTimeMilliseconds() - combat_start_time

    esoTERM_common.unregister_from_event(esoTERM_char,
                                         EVENT_COMBAT_EVENT)

    esoTERM_output.stdout(get_combat_left_message())

    ESOTERM_CHAR_CACHE.combat_start_time = 0
    ESOTERM_CHAR_CACHE.combat_damage = 0
end

function esoTERM_char.on_unit_death_state_change(event, unit, is_dead)
    if unit == PLAYER_UNIT_TAG then
        if is_dead then
            esoTERM_output.stdout("Died, you are pathetic!")
            esoTERM_char.on_combat_state_update(nil, false)
        else
            esoTERM_output.stdout("Resurrected, watch out next time!")
            ESOTERM_CHAR_CACHE.combat_state = IsUnitInCombat(PLAYER_UNIT_TAG)
            esoTERM_char.on_combat_state_update(nil, esoTERM_char.get_combat_state())
        end
    end
end

function esoTERM_char.initialize()
    esoTERM_char.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        1,
        "active_modules",
        {[esoTERM_char.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_char)

    if esoTERM_char.settings[esoTERM_char.module_name] then
        esoTERM_char.activate()
    end
end

function esoTERM_char.activate()
    ESOTERM_CHAR_CACHE.gender = esoTERM_char.get_gender()
    ESOTERM_CHAR_CACHE.class = esoTERM_char.get_class()
    ESOTERM_CHAR_CACHE.name = esoTERM_char.get_name()
    ESOTERM_CHAR_CACHE.combat_state = esoTERM_char.get_combat_state()
    ESOTERM_CHAR_CACHE.combat_start_time = esoTERM_char.get_combat_start_time()
    ESOTERM_CHAR_CACHE.combat_lenght = esoTERM_char.get_combat_lenght()
    ESOTERM_CHAR_CACHE.combat_damage = esoTERM_char.get_combat_damage()

    esoTERM_common.register_for_event(esoTERM_char,
                                      EVENT_PLAYER_COMBAT_STATE,
                                      esoTERM_char.on_combat_state_update)
    esoTERM_common.register_for_event(esoTERM_char,
                                      EVENT_UNIT_DEATH_STATE_CHANGED,
                                      esoTERM_char.on_unit_death_state_change)

    esoTERM_char.is_active = true
    esoTERM_char.settings[esoTERM_char.module_name] = esoTERM_char.is_active
end

function esoTERM_char.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_char)

    esoTERM_char.is_active = false
    esoTERM_char.settings[esoTERM_char.module_name] = esoTERM_char.is_active
end

return esoTERM_char
