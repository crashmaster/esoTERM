esoTERM_crafting = {}

esoTERM_crafting.event_register = {}
esoTERM_crafting.module_name = "crafting"
esoTERM_crafting.is_active = false

function esoTERM_crafting.on_craft_completed_update(event, craft_skill)
end

function esoTERM_crafting.on_inventory_single_slot_update(event, _bagId_, _slotId_, _isNewItem_, _itemSoundCategory_, _updateReason_)
    if _bagId_ == BAG_BACKPACK then
        local link = GetItemLink(_bagId_, _slotId_, LINK_STYLE_DEFAULT)
        esoTERM_output.stdout(esoTERM_common.get_item_received_message(link, 1))
    end
end

function esoTERM_crafting.initialize()
    esoTERM_common.initialize_module(esoTERM_crafting)
end

function esoTERM_crafting.activate()
    esoTERM_common.register_for_event(esoTERM_crafting,
                                      EVENT_CRAFT_COMPLETED,
                                      esoTERM_crafting.on_craft_completed_update)
--  esoTERM_common.register_for_event(esoTERM_crafting,
--                                    EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
--                                    esoTERM_crafting.on_inventory_single_slot_update)

    esoTERM_crafting.is_active = true
    esoTERM_crafting.settings[esoTERM_crafting.module_name] = esoTERM_crafting.is_active
end

-- TODO: duplicate code
function esoTERM_crafting.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_crafting)

    esoTERM_crafting.is_active = false
    esoTERM_crafting.settings[esoTERM_crafting.module_name] = esoTERM_crafting.is_active
end

return esoTERM_crafting
