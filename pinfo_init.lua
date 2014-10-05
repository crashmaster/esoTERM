pinfo_init = {}

function pinfo_init.initialize(addon_name)
    if addon_name == pinfo.ADDON_NAME then
        pinfo_event_handler.initialize()
        pinfo_slash.initialize()
        pinfo_char.initialize()
        pinfo_output.initialize()

        EVENT_MANAGER:UnregisterForEvent(pinfo.ADDON_NAME, EVENT_ADD_ON_LOADED)
    end
end

return pinfo_init
