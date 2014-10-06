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

    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_PLAYER_COMBAT_STATE,
                                   pinfo_event_handler.on_combat_state_update)
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
            CACHE.ava_rank = pinfo_char.get_ava_rank(CACHE)
            new_rank_points = new_rank_points - CACHE.ava_rank_points_max
            CACHE.ava_rank_points_max = nil
            CACHE.ava_rank_points_max = pinfo_char.get_ava_rank_points_max(CACHE)
        end

        CACHE.ava_rank_points = new_rank_points
        CACHE.ava_rank_points_percent = new_rank_points * 100 / CACHE.ava_rank_points_max
        CACHE.ap_gain = diff

        pinfo_output.ap_to_chat_tab()
    end
end

function pinfo_event_handler.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if self then
        pinfo_output.loot_to_chat_tab(item, quantity)
    end
end

function pinfo_event_handler.on_combat_event_update(eventCode,
                                                    result,
                                                    isError,
                                                    abilityName,
                                                    abilityGraphic,
                                                    abilityActionSlotType,
                                                    sourceName,
                                                    sourceType,
                                                    targetName,
                                                    targetType,
                                                    hitValue,
                                                    powerType,
                                                    damageType,
                                                    log)

    if sourceName == "" then return end
    if sourceName == targetName then return end

    local unhandled = false
    if sourceName ~= targetName and hitValue > 0 then
        if abilityActionSlotType == 0 or
           abilityActionSlotType == 5 or
           abilityActionSlotType == 6 then
            if damageType > 0 then
                CACHE.combat_damage = CACHE.combat_damage + hitValue
                local message = string.format("%s deals damage with %s for: %d",
                                              pinfo_char.get_name(CACHE),
                                              abilityName,
                                              hitValue)
                pinfo_output.stdout(message)
            else
                unhandled = true
            end
        else
            unhandled = true
        end
    else
        unhandled = true
    end

    if unhandled and hitValue > 0 then
        local message = string.format(
            "UNHANDLED -> r:%d|e:%t|an:%s|ag:%d|at:%d|s:%s|st:%d|t:%s|tt:%d|h:%d|p:%d|d:%d)",
            result,
            isError,
            abilityName,
            abilityGraphic,
            abilityActionSlotType,
            sourceName,
            sourceType,
            targetName,
            targetType,
            hitValue,
            powerType,
            damageType
        )
        pinfo_output.stdout(message)
    end
end

function pinfo_event_handler.enter_combat()
    CACHE.combat_start_time = GetGameTimeMilliseconds()
    CACHE.combat_damage = 0
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_COMBAT_EVENT,
                                   pinfo_event_handler.on_combat_event_update)
    pinfo_output.combat_state_to_chat_tab()
end

function pinfo_event_handler.exit_combat()
    local combat_start_time = pinfo_char.get_combat_start_time(CACHE)
    if combat_start_time > 0 then
        CACHE.combat_lenght = GetGameTimeMilliseconds() - combat_start_time
    else
        CACHE.combat_lenght = -1
    end
    EVENT_MANAGER:UnregisterForEvent(pinfo.ADDON_NAME, EVENT_COMBAT_EVENT)
    pinfo_output.combat_state_to_chat_tab()
    CACHE.combat_start_time = 0
    CACHE.combat_damage = 0
end

function pinfo_event_handler.on_combat_state_update(event, combat_state)
    if pinfo_char.get_combat_state(CACHE) ~= combat_state then
        CACHE.combat_state = combat_state
        if combat_state then
            pinfo_event_handler.enter_combat()
        else
            zo_callLater(pinfo_event_handler.exit_combat, 500)
        end
    end
end

return pinfo_event_handler
