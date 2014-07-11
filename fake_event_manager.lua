event_manager = {}

REGISTER_FOR = nil
EVENT_ADD_ON_LOADED = nil

function event_manager:UnregisterForEvent(operation, event)
end

function event_manager:RegisterForEvent(addon, event, callback)
end

return event_manager
