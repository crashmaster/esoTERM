--
-- Planned player info layout:
--
-- [#1] [#2], [#3] [#4], [#5] [#6] [#7], [#8] [#9] [#10]
--
-- Legend:
--  #1  - Alliance vs. Alliance (AvA.) Rank Name (e.g.: Sergeant)
--  #2  - Character Name (e.g.: Hank)
--  #3  - Level Information (e.g.: Veteran 3)
--  #4  - Class (e.g.: Dragon Knight)
--  #5  - Actual Level Experience / Maximal Level Experience (e.g.: 123/500)
--  #6  - Actual Level Experience per cent (e.g.: 24,6%)
--  #7  - Last Experience Gain (e.g.: +72)
--  #8  - Actual AvA. Experience / Maximal AvA Experience (e.g.: 321/800)
--  #9  - Last AvA. Experience Gain (e.g.: +8)
--  #10 - Actual AvA. Experience per cent (e.g.: 44,6%)
--
-- Not applicable information is skipped.
--

local pinfo = {}

pinfo.PLAYER_UNIT_TAG = "player"

function pinfo.get_character_name(character_info)
    if character_info.name ~= nil then
        return character_info.name
    else
        local name = GetUnitName(pinfo.PLAYER_UNIT_TAG)
        character_info.name = name
        return name
    end
end

function pinfo.is_character_veteran(character_info)
    if character_info.veteran ~= nil then
        return character_info.veteran
    else
        local veteranness = IsUnitVeteran(pinfo.PLAYER_UNIT_TAG)
        character_info.veteran = veteranness
        return veteranness
    end
end

function pinfo._get_character_level_xp(character_info)
    if pinfo.is_character_veteran(character_info) == false then
        return GetUnitXP(pinfo.PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPoints(pinfo.PLAYER_UNIT_TAG)
    end
end

function pinfo.get_character_level_xp(character_info)
    if character_info.level_xp ~= nil then
        return character_info.level_xp
    else
        local level_xp = pinfo._get_character_level_xp(character_info)
        character_info.level_xp = level_xp
        return level_xp
    end
end

function pinfo._get_character_level(character_info)
    if pinfo.is_character_veteran(character_info) == false then
        return GetUnitLevel(pinfo.PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranRank(pinfo.PLAYER_UNIT_TAG)
    end
end

function pinfo.get_character_level(character_info)
    if character_info.level ~= nil then
        return character_info.level
    else
        local level = pinfo._get_character_level(character_info)
        character_info.level = level
        return level
    end
end

function pinfo.get_character_gender(character_info)
    if character_info.gender ~= nil then
        return character_info.gender
    else
        local gender = GetUnitGender(pinfo.PLAYER_UNIT_TAG)
        character_info.gender = gender
        return gender
    end
end

function pinfo.get_character_ava_rank(character_info)
    if character_info.ava_rank ~= nil then
        return character_info.ava_rank
    else
        local ava_rank, ava_sub_rank = GetUnitAvARank(pinfo.PLAYER_UNIT_TAG)
        character_info.ava_rank = ava_rank
        character_info.ava_sub_rank = ava_sub_rank
        return ava_rank, ava_sub_rank
    end
end

function pinfo.get_character_ava_rank_name(character_info)
    if character_info.ava_rank_name ~= nil then
        return character_info.ava_rank_name
    else
        local gender = pinfo.get_character_gender(character_info)
        local rank = pinfo.get_character_ava_rank(character_info)
        local rank_name = GetAvARankName(gender, rank)
        character_info.ava_rank_name = rank_name
        return rank_name
    end
end

function pinfo.get_character_class(character_info)
    if character_info.class ~= nil then
        return character_info.class
    else
        local class = GetUnitClass(pinfo.PLAYER_UNIT_TAG)
        character_info.class = class
        return class
    end
end

function pinfo._get_character_level_xp_max(character_info)
    if pinfo.is_character_veteran(character_info) == false then
        return GetUnitXPMax(pinfo.PLAYER_UNIT_TAG)
    else
        return GetUnitVeteranPointsMax(pinfo.PLAYER_UNIT_TAG)
    end
end

function pinfo.get_character_level_xp_max(character_info)
    if character_info.level_xp_max ~= nil then
        return character_info.level_xp_max
    else
        local level_xp_max = pinfo._get_character_level_xp_max(character_info)
        character_info.level_xp_max = level_xp_max
        return level_xp_max
    end
end

function pinfo.get_character_level_xp_percent(character_info)
    local level_xp_max = pinfo.get_character_level_xp_max(character_info)
    local level_xp = pinfo.get_character_level_xp(character_info)
    return level_xp * 100 / level_xp_max
end

function pinfo.get_character_rank_points(character_info)
    if character_info.rank_points ~= nil then
        return character_info.rank_points
    else
        local rank_points = GetUnitAvARankPoints(pinfo.PLAYER_UNIT_TAG)
        character_info.rank_points = rank_points
        return rank_points
    end
end

return pinfo
