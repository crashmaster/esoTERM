esoTERM_crafting = {}

esoTERM_crafting.module_name = "crafting"

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
end

return esoTERM_crafting
