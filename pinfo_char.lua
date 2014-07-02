pinfo_char = {}

local PLAYER_UNIT_TAG = "player"

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
        local level_xp_max = pinfo_char.get_character_level_xp_max(cache)
        local level_xp = pinfo_char.get_character_level_xp(cache)
        return level_xp * 100 / level_xp_max
    end
end

function pinfo_char.get_character_ava_rank(cache)
    if cache.ava_rank ~= nil then
        return cache.ava_rank, cache.ava_sub_rank
    else
        return GetUnitAvARank(PLAYER_UNIT_TAG)
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
        local rank_points_max = pinfo_char.get_character_ava_rank_points_max(cache)
        local rank_points = pinfo_char.get_character_ava_rank_points(cache)
        return rank_points * 100 / rank_points_max
    end
end

function pinfo_char.update(cache)
    cache.veteran = pinfo_char.is_character_veteran(cache)
    cache.gender = pinfo_char.get_character_gender(cache)
    cache.class = pinfo_char.get_character_class(cache)
    cache.name = pinfo_char.get_character_name(cache)
    cache.level = pinfo_char.get_character_level(cache)
    cache.level_xp = pinfo_char.get_character_level_xp(cache)
    cache.level_xp_max = pinfo_char.get_character_level_xp_max(cache)
    cache.level_xp_percent = pinfo_char.get_character_level_xp_percent(cache)
    cache.ava_rank, cache.ava_sub_rank = pinfo_char.get_character_ava_rank(cache)
    cache.ava_rank_name = pinfo_char.get_character_ava_rank_name(cache)
    cache.ava_rank_points = pinfo_char.get_character_ava_rank_points(cache)
    cache.ava_rank_points_max = pinfo_char.get_character_ava_rank_points_max(cache)
    cache.ava_rank_points_percent = pinfo_char.get_character_ava_rank_points_percent(cache)
end

return pinfo_char
