esoTERM_loot = {}
esoTERM_loot.cache = {}
local CACHE = esoTERM_loot.cache

function esoTERM_loot.get_looted_item(cache)
    if cache.looted_item ~= nil then
        return cache.looted_item
    else
        return "N/A"
    end
end

function esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if self then
        esoTERM_output.loot_to_chat_tab(item, quantity)
    end
end

function esoTERM_loot.initialize()
    CACHE.looted_item = esoTERM_loot.get_looted_item(CACHE)
    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_LOOT_RECEIVED,
                                   esoTERM_loot.on_loot_received)
end

return esoTERM_loot
