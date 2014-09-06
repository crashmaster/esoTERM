local CACHE = pinfo.CACHE

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
                                   pinfo_event_handler.on_ava_points_update)

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_LOOT_RECEIVED,
                                   pinfo_event_handler.on_loot_received)
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

        pinfo_output.xp_to_chat_tab()
    end
end

function pinfo_event_handler.on_level_update(event, unit, level)
    if (unit == "player") then
        CACHE.level = level
    end
end

function pinfo_event_handler.on_ava_points_update(event, point, sound, diff)
    if (diff > 0) then
        local new_rank_points = CACHE.ava_rank_points + diff

        if new_rank_points > CACHE.ava_rank_points_max then
            CACHE.ava_rank = nil
            CACHE.ava_rank = pinfo_char.get_character_ava_rank(CACHE)
            new_rank_points = new_rank_points - CACHE.ava_rank_points_max
            CACHE.ava_rank_points_max = nil
            CACHE.ava_rank_points_max = pinfo_char.get_character_ava_rank_points_max(CACHE)
        end

        CACHE.ava_rank_points = new_rank_points
        CACHE.ava_rank_points_percent = new_rank_points * 100 / CACHE.ava_rank_points_max
        CACHE.ava_points_gain = diff

        pinfo_output.ap_to_chat_tab()
    end
end

function pinfo_event_handler.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if self then
        pinfo_output.item_to_chat_tab(item, quantity)
    end
end

return pinfo_event_handler
