esoTERM = {}
esoTERM.ADDON_NAME = "esoTERM"
esoTERM.CACHE = {}

function esoTERM.on_addon_loaded(event, addon_name)
    esoTERM_init.initialize(addon_name)
end

EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                               EVENT_ADD_ON_LOADED,
                               esoTERM.on_addon_loaded)

return esoTERM
