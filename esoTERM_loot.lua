esoTERM_loot = {}

esoTERM_loot.cache = {}
esoTERM_loot.event_register = {}

esoTERM_loot.module_name = "loot"
esoTERM_loot.is_active = false

function esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if not self then
        return
    end

    esoTERM_output.stdout(esoTERM_common.get_item_received_message(item, quantity))
end

local function get_money_received_message(new_amount, old_amount)
    local received = new_amount - old_amount
    return "Received " .. received .. " gold, now you have " .. new_amount .. " gold"
end

local function get_money_spent_message(new_amount, old_amount)
    local spent = old_amount - new_amount
    return "Spent " .. spent .. " gold, now you have " .. new_amount .. " gold"
end

function esoTERM_loot.on_money_received(event, new_amount, old_amount, reason)
    if new_amount > old_amount then
        esoTERM_output.stdout(get_money_received_message(new_amount, old_amount))
    elseif old_amount > new_amount then
        esoTERM_output.stdout(get_money_spent_message(new_amount, old_amount))
    else
        return
    end
end

function esoTERM_loot.initialize()
    esoTERM_common.initialize_module(esoTERM_loot)
end

function esoTERM_loot.activate()
    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_LOOT_RECEIVED,
                                      esoTERM_loot.on_loot_received)
    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_MONEY_UPDATE,
                                      esoTERM_loot.on_money_received)

    esoTERM_loot.is_active = true
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

function esoTERM_loot.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_loot)

    esoTERM_loot.is_active = false
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

return esoTERM_loot
