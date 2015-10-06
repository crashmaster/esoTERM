esoTERM_pve = {}

esoTERM_pve.cache = {}
esoTERM_pve.event_register = {}
esoTERM_pve.module_name = "pve"
esoTERM_pve.is_active = false

local ESOTERM_PVE_CACHE = esoTERM_pve.cache
local PLAYER_UNIT_TAG = "player"

function esoTERM_pve.is_veteran()
    if ESOTERM_PVE_CACHE.veteran ~= nil then
        return ESOTERM_PVE_CACHE.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

local function _get_level()
    if esoTERM_pve.is_veteran() == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function esoTERM_pve.get_level()
    if ESOTERM_PVE_CACHE.level ~= nil then
        return ESOTERM_PVE_CACHE.level
    else
        return _get_level()
    end
end

function esoTERM_pve.get_level_xp()
    if ESOTERM_PVE_CACHE.level_xp ~= nil then
        return ESOTERM_PVE_CACHE.level_xp
    else
        if esoTERM_pve.is_veteran() == false then
            return GetUnitXP(PLAYER_UNIT_TAG)
        else
            return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
        end
    end
end

function esoTERM_pve.get_level_xp_max()
    if ESOTERM_PVE_CACHE.level_xp_max ~= nil then
        return ESOTERM_PVE_CACHE.level_xp_max
    else
        if esoTERM_pve.is_veteran() == false then
            return GetUnitXPMax(PLAYER_UNIT_TAG)
        else
            return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
        end
    end
end

function esoTERM_pve.get_level_xp_percent()
    if ESOTERM_PVE_CACHE.level_xp_percent ~= nil then
        return ESOTERM_PVE_CACHE.level_xp_percent
    else
        local level_xp = esoTERM_pve.get_level_xp()
        local level_xp_max = esoTERM_pve.get_level_xp_max()
        if level_xp_max > 0 then
            return level_xp * 100 / level_xp_max
        else
            return 0
        end
    end
end

function esoTERM_pve.get_xp_gain()
    if ESOTERM_PVE_CACHE.xp_gain ~= nil then
        return ESOTERM_PVE_CACHE.xp_gain
    else
        return 0
    end
end

local function get_xp_message()
    return string.format("Gained %d XP (%.2f%%)",
                         esoTERM_pve.get_xp_gain(),
                         esoTERM_pve.get_level_xp_percent())
end

function esoTERM_pve.on_experience_update(event, unit, xp, xp_max, reason)
    if unit == PLAYER_UNIT_TAG and xp_max ~= 0 and ESOTERM_PVE_CACHE.level_xp ~= xp then
        if reason > -1 then
            ESOTERM_PVE_CACHE.xp_gain = xp - ESOTERM_PVE_CACHE.level_xp
        end
        ESOTERM_PVE_CACHE.level_xp = xp
        ESOTERM_PVE_CACHE.level_xp_max = xp_max
        if xp > xp_max then
            ESOTERM_PVE_CACHE.level_xp_percent = 100
        else
            ESOTERM_PVE_CACHE.level_xp_percent = xp * 100 / xp_max
        end

        esoTERM_output.stdout(get_xp_message())
    end
end

function esoTERM_pve.on_level_update(event, unit, level)
    if unit == PLAYER_UNIT_TAG then
        ESOTERM_PVE_CACHE.level = level
    end
end

function esoTERM_pve.initialize()
    esoTERM_pve.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        2,
        "active_modules",
        {[esoTERM_pve.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_pve)

    if esoTERM_pve.settings[esoTERM_pve.module_name] then
        esoTERM_pve.activate()
    end
end

function esoTERM_pve.activate()
    ESOTERM_PVE_CACHE.veteran = esoTERM_pve.is_veteran()
    ESOTERM_PVE_CACHE.level = esoTERM_pve.get_level()
    ESOTERM_PVE_CACHE.level_xp = esoTERM_pve.get_level_xp()
    ESOTERM_PVE_CACHE.level_xp_max = esoTERM_pve.get_level_xp_max()
    ESOTERM_PVE_CACHE.level_xp_percent = esoTERM_pve.get_level_xp_percent()
    ESOTERM_PVE_CACHE.xp_gain = esoTERM_pve.get_xp_gain()

    if ESOTERM_PVE_CACHE.veteran then
        esoTERM_common.register_for_event(esoTERM_pve,
                                          EVENT_VETERAN_POINTS_UPDATE,
                                          esoTERM_pve.on_experience_update)
    else
        esoTERM_common.register_for_event(esoTERM_pve,
                                          EVENT_EXPERIENCE_UPDATE,
                                          esoTERM_pve.on_experience_update)
        esoTERM_common.register_for_event(esoTERM_pve,
                                          EVENT_LEVEL_UPDATE,
                                          esoTERM_pve.on_level_update)
    end
    esoTERM_common.register_for_event(esoTERM_pve,
                                      EVENT_VETERAN_RANK_UPDATE,
                                      esoTERM_pve.on_level_update)

    esoTERM_pve.is_active = true
    esoTERM_pve.settings[esoTERM_pve.module_name] = esoTERM_pve.is_active
end

function esoTERM_pve.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_pve)

    esoTERM_pve.is_active = false
    esoTERM_pve.settings[esoTERM_pve.module_name] = esoTERM_pve.is_active
end

return esoTERM_pve
