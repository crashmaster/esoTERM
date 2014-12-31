local PLAYER_UNIT_TAG = "player"

esoTERM_pvp = {}
esoTERM_pvp.cache = {}
esoTERM_pvp.event_register = {}

local CACHE = esoTERM_pvp.cache
local EVENT_REGISTER = esoTERM_pvp.event_register

local module_name = "pvp module"

function esoTERM_pvp.get_ava_points(cache)
    if cache.ava_points ~= nil then
        return cache.ava_points
    else
        local points = GetUnitAvARankPoints(PLAYER_UNIT_TAG)
        return points
    end
end

function esoTERM_pvp.get_ava_rank(cache)
    if cache.ava_rank ~= nil then
        return cache.ava_rank
    else
        local rank, _ = GetUnitAvARank(PLAYER_UNIT_TAG)
        return rank
    end
end

function esoTERM_pvp.get_ava_sub_rank(cache)
    if cache.ava_sub_rank ~= nil then
        return cache.ava_sub_rank
    else
        local _, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return sub_rank
    end
end

function esoTERM_pvp.get_ava_rank_name(cache)
    if cache.ava_rank_name ~= nil then
        return cache.ava_rank_name
    else
        local gender = esoTERM_char.get_gender(cache)
        local rank = esoTERM_pvp.get_ava_rank(cache)
        return GetAvARankName(gender, rank)
    end
end

function esoTERM_pvp.get_ava_rank_points_lb(cache)
    if cache.ava_rank_points_lb ~= nil then
        return cache.ava_rank_points_lb
    else
        local rank = esoTERM_pvp.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank)
    end
end

function esoTERM_pvp.get_ava_rank_points_ub(cache)
    if cache.ava_rank_points_ub ~= nil then
        return cache.ava_rank_points_ub
    else
        local rank = esoTERM_pvp.get_ava_rank(cache)
        return GetNumPointsNeededForAvARank(rank + 1)
    end
end

function esoTERM_pvp.get_ava_rank_points(cache)
    if cache.ava_rank_points ~= nil then
        return cache.ava_rank_points
    else
        local overall_points = esoTERM_pvp.get_ava_points(cache)
        local rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb(cache)
        return overall_points - rank_points_lb
    end
end

function esoTERM_pvp.get_ava_rank_points_max(cache)
    if cache.ava_rank_points_max ~= nil then
        return cache.ava_rank_points_max
    else
        local rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb(cache)
        local rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub(cache)
        return rank_points_ub - rank_points_lb
    end
end

function esoTERM_pvp.get_ava_rank_points_percent(cache)
    if cache.ava_rank_points_percent ~= nil then
        return cache.ava_rank_points_percent
    else
        local rank_points = esoTERM_pvp.get_ava_rank_points(cache)
        local rank_points_max = esoTERM_pvp.get_ava_rank_points_max(cache)
        return rank_points * 100 / rank_points_max
    end
end

function esoTERM_pvp.get_ap_gain(cache)
    if cache.ap_gain ~= nil then
        return cache.ap_gain
    else
        return 0
    end
end

local function get_ap_message()
    return string.format("Gained %d AP (%.2f%%)",
                         esoTERM_pvp.get_ap_gain(CACHE),
                         esoTERM_pvp.get_ava_rank_points_percent(CACHE))
end

function esoTERM_pvp.on_ava_points_update(event, point, sound, diff)
    if diff > 0 then
        local new_rank_points = CACHE.ava_rank_points + diff

        if new_rank_points > CACHE.ava_rank_points_max then
            CACHE.ava_rank = nil
            CACHE.ava_rank = esoTERM_pvp.get_ava_rank(CACHE)
            new_rank_points = new_rank_points - CACHE.ava_rank_points_max
            CACHE.ava_rank_points_max = nil
            CACHE.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max(CACHE)
        end

        CACHE.ava_rank_points = new_rank_points
        CACHE.ava_rank_points_percent = new_rank_points * 100 / CACHE.ava_rank_points_max
        CACHE.ap_gain = diff

        esoTERM_output.stdout(get_ap_message())
    end
end

function esoTERM_pvp.initialize()
    CACHE.ava_points = esoTERM_pvp.get_ava_points(CACHE)
    CACHE.ava_rank = esoTERM_pvp.get_ava_rank(CACHE)
    CACHE.ava_sub_rank = esoTERM_pvp.get_ava_sub_rank(CACHE)
    CACHE.ava_rank_name = esoTERM_pvp.get_ava_rank_name(CACHE)
    CACHE.ava_rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb(CACHE)
    CACHE.ava_rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub(CACHE)
    CACHE.ava_rank_points = esoTERM_pvp.get_ava_rank_points(CACHE)
    CACHE.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max(CACHE)
    CACHE.ava_rank_points_percent = esoTERM_pvp.get_ava_rank_points_percent(CACHE)
    CACHE.ap_gain = esoTERM_pvp.get_ap_gain(CACHE)

    esoTERM_common.register_for_event(EVENT_REGISTER,
                                      EVENT_ALLIANCE_POINT_UPDATE,
                                      esoTERM_pvp.on_ava_points_update)

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_pvp)
end

return esoTERM_pvp
