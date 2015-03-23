esoTERM_pvp = {}

esoTERM_pvp.cache = {}
esoTERM_pvp.event_register = {}
esoTERM_pvp.module_name = "pvp"
esoTERM_pvp.is_active = false

local ESOTERM_PVP_CACHE = esoTERM_pvp.cache
local PLAYER_UNIT_TAG = "player"

function esoTERM_pvp.get_ava_points()
    if ESOTERM_PVP_CACHE.ava_points ~= nil then
        return ESOTERM_PVP_CACHE.ava_points
    else
        local points = GetUnitAvARankPoints(PLAYER_UNIT_TAG)
        return points
    end
end

function esoTERM_pvp.get_ava_rank()
    if ESOTERM_PVP_CACHE.ava_rank ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank
    else
        local rank, _ = GetUnitAvARank(PLAYER_UNIT_TAG)
        return rank
    end
end

function esoTERM_pvp.get_ava_sub_rank()
    if ESOTERM_PVP_CACHE.ava_sub_rank ~= nil then
        return ESOTERM_PVP_CACHE.ava_sub_rank
    else
        local _, sub_rank = GetUnitAvARank(PLAYER_UNIT_TAG)
        return sub_rank
    end
end

function esoTERM_pvp.get_ava_rank_name()
    if ESOTERM_PVP_CACHE.ava_rank_name ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_name
    else
        local gender = esoTERM_char.get_gender()
        local rank = esoTERM_pvp.get_ava_rank()
        return GetAvARankName(gender, rank)
    end
end

function esoTERM_pvp.get_ava_rank_points_lb()
    if ESOTERM_PVP_CACHE.ava_rank_points_lb ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_points_lb
    else
        local rank = esoTERM_pvp.get_ava_rank()
        return GetNumPointsNeededForAvARank(rank)
    end
end

function esoTERM_pvp.get_ava_rank_points_ub()
    if ESOTERM_PVP_CACHE.ava_rank_points_ub ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_points_ub
    else
        local rank = esoTERM_pvp.get_ava_rank()
        return GetNumPointsNeededForAvARank(rank + 1)
    end
end

function esoTERM_pvp.get_ava_rank_points()
    if ESOTERM_PVP_CACHE.ava_rank_points ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_points
    else
        local overall_points = esoTERM_pvp.get_ava_points()
        local rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb()
        return overall_points - rank_points_lb
    end
end

function esoTERM_pvp.get_ava_rank_points_max()
    if ESOTERM_PVP_CACHE.ava_rank_points_max ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_points_max
    else
        local rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb()
        local rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub()
        return rank_points_ub - rank_points_lb
    end
end

function esoTERM_pvp.get_ava_rank_points_percent()
    if ESOTERM_PVP_CACHE.ava_rank_points_percent ~= nil then
        return ESOTERM_PVP_CACHE.ava_rank_points_percent
    else
        local rank_points = esoTERM_pvp.get_ava_rank_points()
        local rank_points_max = esoTERM_pvp.get_ava_rank_points_max()
        return rank_points * 100 / rank_points_max
    end
end

function esoTERM_pvp.get_ap_gain()
    if ESOTERM_PVP_CACHE.ap_gain ~= nil then
        return ESOTERM_PVP_CACHE.ap_gain
    else
        return 0
    end
end

local function get_ap_message()
    return string.format("Gained %d AP (%.2f%%)",
                         esoTERM_pvp.get_ap_gain(),
                         esoTERM_pvp.get_ava_rank_points_percent())
end

function esoTERM_pvp.on_ava_points_update(event, point, sound, diff)
    if diff > 0 then
        local new_rank_points = ESOTERM_PVP_CACHE.ava_rank_points + diff

        if new_rank_points > ESOTERM_PVP_CACHE.ava_rank_points_max then
            ESOTERM_PVP_CACHE.ava_rank = nil
            ESOTERM_PVP_CACHE.ava_rank = esoTERM_pvp.get_ava_rank()
            new_rank_points = new_rank_points - ESOTERM_PVP_CACHE.ava_rank_points_max
            ESOTERM_PVP_CACHE.ava_rank_points_max = nil
            ESOTERM_PVP_CACHE.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max()
        end

        ESOTERM_PVP_CACHE.ava_rank_points = new_rank_points
        ESOTERM_PVP_CACHE.ava_rank_points_percent = new_rank_points * 100 / ESOTERM_PVP_CACHE.ava_rank_points_max
        ESOTERM_PVP_CACHE.ap_gain = diff

        esoTERM_output.stdout(get_ap_message())
    end
end

function esoTERM_pvp.initialize()
    esoTERM_pvp.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        2,
        "active_modules",
        {[esoTERM_pvp.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_pvp)

    if esoTERM_pvp.settings[esoTERM_pvp.module_name] then
        esoTERM_pvp.activate()
    end
end

function esoTERM_pvp.activate()
    ESOTERM_PVP_CACHE.ava_points = esoTERM_pvp.get_ava_points()
    ESOTERM_PVP_CACHE.ava_rank = esoTERM_pvp.get_ava_rank()
    ESOTERM_PVP_CACHE.ava_sub_rank = esoTERM_pvp.get_ava_sub_rank()
    ESOTERM_PVP_CACHE.ava_rank_name = esoTERM_pvp.get_ava_rank_name()
    ESOTERM_PVP_CACHE.ava_rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb()
    ESOTERM_PVP_CACHE.ava_rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub()
    ESOTERM_PVP_CACHE.ava_rank_points = esoTERM_pvp.get_ava_rank_points()
    ESOTERM_PVP_CACHE.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max()
    ESOTERM_PVP_CACHE.ava_rank_points_percent = esoTERM_pvp.get_ava_rank_points_percent()
    ESOTERM_PVP_CACHE.ap_gain = esoTERM_pvp.get_ap_gain()

    esoTERM_common.register_for_event(esoTERM_pvp,
                                      EVENT_ALLIANCE_POINT_UPDATE,
                                      esoTERM_pvp.on_ava_points_update)

    esoTERM_pvp.is_active = true
    esoTERM_pvp.settings[esoTERM_pvp.module_name] = esoTERM_pvp.is_active
end

function esoTERM_pvp.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_pvp)

    esoTERM_pvp.is_active = false
    esoTERM_pvp.settings[esoTERM_pvp.module_name] = esoTERM_pvp.is_active
end

return esoTERM_pvp
