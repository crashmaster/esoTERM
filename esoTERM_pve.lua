local PLAYER_UNIT_TAG = "player"

esoTERM_pve = {}
esoTERM_pve.cache = {}
local CACHE = esoTERM_pve.cache

function esoTERM_pve.is_veteran(cache)
    if cache.veteran ~= nil then
        return cache.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

local function _get_level(cache)
    if esoTERM_pve.is_veteran(cache) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function esoTERM_pve.get_level(cache)
    if cache.level ~= nil then
        return cache.level
    else
        return _get_level(cache)
    end
end

local function _get_level_xp(cache)
    if esoTERM_pve.is_veteran(cache) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function esoTERM_pve.get_level_xp(cache)
    if cache.level_xp ~= nil then
        return cache.level_xp
    else
        return _get_level_xp(cache)
    end
end

local function _get_level_xp_max(cache)
    if esoTERM_pve.is_veteran(cache) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function esoTERM_pve.get_level_xp_max(cache)
    if cache.level_xp_max ~= nil then
        return cache.level_xp_max
    else
        return _get_level_xp_max(cache)
    end
end

function esoTERM_pve.get_level_xp_percent(cache)
    if cache.level_xp_percent ~= nil then
        return cache.level_xp_percent
    else
        local level_xp = esoTERM_pve.get_level_xp(cache)
        local level_xp_max = esoTERM_pve.get_level_xp_max(cache)
        if level_xp_max > 0 then
            return level_xp * 100 / level_xp_max
        else
            return 0
        end
    end
end

function esoTERM_pve.get_xp_gain(cache)
    if cache.xp_gain ~= nil then
        return cache.xp_gain
    else
        return 0
    end
end

local function get_xp_message()
    return string.format("Gained %d XP (%.2f%%)",
                         esoTERM_pve.get_xp_gain(CACHE),
                         esoTERM_pve.get_level_xp_percent(CACHE))
end

function esoTERM_pve.on_experience_update(event, unit, xp, xp_max, reason)
    if unit == PLAYER_UNIT_TAG and xp_max ~= 0 and CACHE.level_xp ~= xp then
        if reason > -1 then
            CACHE.xp_gain = xp - CACHE.level_xp
        end
        CACHE.level_xp = xp
        CACHE.level_xp_max = xp_max
        if xp > xp_max then
            CACHE.level_xp_percent = 100
        else
            CACHE.level_xp_percent = xp * 100 / xp_max
        end

        esoTERM_output.stdout(get_xp_message())
    end
end

function esoTERM_pve.on_level_update(event, unit, level)
    if unit == PLAYER_UNIT_TAG then
        CACHE.level = level
    end
end

function esoTERM_pve.initialize()
    CACHE.veteran = esoTERM_pve.is_veteran(CACHE)
    CACHE.level = esoTERM_pve.get_level(CACHE)
    CACHE.level_xp = esoTERM_pve.get_level_xp(CACHE)
    CACHE.level_xp_max = esoTERM_pve.get_level_xp_max(CACHE)
    CACHE.level_xp_percent = esoTERM_pve.get_level_xp_percent(CACHE)
    CACHE.xp_gain = esoTERM_pve.get_xp_gain(CACHE)

    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_EXPERIENCE_UPDATE,
                                   esoTERM_pve.on_experience_update)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_VETERAN_POINTS_UPDATE,
                                   esoTERM_pve.on_experience_update)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_LEVEL_UPDATE,
                                   esoTERM_pve.on_level_update)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_VETERAN_RANK_UPDATE,
                                   esoTERM_pve.on_level_update)
end

return esoTERM_pve
