esoTERM_common = {}

function esoTERM_common.register_for_event(local_register, event, callback)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME, event, callback)
    local_register[event] = true
end

function esoTERM_common.unregister_from_event(local_register, event)
    EVENT_MANAGER:UnregisterForEvent(esoTERM.ADDON_NAME, event)
    local_register[event] = false
end

function esoTERM_common.active_module(module_register, module_name)
    module_register[module_name] = true
end

function esoTERM_common.inactive_module(module_register, module_name)
    module_register[module_name] = false
end

return esoTERM_common
