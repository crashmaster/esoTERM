esoTERM_champ = {}

esoTERM_champ.event_register = {}
esoTERM_champ.module_name = "esoTERM-champion"
esoTERM_champ.is_active = false

local function get_champion_xp_message()
    return string.format("Current champion XP is %d", GetPlayerChampionXP())
end

local function get_player_champion_points_earned_message()
    return string.format("Champion points earned is %d", GetPlayerChampionPointsEarned())
end

local function get_champion_xp_in_rank_message()
    return string.format("Champion xp in rank is %d", GetChampionXPInRank(GetPlayerChampionPointsEarned()))
end

function esoTERM_champ.on_experience_update(...)
    esoTERM_output.stdout(get_champion_xp_message())
    esoTERM_output.stdout(get_player_champion_points_earned_message())
    esoTERM_output.stdout(get_champion_xp_in_rank_message())
end

function esoTERM_champ.on_champion_point_gain(...)
    d(...)
end

function esoTERM_champ.initialize()
    esoTERM_common.register_for_event(esoTERM_champ,
                                      EVENT_EXPERIENCE_UPDATE,
                                      esoTERM_champ.on_experience_update)
    esoTERM_common.register_for_event(esoTERM_champ,
                                      EVENT_CHAMPION_POINT_GAINED,
                                      esoTERM_champ.on_champion_point_gain)
    esoTERM_champ.is_active = true
end

function esoTERM_champ.deactivate()
    esoTERM_champ.is_active = false
end

return esoTERM_champ
