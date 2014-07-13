pinfo_init = {}

function pinfo_init.initialize(addon_name, pinfo)
    if addon_name == pinfo.ADDON_NAME then
        pinfo_event_handler.initialize()
        pinfo_char.initialize()

        EVENT_MANAGER:UnregisterForEvent(REGISTER_FOR, EVENT_ADD_ON_LOADED)
    end
end

return pinfo_init
