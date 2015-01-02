esoTERM_common = {}

function esoTERM_common.register_for_event(local_register, event, callback)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME, event, callback)
    local_register[event] = true
end

function esoTERM_common.unregister_from_event(local_register, event)
    EVENT_MANAGER:UnregisterForEvent(esoTERM.ADDON_NAME, event)
    local_register[event] = false
end

function esoTERM_common.unregister_from_all_events(local_register)
    for event, is_active in pairs(local_register) do
        if is_active then
            esoTERM_common.unregister_from_event(local_register, event)
        end
    end
end

function esoTERM_common.register_module(module_register, module)
    table.insert(module_register, module)
end

function esoTERM_common.split(input_string)
    local result = {}
    for sub_string in string.gmatch(input_string, "%S+") do
        table.insert(result, sub_string)
    end
    return result
end

return esoTERM_common
