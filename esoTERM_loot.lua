esoTERM_loot = {}

esoTERM_loot.cache = {}
esoTERM_loot.cache.bag = {}
esoTERM_loot.event_register = {}
esoTERM_loot.module_name = "loot"
esoTERM_loot.is_active = false


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

function esoTERM_loot.on_inventory_single_slot_update(event, bag_id, slot_id, is_new_item, item_sound_category, update_reason)
    if bag_id == BAG_BACKPACK then
        local new_stack_size = GetSlotStackSize(BAG_BACKPACK, slot_id)
        local old_stack_size =  esoTERM_loot.cache.bag[slot_id].stack_size
        if new_stack_size > old_stack_size then
            if old_stack_size == 0 then
                esoTERM_loot.cache.bag[slot_id].item_link = GetItemLink(BAG_BACKPACK, slot_id, LINK_STYLE_DEFAULT)
            end
            esoTERM_loot.cache.bag[slot_id].stack_size = new_stack_size
            esoTERM_output.stdout(
                esoTERM_common.get_item_received_message(
                    esoTERM_loot.cache.bag[slot_id].item_link,
                    new_stack_size - old_stack_size,
                    0,
                    0
                )
            )
        end
        if new_stack_size < old_stack_size then
            esoTERM_output.stdout(
                esoTERM_common.get_got_rid_of_item_message(
                    esoTERM_loot.cache.bag[slot_id].item_link,
                    old_stack_size - new_stack_size,
                    0,
                    0
                )
            )
            if new_stack_size == 0 then
                esoTERM_loot.cache.bag[slot_id].item_link = GetItemLink(BAG_BACKPACK, slot_id, LINK_STYLE_DEFAULT)
            end
            esoTERM_loot.cache.bag[slot_id].stack_size = new_stack_size
        end
    end
end

function esoTERM_loot.initialize_bag_cache()
    local bag_size = GetBagSize(BAG_BACKPACK)
    for i = 0, bag_size - 1, 1 do
        esoTERM_loot.cache.bag[i] = {
            item_link = GetItemLink(BAG_BACKPACK, i, LINK_STYLE_DEFAULT),
            stack_size = GetSlotStackSize(BAG_BACKPACK, i),
        }
    end
end

function esoTERM_loot.initialize()
    esoTERM_common.initialize_module(esoTERM_loot)
    esoTERM_loot.initialize_bag_cache()
end

function esoTERM_loot.activate()
    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_MONEY_UPDATE,
                                      esoTERM_loot.on_money_received)
    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
                                      esoTERM_loot.on_inventory_single_slot_update)

    esoTERM_loot.is_active = true
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

function esoTERM_loot.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_loot)

    esoTERM_loot.is_active = false
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

return esoTERM_loot
