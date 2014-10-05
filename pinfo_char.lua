local PLAYER_UNIT_TAG = "player"
local CACHE = pinfo.CACHE

pinfo_char = {}

function pinfo_char.is_veteran(cache)
    if cache.veteran ~= nil then
        return cache.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_gender(cache)
    if cache.gender ~= nil then
        return cache.gender
    else
        return GetUnitGender(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_class(cache)
    if cache.class ~= nil then
        return cache.class
    else
        return GetUnitClass(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_name(cache)
    if cache.name ~= nil then
        return cache.name
    else
        return GetUnitName(PLAYER_UNIT_TAG)
    end
end

local function _get_level(cache)
    if pinfo_char.is_veteran(cache) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_level(cache)
    if cache.level ~= nil then
        return cache.level
    else
        return _get_level(cache)
    end
end

local function _get_level_xp(cache)
    if pinfo_char.is_veteran(cache) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_level_xp(cache)
    if cache.level_xp ~= nil then
        return cache.level_xp
    else
        return _get_level_xp(cache)
    end
end

local function _get_level_xp_max(cache)
    if pinfo_char.is_veteran(cache) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_level_xp_max(cache)
    if cache.level_xp_max ~= nil then
        return cache.level_xp_max
    else
        return _get_level_xp_max(cache)
    end
end

function pinfo_char.get_level_xp_percent(cache)
    if cache.level_xp_percent ~= nil then
        return cache.level_xp_percent
    else
        local level_xp = pinfo_char.get_level_xp(cache)
        local level_xp_max = pinfo_char.get_level_xp_max(cache)
        if level_xp_max > 0 then
            return level_xp * 100 / level_xp_max
        else
            return 0
        end
    end
end

function pinfo_char.get_xp_gain(cache)
    if cache.xp_gain ~= nil then
        return cache.xp_gain
    else
        return 0
    end
end

function pinfo_char.get_ava_points(cache)
    if cache.ava_points ~= nil then
        return cache.ava_points
    else
        local points = GetUnitAvARankPoints(PLAYER_UNIT_TAG)
        return points
    end
end

function pinfo_char.get_ava_rank(cache)
    if cache.ava_rank ~= nil then
        return cache.ava_rank
    else
        local rank, _ = GetUnitAvARank(PLAYER_UNIT_TAG)
        return rank
    end
end

function pinfo_char.get_ava_sub_rank(cache)
    if cache.ava_sub_rank ~= nil then
        return cache.ava_sub_rank
    else
        local _, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return sub_rank
    end
end

function pinfo_char.get_ava_rank_name(cache)
    if cache.ava_rank_name ~= nil then
        return cache.ava_rank_name
    else
        local gender = pinfo_char.get_gender(cache)
        local rank = pinfo_char.get_ava_rank(cache)
        return GetAvARankName(gender, rank)
    end
end

function pinfo_char.get_ava_rank_points_lb(cache)
    if cache.ava_rank_points_lb ~= nil then
        return cache.ava_rank_points_lb
    else
        local rank = pinfo_char.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank)
    end
end

function pinfo_char.get_ava_rank_points_ub(cache)
    if cache.ava_rank_points_ub ~= nil then
        return cache.ava_rank_points_ub
    else
        local rank = pinfo_char.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank + 1)
    end
end

function pinfo_char.get_ava_rank_points(cache)
    if cache.ava_rank_points ~= nil then
        return cache.ava_rank_points
    else
        local overall_points = pinfo_char.get_ava_points(cache)
        local rank_points_lb = pinfo_char.get_ava_rank_points_lb(cache)
        return overall_points - rank_points_lb
    end
end

function pinfo_char.get_ava_rank_points_max(cache)
    if cache.ava_rank_points_max ~= nil then
        return cache.ava_rank_points_max
    else
        local rank_points_lb = pinfo_char.get_ava_rank_points_lb(cache)
        local rank_points_ub = pinfo_char.get_ava_rank_points_ub(cache)
        return rank_points_ub - rank_points_lb
    end
end

function pinfo_char.get_ava_rank_points_percent(cache)
    if cache.ava_rank_points_percent ~= nil then
        return cache.ava_rank_points_percent
    else
        local rank_points = pinfo_char.get_ava_rank_points(cache)
        local rank_points_max = pinfo_char.get_ava_rank_points_max(cache)
        return rank_points * 100 / rank_points_max
    end
end

function pinfo_char.get_ap_gain(cache)
    if cache.ap_gain ~= nil then
        return cache.ap_gain
    else
        return 0
    end
end

function pinfo_char.get_combat_state(cache)
    if cache.combat_state ~= nil then
        return cache.combat_state
    else
        return IsUnitInCombat(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_combat_start_time(cache)
    if cache.combat_start_time ~= nil then
        return cache.combat_start_time
    else
        return 0
    end
end

function pinfo_char.get_combat_lenght(cache)
    if cache.combat_lenght ~= nil and cache.combat_lenght > 0 then
        return cache.combat_lenght
    else
        return 0
    end
end

function pinfo_char.get_combat_damage(cache)
    if cache.combat_damage ~= nil then
        return cache.combat_damage
    else
        return 0
    end
end

function pinfo_char.initialize()
    CACHE.veteran = pinfo_char.is_veteran(CACHE)
    CACHE.gender = pinfo_char.get_gender(CACHE)
    CACHE.class = pinfo_char.get_class(CACHE)
    CACHE.name = pinfo_char.get_name(CACHE)
    CACHE.level = pinfo_char.get_level(CACHE)
    CACHE.level_xp = pinfo_char.get_level_xp(CACHE)
    CACHE.level_xp_max = pinfo_char.get_level_xp_max(CACHE)
    CACHE.level_xp_percent = pinfo_char.get_level_xp_percent(CACHE)
    CACHE.xp_gain = pinfo_char.get_xp_gain(CACHE)
    CACHE.ava_points = pinfo_char.get_ava_points(CACHE)
    CACHE.ava_rank = pinfo_char.get_ava_rank(CACHE)
    CACHE.ava_sub_rank = pinfo_char.get_ava_sub_rank(CACHE)
    CACHE.ava_rank_name = pinfo_char.get_ava_rank_name(CACHE)
    CACHE.ava_rank_points_lb = pinfo_char.get_ava_rank_points_lb(CACHE)
    CACHE.ava_rank_points_ub = pinfo_char.get_ava_rank_points_ub(CACHE)
    CACHE.ava_rank_points = pinfo_char.get_ava_rank_points(CACHE)
    CACHE.ava_rank_points_max = pinfo_char.get_ava_rank_points_max(CACHE)
    CACHE.ava_rank_points_percent = pinfo_char.get_ava_rank_points_percent(CACHE)
    CACHE.ap_gain = pinfo_char.get_ap_gain(CACHE)
    CACHE.combat_state = pinfo_char.get_combat_state(CACHE)
    CACHE.combat_start_time = pinfo_char.get_combat_start_time(CACHE)
    CACHE.combat_lenght = pinfo_char.get_combat_lenght(CACHE)
    CACHE.combat_damage = pinfo_char.get_combat_damage(CACHE)
end

return pinfo_char
