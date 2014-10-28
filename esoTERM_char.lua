local PLAYER_UNIT_TAG = "player"
local CACHE = esoTERM.CACHE

esoTERM_char = {}

function esoTERM_char.is_veteran(cache)
    if cache.veteran ~= nil then
        return cache.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

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

local function _get_level(cache)
    if esoTERM_char.is_veteran(cache) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_level(cache)
    if cache.level ~= nil then
        return cache.level
    else
        return _get_level(cache)
    end
end

local function _get_level_xp(cache)
    if esoTERM_char.is_veteran(cache) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_level_xp(cache)
    if cache.level_xp ~= nil then
        return cache.level_xp
    else
        return _get_level_xp(cache)
    end
end

local function _get_level_xp_max(cache)
    if esoTERM_char.is_veteran(cache) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function esoTERM_char.get_level_xp_max(cache)
    if cache.level_xp_max ~= nil then
        return cache.level_xp_max
    else
        return _get_level_xp_max(cache)
    end
end

function esoTERM_char.get_level_xp_percent(cache)
    if cache.level_xp_percent ~= nil then
        return cache.level_xp_percent
    else
        local level_xp = esoTERM_char.get_level_xp(cache)
        local level_xp_max = esoTERM_char.get_level_xp_max(cache)
        if level_xp_max > 0 then
            return level_xp * 100 / level_xp_max
        else
            return 0
        end
    end
end

function esoTERM_char.get_xp_gain(cache)
    if cache.xp_gain ~= nil then
        return cache.xp_gain
    else
        return 0
    end
end

function esoTERM_char.get_ava_points(cache)
    if cache.ava_points ~= nil then
        return cache.ava_points
    else
        local points = GetUnitAvARankPoints(PLAYER_UNIT_TAG)
        return points
    end
end

function esoTERM_char.get_ava_rank(cache)
    if cache.ava_rank ~= nil then
        return cache.ava_rank
    else
        local rank, _ = GetUnitAvARank(PLAYER_UNIT_TAG)
        return rank
    end
end

function esoTERM_char.get_ava_sub_rank(cache)
    if cache.ava_sub_rank ~= nil then
        return cache.ava_sub_rank
    else
        local _, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return sub_rank
    end
end

function esoTERM_char.get_ava_rank_name(cache)
    if cache.ava_rank_name ~= nil then
        return cache.ava_rank_name
    else
        local gender = esoTERM_char.get_gender(cache)
        local rank = esoTERM_char.get_ava_rank(cache)
        return GetAvARankName(gender, rank)
    end
end

function esoTERM_char.get_ava_rank_points_lb(cache)
    if cache.ava_rank_points_lb ~= nil then
        return cache.ava_rank_points_lb
    else
        local rank = esoTERM_char.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank)
    end
end

function esoTERM_char.get_ava_rank_points_ub(cache)
    if cache.ava_rank_points_ub ~= nil then
        return cache.ava_rank_points_ub
    else
        local rank = esoTERM_char.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank + 1)
    end
end

function esoTERM_char.get_ava_rank_points(cache)
    if cache.ava_rank_points ~= nil then
        return cache.ava_rank_points
    else
        local overall_points = esoTERM_char.get_ava_points(cache)
        local rank_points_lb = esoTERM_char.get_ava_rank_points_lb(cache)
        return overall_points - rank_points_lb
    end
end

function esoTERM_char.get_ava_rank_points_max(cache)
    if cache.ava_rank_points_max ~= nil then
        return cache.ava_rank_points_max
    else
        local rank_points_lb = esoTERM_char.get_ava_rank_points_lb(cache)
        local rank_points_ub = esoTERM_char.get_ava_rank_points_ub(cache)
        return rank_points_ub - rank_points_lb
    end
end

function esoTERM_char.get_ava_rank_points_percent(cache)
    if cache.ava_rank_points_percent ~= nil then
        return cache.ava_rank_points_percent
    else
        local rank_points = esoTERM_char.get_ava_rank_points(cache)
        local rank_points_max = esoTERM_char.get_ava_rank_points_max(cache)
        return rank_points * 100 / rank_points_max
    end
end

function esoTERM_char.get_ap_gain(cache)
    if cache.ap_gain ~= nil then
        return cache.ap_gain
    else
        return 0
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

function esoTERM_char.initialize()
    CACHE.veteran = esoTERM_char.is_veteran(CACHE)
    CACHE.gender = esoTERM_char.get_gender(CACHE)
    CACHE.class = esoTERM_char.get_class(CACHE)
    CACHE.name = esoTERM_char.get_name(CACHE)
    CACHE.level = esoTERM_char.get_level(CACHE)
    CACHE.level_xp = esoTERM_char.get_level_xp(CACHE)
    CACHE.level_xp_max = esoTERM_char.get_level_xp_max(CACHE)
    CACHE.level_xp_percent = esoTERM_char.get_level_xp_percent(CACHE)
    CACHE.xp_gain = esoTERM_char.get_xp_gain(CACHE)
    CACHE.ava_points = esoTERM_char.get_ava_points(CACHE)
    CACHE.ava_rank = esoTERM_char.get_ava_rank(CACHE)
    CACHE.ava_sub_rank = esoTERM_char.get_ava_sub_rank(CACHE)
    CACHE.ava_rank_name = esoTERM_char.get_ava_rank_name(CACHE)
    CACHE.ava_rank_points_lb = esoTERM_char.get_ava_rank_points_lb(CACHE)
    CACHE.ava_rank_points_ub = esoTERM_char.get_ava_rank_points_ub(CACHE)
    CACHE.ava_rank_points = esoTERM_char.get_ava_rank_points(CACHE)
    CACHE.ava_rank_points_max = esoTERM_char.get_ava_rank_points_max(CACHE)
    CACHE.ava_rank_points_percent = esoTERM_char.get_ava_rank_points_percent(CACHE)
    CACHE.ap_gain = esoTERM_char.get_ap_gain(CACHE)
    CACHE.combat_state = esoTERM_char.get_combat_state(CACHE)
    CACHE.combat_start_time = esoTERM_char.get_combat_start_time(CACHE)
    CACHE.combat_lenght = esoTERM_char.get_combat_lenght(CACHE)
    CACHE.combat_damage = esoTERM_char.get_combat_damage(CACHE)
end

return esoTERM_char
