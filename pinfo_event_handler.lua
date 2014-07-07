local CHARACTER_INFO = nil

pinfo_event_handler = {}

function pinfo_event_handler.initialize(pinfo)
    CHARACTER_INFO = pinfo.CHARACTER_INFO
end

function pinfo_event_handler.on_experience_update(event, unit_tag, xp, xp_max, reason)
    if ((unit_tag == "player") and (reason > -1) and (xp_max ~= 0)) then
        CHARACTER_INFO.level_xp = xp
        CHARACTER_INFO.level_xp_max = xp_max
        CHARACTER_INFO.level_xp_percent = xp * 100 / xp_max

        pinfo_output.character_info_to_debug()
    end
end

return pinfo_event_handler
