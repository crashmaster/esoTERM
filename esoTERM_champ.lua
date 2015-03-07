esoTERM_champ = {}

esoTERM_champ.event_register = {}
esoTERM_champ.module_name = "esoTERM-champion"
esoTERM_champ.is_active = false

local ESOTERM_CHAMP_EVENT_REGISTER = esoTERM_champ.event_register

function esoTERM_champ.on_champion_point_gain(...)
    print(...)
end

function esoTERM_champ.initialize()
    esoTERM_common.register_for_event(ESOTERM_CHAMP_EVENT_REGISTER,
                                      EVENT_CHAMPION_POINT_GAINED,
                                      esoTERM_champ.on_champion_point_gain)
    esoTERM_champ.is_active = true
end

function esoTERM_champ.deactivate()
    esoTERM_champ.is_active = false
end

return esoTERM_champ
