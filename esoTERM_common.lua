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

function esoTERM_common.initialize_module(module)
    module.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        2,
        "active_modules",
        {[module.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, module)

    if module.settings[module.module_name] then
        module.activate()
    end
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

local function get_item_input_output_message(format_string, item, quantity, backpack_quantity, bank_quantity)
    local color = GetItemQualityColor(GetItemLinkQuality(item))
    return string.format(format_string,
                         quantity,
                         color:Colorize("["),
                         zo_strformat(SI_TOOLTIP_ITEM_NAME, item),
                         color:Colorize("]"),
                         backpack_quantity,
                         bank_quantity)
end

function esoTERM_common.get_item_received_message(...)
    return get_item_input_output_message("Received %d %s%s%s: backpack: %d, bank: %d", ...)
end

function esoTERM_common.get_got_rid_of_item_message(...)
    return get_item_input_output_message("Got rid of %d %s%s%s: backpack: %d, bank: %d", ...)
end

return esoTERM_common
