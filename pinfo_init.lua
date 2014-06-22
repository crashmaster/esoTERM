local module = {}

function module.initialize(expected_addon_name)
    EVENT_MANAGER:UnregisterForEvent(REGISTER_FOR, EVENT_ADD_ON_LOADED)
end

return module
