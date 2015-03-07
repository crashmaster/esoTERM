esoTERM_champ = {}

esoTERM_champ.module_name = "esoTERM-champion"
esoTERM_champ.is_active = false

function esoTERM_champ.initialize()
    esoTERM_champ.is_active = true
end

function esoTERM_champ.deactivate()
    esoTERM_champ.is_active = false
end

return esoTERM_champ
