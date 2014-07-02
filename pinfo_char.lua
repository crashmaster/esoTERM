pinfo_char = {}

local PLAYER_UNIT_TAG = "player"

function pinfo_char.get_character_name(character_info)
    if character_info.name ~= nil then
        return character_info.name
    else
        return GetUnitName(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.is_character_veteran(character_info)
    if character_info.veteran ~= nil then
        return character_info.veteran
    else
        return IsUnitVeteran(PLAYER_UNIT_TAG)
    end
end

local function _get_character_level_xp(character_info)
    if pinfo_char.is_character_veteran(character_info) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level_xp(character_info)
    if character_info.level_xp ~= nil then
        return character_info.level_xp
    else
        return _get_character_level_xp(character_info)
    end
end

local function _get_character_level(character_info)
    if pinfo_char.is_character_veteran(character_info) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level(character_info)
    if character_info.level ~= nil then
        return character_info.level
    else
        return _get_character_level(character_info)
    end
end

function pinfo_char.get_character_gender(character_info)
    if character_info.gender ~= nil then
        return character_info.gender
    else
        return GetUnitGender(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_ava_rank(character_info)
    if character_info.ava_rank ~= nil then
        return character_info.ava_rank, character_info.ava_sub_rank
    else
        return GetUnitAvARank(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_ava_rank_name(character_info)
    if character_info.ava_rank_name ~= nil then
        return character_info.ava_rank_name
    else
        local gender = pinfo_char.get_character_gender(character_info)
        local rank = pinfo_char.get_character_ava_rank(character_info)
        return GetAvARankName(gender, rank)
    end
end

function pinfo_char.get_character_class(character_info)
    if character_info.class ~= nil then
        return character_info.class
    else
        return GetUnitClass(PLAYER_UNIT_TAG)
    end
end

local function _get_character_level_xp_max(character_info)
    if pinfo_char.is_character_veteran(character_info) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_level_xp_max(character_info)
    if character_info.level_xp_max ~= nil then
        return character_info.level_xp_max
    else
        return _get_character_level_xp_max(character_info)
    end
end

function pinfo_char.get_character_level_xp_percent(character_info)
    if character_info.level_xp_percent ~= nil then
        return character_info.level_xp_percent
    else
        local level_xp_max = pinfo_char.get_character_level_xp_max(character_info)
        local level_xp = pinfo_char.get_character_level_xp(character_info)
        return level_xp * 100 / level_xp_max
    end
end

function pinfo_char.get_character_ava_rank_points(character_info)
    if character_info.ava_rank_points ~= nil then
        return character_info.ava_rank_points
    else
        return GetUnitAvARankPoints(PLAYER_UNIT_TAG)
    end
end

function pinfo_char.get_character_ava_rank_points_max(character_info)
    if character_info.ava_rank_points_max ~= nil then
        return character_info.ava_rank_points_max
    else
        local rank_points = pinfo_char.get_character_ava_rank_points(character_info)
        local sRSA, nSRA, rSA, rank_points_max = GetAvARankProgress(rank_points)
        return rank_points_max
    end
end

function pinfo_char.get_character_ava_rank_points_percent(character_info)
    if character_info.ava_rank_points_percent ~= nil then
        return character_info.ava_rank_points_percent
    else
        local rank_points_max = pinfo_char.get_character_ava_rank_points_max(character_info)
        local rank_points = pinfo_char.get_character_ava_rank_points(character_info)
        return rank_points * 100 / rank_points_max
    end
end

function pinfo_char.update(character_info)
    character_info.veteran = pinfo_char.is_character_veteran(character_info)
    character_info.gender = pinfo_char.get_character_gender(character_info)
    character_info.class = pinfo_char.get_character_class(character_info)
    character_info.name = pinfo_char.get_character_name(character_info)
    character_info.level_xp = pinfo_char.get_character_level_xp(character_info)
    character_info.level_xp_max = pinfo_char.get_character_level_xp_max(character_info)
    character_info.level_xp_percent = pinfo_char.get_character_level_xp_percent(character_info)
    character_info.level = pinfo_char.get_character_level(character_info)
    character_info.ava_rank, character_info.ava_sub_rank = pinfo_char.get_character_ava_rank(character_info)
    character_info.ava_rank_name = pinfo_char.get_character_ava_rank_name(character_info)
    character_info.ava_rank_points = pinfo_char.get_character_ava_rank_points(character_info)
    character_info.ava_rank_points_max = pinfo_char.get_character_ava_rank_points_max(character_info)
    character_info.ava_rank_points_percent = pinfo_char.get_character_ava_rank_points_percent(character_info)
end

return pinfo_char
