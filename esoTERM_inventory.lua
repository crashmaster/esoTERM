esoTERM_inventory = {}

esoTERM_inventory.event_register = {}
esoTERM_inventory.module_name = "inventory"
esoTERM_inventory.is_active = false

function esoTERM_inventory.on_craft_completed_update(event, craft_skill)
end

function esoTERM_inventory.on_inventory_single_slot_update(event, _bagId_, _slotId_, _isNewItem_, _itemSoundCategory_, _updateReason_)
    if _bagId_ == BAG_BACKPACK then
        local link = GetItemLink(_bagId_, _slotId_, LINK_STYLE_DEFAULT)
        esoTERM_output.stdout(esoTERM_common.get_item_received_message(link, 1))
    end
end

function esoTERM_inventory.initialize()
    esoTERM_common.initialize_module(esoTERM_inventory)
end

function esoTERM_inventory.activate()
    esoTERM_common.register_for_event(esoTERM_inventory,
                                      EVENT_CRAFT_COMPLETED,
                                      esoTERM_inventory.on_craft_completed_update)
--  esoTERM_common.register_for_event(esoTERM_inventory,
--                                    EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
--                                    esoTERM_inventory.on_inventory_single_slot_update)

    esoTERM_inventory.is_active = true
    esoTERM_inventory.settings[esoTERM_inventory.module_name] = esoTERM_inventory.is_active
end

-- TODO: duplicate code
function esoTERM_inventory.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_inventory)

    esoTERM_inventory.is_active = false
    esoTERM_inventory.settings[esoTERM_inventory.module_name] = esoTERM_inventory.is_active
end

return esoTERM_inventory
