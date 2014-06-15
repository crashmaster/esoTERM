local module = {}

local PLAYER_UNIT_TAG = "player"

function module.get_character_name(character_info)
    if character_info.name ~= nil then
        return character_info.name
    else
        local name = GetUnitName(PLAYER_UNIT_TAG)
        character_info.name = name
        return name
    end
end

function module.is_character_veteran(character_info)
    if character_info.veteran ~= nil then
        return character_info.veteran
    else
        local veteranness = IsUnitVeteran(PLAYER_UNIT_TAG)
        character_info.veteran = veteranness
        return veteranness
    end
end

local function _get_character_level_xp(character_info)
    if module.is_character_veteran(character_info) == false then
        return GetUnitXP(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(PLAYER_UNIT_TAG)
    end
end

function module.get_character_level_xp(character_info)
    if character_info.level_xp ~= nil then
        return character_info.level_xp
    else
        local level_xp = _get_character_level_xp(character_info)
        character_info.level_xp = level_xp
        return level_xp
    end
end

local function _get_character_level(character_info)
    if module.is_character_veteran(character_info) == false then
        return GetUnitLevel(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(PLAYER_UNIT_TAG)
    end
end

function module.get_character_level(character_info)
    if character_info.level ~= nil then
        return character_info.level
    else
        local level = _get_character_level(character_info)
        character_info.level = level
        return level
    end
end

function module.get_character_gender(character_info)
    if character_info.gender ~= nil then
        return character_info.gender
    else
        local gender = GetUnitGender(PLAYER_UNIT_TAG)
        character_info.gender = gender
        return gender
    end
end

function module.get_character_ava_rank(character_info)
    if character_info.ava_rank ~= nil then
        return character_info.ava_rank
    else
        local ava_rank, ava_sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        character_info.ava_rank = ava_rank
        character_info.ava_sub_rank = ava_sub_rank
        return ava_rank, ava_sub_rank
    end
end

function module.get_character_ava_rank_name(character_info)
    if character_info.ava_rank_name ~= nil then
        return character_info.ava_rank_name
    else
        local gender = module.get_character_gender(character_info)
        local rank = module.get_character_ava_rank(character_info)
        local rank_name = GetAvARankName(gender, rank)
        character_info.ava_rank_name = rank_name
        return rank_name
    end
end

function module.get_character_class(character_info)
    if character_info.class ~= nil then
        return character_info.class
    else
        local class = GetUnitClass(PLAYER_UNIT_TAG)
        character_info.class = class
        return class
    end
end

local function _get_character_level_xp_max(character_info)
    if module.is_character_veteran(character_info) == false then
        return GetUnitXPMax(PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(PLAYER_UNIT_TAG)
    end
end

function module.get_character_level_xp_max(character_info)
    if character_info.level_xp_max ~= nil then
        return character_info.level_xp_max
    else
        local level_xp_max = _get_character_level_xp_max(character_info)
        character_info.level_xp_max = level_xp_max
        return level_xp_max
    end
end

function module.get_character_level_xp_percent(character_info)
    local level_xp_max = module.get_character_level_xp_max(character_info)
    local level_xp = module.get_character_level_xp(character_info)
    return level_xp * 100 / level_xp_max
end

function module.get_character_rank_points(character_info)
    if character_info.rank_points ~= nil then
        return character_info.rank_points
    else
        local rank_points = GetUnitAvARankPoints(PLAYER_UNIT_TAG)
        character_info.rank_points = rank_points
        return rank_points
    end
end

function module.get_character_rank_points_max(character_info)
    if character_info.rank_points_max ~= nil then
        return character_info.rank_points_max
    else
        local rank_points = module.get_character_rank_points(character_info)
        local sRSA, nSRA, rSA, rank_points_max = GetAvARankProgress(rank_points)
        character_info.rank_points_max = rank_points_max
        return rank_points_max
    end
end

function module.get_character_rank_points_percent(character_info)
    local rank_points_max = module.get_character_rank_points_max(character_info)
    local rank_points = module.get_character_rank_points(character_info)
    return rank_points * 100 / rank_points_max
end

return module
