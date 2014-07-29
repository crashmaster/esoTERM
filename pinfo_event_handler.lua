local CACHE = pinfo.CHARACTER_INFO

pinfo_event_handler = {}

function pinfo_event_handler.initialize()
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_EXPERIENCE_UPDATE,
                                   pinfo_event_handler.on_experience_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_VETERAN_POINTS_UPDATE,
                                   pinfo_event_handler.on_experience_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_LEVEL_UPDATE,
                                   pinfo_event_handler.on_level_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_VETERAN_RANK_UPDATE,
                                   pinfo_event_handler.on_level_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_ALLIANCE_POINT_UPDATE,
                                   pinfo_event_handler.on_ava_point_update)
end

function pinfo_event_handler.on_ava_point_update(event, point, sound, diff)
--    ap, bp, cp, dp = GetAvARankProgress(point)
    d(string.format("+%d", diff))
--    d(string.format("subStart: %d subNext: %d start: %d next: %d", ap, bp, cp, dp))
    CACHE.ava_rank_points_percent = point * 100 / CACHE.ava_rank_points_max
    CACHE.ava_point_gain = diff
end

function pinfo_event_handler.on_experience_update(event, unit, xp, xp_max, reason)
    if ((unit == "player") and (xp_max ~= 0) and (CACHE.level_xp ~= xp)) then
        if (reason > -1) then
            CACHE.xp_gain = xp - CACHE.level_xp
        end
        CACHE.level_xp = xp
        CACHE.level_xp_max = xp_max
        if (xp > xp_max) then
            CACHE.level_xp_percent = 100
        else
            CACHE.level_xp_percent = xp * 100 / xp_max
        end

        pinfo_output.character_info_to_debug()
    end
end

function pinfo_event_handler.on_level_update(event, unit, level)
    if (unit == "player") then
        CACHE.level = level
    end
end

return pinfo_event_handler
