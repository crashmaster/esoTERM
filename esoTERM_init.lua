esoTERM_init = {}

function esoTERM_init.initialize(addon_name)
    if addon_name == esoTERM.ADDON_NAME then
        esoTERM_output.initialize()
        esoTERM_char.initialize()
        esoTERM_pve.initialize()
        esoTERM_pvp.initialize()
        esoTERM_loot.initialize()
        esoTERM_slash.initialize()
        esoTERM_window.initialize()

        esoTERM_output.stdout("esoTERM is active")
        CALLBACK_MANAGER:FireCallbacks("esoTERMModulesInitialized")

        EVENT_MANAGER:UnregisterForEvent(esoTERM.ADDON_NAME, EVENT_ADD_ON_LOADED)
    end
end

return esoTERM_init
