event_manager = {}

REGISTER_FOR = nil

EVENT_ADD_ON_LOADED = 0
EVENT_EXPERIENCE_UPDATE = 1
EVENT_VETERAN_POINTS_UPDATE = 2

function event_manager:UnregisterForEvent(operation, event)
end

function event_manager:RegisterForEvent(addon, event, callback)
end

return event_manager
