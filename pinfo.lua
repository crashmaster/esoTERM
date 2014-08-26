pinfo = {}
pinfo.ADDON_NAME = "pinfo"
pinfo.CACHE = {}

function pinfo.on_addon_loaded(event, addon_name)
    pinfo_init.initialize(addon_name)
end

EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                               EVENT_ADD_ON_LOADED,
                               pinfo.on_addon_loaded)

function pinfo.on_loot_received(eventCode,
                                lootedBy,
                                itemName,
                                quantity,
                                itemSound,
                                lootType,
                                self)
    if self then
        d(zo_strformat("<<t:1>>", itemName))
    end
end

EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                               EVENT_LOOT_RECEIVED,
                               pinfo.on_loot_received)

return pinfo
