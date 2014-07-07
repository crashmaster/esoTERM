pinfo_init = {}

function pinfo_init.initialize(addon_name, pinfo)
    if addon_name == pinfo.ADDON_NAME then
        EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                       EVENT_VETERAN_POINTS_UPDATE,
                                       pinfo_event_handler.on_experience_update)

        EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                       EVENT_EXPERIENCE_UPDATE,
                                       pinfo_event_handler.on_experience_update)

        EVENT_MANAGER:UnregisterForEvent(REGISTER_FOR,
                                         EVENT_ADD_ON_LOADED)

        pinfo_event_handler.initialize(pinfo)
        pinfo_output.initialize(pinfo)

        pinfo_char.update(pinfo.CHARACTER_INFO)
    end
end

return pinfo_init
