pinfo = {}
pinfo.ADDON_NAME = "pinfo"
pinfo.CACHE = {}

function pinfo.on_addon_loaded(event, addon_name)
    pinfo_init.initialize(addon_name)
end

EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                               EVENT_ADD_ON_LOADED,
                               pinfo.on_addon_loaded)

return pinfo
