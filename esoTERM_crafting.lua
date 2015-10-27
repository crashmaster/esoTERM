esoTERM_crafting = {}

esoTERM_crafting.module_name = "crafting"

function esoTERM_crafting.on_craft_completed_update(event, craft_skill)
end

function esoTERM_crafting.initialize()
    esoTERM_common.initialize_module(esoTERM_crafting)
end

function esoTERM_crafting.activate()
    esoTERM_common.register_for_event(esoTERM_crafting,
                                      EVENT_CRAFT_COMPLETED,
                                      esoTERM_crafting.on_craft_completed_update)

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
