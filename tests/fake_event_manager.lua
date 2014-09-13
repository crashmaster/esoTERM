event_manager = {}

REGISTER_FOR = nil

EVENT_ADD_ON_LOADED = 0
EVENT_PLAYER_ACTIVATED = 1
EVENT_EXPERIENCE_UPDATE = 2
EVENT_VETERAN_POINTS_UPDATE = 3
EVENT_LEVEL_UPDATE = 4
EVENT_VETERAN_RANK_UPDATE = 5
EVENT_ALLIANCE_POINT_UPDATE = 6
EVENT_LOOT_RECEIVED = 7
EVENT_PLAYER_COMBAT_STATE = 8

function event_manager:UnregisterForEvent(operation, event)
end

function event_manager:RegisterForEvent(addon, event, callback)
end

return event_manager
