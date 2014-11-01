esoTERM_loot = {}

function esoTERM_loot.initialize()
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_LOOT_RECEIVED,
                                   esoTERM_loot.on_loot_received)
end

function esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if self then
        esoTERM_output.loot_to_chat_tab(item, quantity)
    end
end

return esoTERM_loot
