esoTERM_crafting = {}

esoTERM_crafting.module_name = "crafting"

function esoTERM_crafting.on_craft_completed_update(event, craft_skill)
end

-- TODO: duplicate code
function esoTERM_crafting.initialize()
    esoTERM_crafting.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        2,
        "active_modules",
        {[esoTERM_crafting.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_crafting)

    if esoTERM_crafting.settings[esoTERM_crafting.module_name] then
        esoTERM_crafting.activate()
    end
end

function esoTERM_crafting.activate()
    esoTERM_common.register_for_event(esoTERM_crafting,
                                      EVENT_CRAFT_COMPLETED,
                                      esoTERM_crafting.on_craft_completed_update)

    esoTERM_crafting.is_active = true
    esoTERM_crafting.settings[esoTERM_crafting.module_name] = esoTERM_crafting.is_active
end

return esoTERM_crafting
