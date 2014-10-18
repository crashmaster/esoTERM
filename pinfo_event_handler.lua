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

function pinfo_event_handler.dump_event(result,
                                        event_not_ok,
                                        ability_name,
                                        ability_graphic,
                                        action_slot_type,
                                        source_name,
                                        source_type,
                                        target_name,
                                        target_type,
                                        hit_value,
                                        power_type,
                                        damage_type,
                                        log)
    local message = string.format(
        "EVENT -> r:%d+e:%s+an:%s+ag:%d+at:%d+s:%s+st:%d+t:%s+tt:%d+h:%d+p:%d+d:%d)",
        result,
        tostring(event_not_ok),
        ability_name,
        ability_graphic,
        action_slot_type,
        source_name,
        source_type,
        target_name,
        target_type,
        hit_value,
        power_type,
        damage_type)
    pinfo_output.stdout(message)
end

function pinfo_event_handler.on_combat_event_update(event,
                                                    result,
                                                    event_not_ok,
                                                    ability_name,
                                                    ability_graphic,
                                                    action_slot_type,
                                                    source_name,
                                                    source_type,
                                                    target_name,
                                                    target_type,
                                                    hit_value,
                                                    power_type,
                                                    damage_type,
                                                    log)
    local result_not_ok = result ~= ACTION_RESULT_DAMAGE and
                          result ~= ACTION_RESULT_CRITICAL_DAMAGE and
                          result ~= ACTION_RESULT_DOT_TICK and
                          result ~= ACTION_RESULT_DOT_TICK_CRITICAL
    if result_not_ok then return end

    if event_not_ok then return end

    local source_name_not_ok = source_name == ""
    if source_name_not_ok then return end

    local target_name_not_ok = target_name == ""
    if target_name_not_ok then return end

    local source_type_not_ok = source_type ~= COMBAT_UNIT_TYPE_PLAYER and
                               source_type ~= COMBAT_UNIT_TYPE_PLAYER_PET
    if source_type_not_ok then
        pinfo_event_handler.dump_event(result, event_not_ok, ability_name, ability_graphic, action_slot_type, source_name, source_type, target_name, target_type, hit_value, power_type, damage_type, log)
        return
    end

    local hit_value_not = hit_value < 1
    if hit_value_not then return end

    local power_type_not_ok = power_type == POWERTYPE_INVALID
    if power_type_not_ok then return end

    local damage_type_not_ok = damage_type < 1
    if damage_type_not_ok then
        pinfo_event_handler.dump_event(result, event_not_ok, ability_name, ability_graphic, action_slot_type, source_name, source_type, target_name, target_type, hit_value, power_type, damage_type, log)
        return
    end

    CACHE.combat_damage = CACHE.combat_damage + hit_value
    local message = string.format("%s deals damage with %s for: %d",
                                  pinfo_char.get_name(CACHE),
                                  ability_name,
                                  hit_value)
    pinfo_output.stdout(message)
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
