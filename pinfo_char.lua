local PLAYER_UNIT_TAG = "player"
local CACHE = pinfo.CHARACTER_INFO

pinfo_char = {}

function pinfo_char.is_character_veteran(cache)
    if cache.veteran ~= nil then
        return cache.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_gender(cache)
    if cache.gender ~= nil then
        return cache.gender
    else
        return GetUnitGender(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_class(cache)
    if cache.class ~= nil then
        return cache.class
    else
        return GetUnitClass(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_name(cache)
    if cache.name ~= nil then
        return cache.name
    else
        return GetUnitName(PLAYER_UNIT_TAG)
    end
end

local function _get_character_level(cache)
    if pinfo_char.is_character_veteran(cache) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level(cache)
    if cache.level ~= nil then
        return cache.level
    else
        return _get_character_level(cache)
    end
end

local function _get_character_level_xp(cache)
    if pinfo_char.is_character_veteran(cache) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level_xp(cache)
    if cache.level_xp ~= nil then
        return cache.level_xp
    else
        return _get_character_level_xp(cache)
    end
end

local function _get_character_level_xp_max(cache)
    if pinfo_char.is_character_veteran(cache) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level_xp_max(cache)
    if cache.level_xp_max ~= nil then
        return cache.level_xp_max
    else
        return _get_character_level_xp_max(cache)
    end
end

function pinfo_char.get_character_level_xp_percent(cache)
    if cache.level_xp_percent ~= nil then
        return cache.level_xp_percent
    else
        local level_xp = pinfo_char.get_character_level_xp(cache)
        local level_xp_max = pinfo_char.get_character_level_xp_max(cache)
        if level_xp_max > 0 then
            return level_xp * 100 / level_xp_max
        else
            return 0
        end
    end
end

function pinfo_char.get_character_xp_gain(cache)
    if cache.xp_gain ~= nil then
        return cache.xp_gain
    else
        return 0
    end
end

function pinfo_char.get_character_ava_rank(cache)
    if cache.ava_rank ~= nil then
        return cache.ava_rank
    else
        local rank, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return rank
    end
end

function pinfo_char.get_character_ava_sub_rank(cache)
    if cache.ava_sub_rank ~= nil then
        return cache.ava_sub_rank
    else
        local rank, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return sub_rank
    end
end

function pinfo_char.get_character_ava_rank_name(cache)
    if cache.ava_rank_name ~= nil then
        return cache.ava_rank_name
    else
        local gender = pinfo_char.get_character_gender(cache)
        local rank = pinfo_char.get_character_ava_rank(cache)
        return GetAvARankName(gender, rank)
    end
end

function pinfo_char.get_character_ava_rank_points(cache)
    if cache.ava_rank_points ~= nil then
        return cache.ava_rank_points
    else
        return GetUnitAvARankPoints(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_ava_rank_points_max(cache)
    if cache.ava_rank_points_max ~= nil then
        return cache.ava_rank_points_max
    else
        local rank_points = pinfo_char.get_character_ava_rank_points(cache)
        local sRSA, nSRA, rSA, rank_points_max = GetAvARankProgress(rank_points)
        return rank_points_max
    end
end

function pinfo_char.get_character_ava_rank_points_percent(cache)
    if cache.ava_rank_points_percent ~= nil then
        return cache.ava_rank_points_percent
    else
        local rank_points = pinfo_char.get_character_ava_rank_points(cache)
        local rank_points_max = pinfo_char.get_character_ava_rank_points_max(cache)
        return rank_points * 100 / rank_points_max
    end
end

function pinfo_char.get_character_ava_point_gain(cache)
    if cache.ava_point_gain ~= nil then
        return cache.ava_point_gain
    else
        return 0
    end
end

function pinfo_char.initialize()
    CACHE.veteran = pinfo_char.is_character_veteran(CACHE)
    CACHE.gender = pinfo_char.get_character_gender(CACHE)
    CACHE.class = pinfo_char.get_character_class(CACHE)
    CACHE.name = pinfo_char.get_character_name(CACHE)
    CACHE.level = pinfo_char.get_character_level(CACHE)
    CACHE.level_xp = pinfo_char.get_character_level_xp(CACHE)
    CACHE.level_xp_max = pinfo_char.get_character_level_xp_max(CACHE)
    CACHE.level_xp_percent = pinfo_char.get_character_level_xp_percent(CACHE)
    CACHE.xp_gain = pinfo_char.get_character_xp_gain(CACHE)
    CACHE.ava_rank = pinfo_char.get_character_ava_rank(CACHE)
    CACHE.ava_sub_rank = pinfo_char.get_character_ava_sub_rank(CACHE)
    CACHE.ava_rank_name = pinfo_char.get_character_ava_rank_name(CACHE)
    CACHE.ava_rank_points = pinfo_char.get_character_ava_rank_points(CACHE)
    CACHE.ava_rank_points_max = pinfo_char.get_character_ava_rank_points_max(CACHE)
    CACHE.ava_rank_points_percent = pinfo_char.get_character_ava_rank_points_percent(CACHE)
    CACHE.ava_point_gain = pinfo_char.get_character_ava_point_gain(CACHE)
end

return pinfo_char
