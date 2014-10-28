esoTERM_init = {}

function esoTERM_init.initialize(addon_name)
    if addon_name == esoTERM.ADDON_NAME then
        esoTERM_event_handler.initialize()
        esoTERM_slash.initialize()
        esoTERM_char.initialize()
        esoTERM_output.initialize()

        EVENT_MANAGER:UnregisterForEvent(esoTERM.ADDON_NAME, EVENT_ADD_ON_LOADED)
    end
end

return esoTERM_init
