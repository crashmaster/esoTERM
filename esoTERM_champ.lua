esoTERM_champ = {}

esoTERM_champ.cache = {}
esoTERM_champ.event_register = {}
esoTERM_champ.module_name = "esoTERM-champion"
esoTERM_champ.is_active = false

local ESOTERM_CHAMP_CACHE = esoTERM_champ.cache

function esoTERM_champ.get_champion_xp()
    if ESOTERM_CHAMP_CACHE.champion_xp ~= nil then
        return ESOTERM_CHAMP_CACHE.champion_xp
    else
        return GetPlayerChampionXP()
    end
end

function esoTERM_champ.get_champion_xp_max()
    if ESOTERM_CHAMP_CACHE.champion_xp_max ~= nil then
        return ESOTERM_CHAMP_CACHE.champion_xp_max
    else
        return GetChampionXPInRank(GetPlayerChampionPointsEarned())
    end
end

local function get_champion_xp_message()
    actual_champion_xp = GetPlayerChampionXP()
    champion_xp_gain = actual_champion_xp - esoTERM_champ.get_champion_xp()
    ESOTERM_CHAMP_CACHE.champion_xp = actual_champion_xp
    champion_xp_percent = esoTERM_champ.get_champion_xp() * 100 / esoTERM_champ.get_champion_xp_max()
    return string.format("Gained %d champion XP (%.2f%%)",
                         champion_xp_gain,
                         champion_xp_percent)
end

function esoTERM_champ.on_experience_update(...)
    esoTERM_output.stdout(get_champion_xp_message())
end

function esoTERM_champ.on_champion_point_gain(...)
    d(...)
    ESOTERM_CHAMP_CACHE.champion_xp_max = GetChampionXPInRank(GetPlayerChampionPointsEarned())
end

function esoTERM_champ.initialize()
    if GetChampionXPInRank(GetPlayerChampionPointsEarned()) == nil then
        return
    end
    ESOTERM_CHAMP_CACHE.champion_xp = esoTERM_champ.get_champion_xp()
    ESOTERM_CHAMP_CACHE.champion_xp_max = esoTERM_champ.get_champion_xp_max()

    esoTERM_common.register_for_event(esoTERM_champ,
                                      EVENT_EXPERIENCE_UPDATE,
                                      esoTERM_champ.on_experience_update)
    esoTERM_common.register_for_event(esoTERM_champ,
                                      EVENT_CHAMPION_POINT_GAINED,
                                      esoTERM_champ.on_champion_point_gain)

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_champ)

    esoTERM_champ.is_active = true
end

function esoTERM_champ.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_champ)

    esoTERM_champ.is_active = false
end

return esoTERM_champ
