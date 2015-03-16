esoTERM_common = {}

function esoTERM_common.register_for_event(module, event, callback)
    EVENT_MANAGER:RegisterForEvent(module.module_name, event, callback)
    module.event_register[event] = true
end

function esoTERM_common.unregister_from_event(module, event)
    EVENT_MANAGER:UnregisterForEvent(module.module_name, event)
    module.event_register[event] = false
end

function esoTERM_common.unregister_from_all_events(module)
    for event, is_active in pairs(module.event_register) do
        if is_active then
            esoTERM_common.unregister_from_event(module, event)
        end
    end
end

function esoTERM_common.register_module(module_register, module)
    table.insert(module_register, module)
end

function esoTERM_common.get_module(module_register, module_name)
    for _index, value in ipairs(module_register) do
        if string.lower(value.module_name) == string.lower(module_name) then
            return value
        end
    end
end

function esoTERM_common.split(input_string)
    local result = {}
    for sub_string in string.gmatch(input_string, "%S+") do
        table.insert(result, sub_string)
    end
    return result
end

return esoTERM_common
