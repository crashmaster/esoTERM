pinfo_init = {}

function pinfo_init.initialize(addon_name, pinfo)
    if addon_name == pinfo.ADDON_NAME then
        pinfo_event_handler.initialize(pinfo)
        pinfo_output.initialize(pinfo)
        pinfo_char.initialize(pinfo.CHARACTER_INFO)

        EVENT_MANAGER:UnregisterForEvent(REGISTER_FOR, EVENT_ADD_ON_LOADED)
    end
end

return pinfo_init
