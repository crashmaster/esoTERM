local CACHE = pinfo.CHARACTER_INFO

pinfo_event_handler = {}

function pinfo_event_handler.initialize()
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_VETERAN_POINTS_UPDATE,
                                   pinfo_event_handler.on_experience_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_EXPERIENCE_UPDATE,
                                   pinfo_event_handler.on_experience_update)
end

function pinfo_event_handler.on_experience_update(event, unit, xp, xp_max, reason)
    if ((unit == "player") and (reason > -1) and (xp_max ~= 0)) then
        CACHE.xp_gain = xp - CACHE.level_xp
        CACHE.level_xp = xp
        CACHE.level_xp_max = xp_max
        CACHE.level_xp_percent = xp * 100 / xp_max

        pinfo_output.character_info_to_debug()
    end
end

return pinfo_event_handler
