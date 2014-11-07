esoTERM_loot = {}
esoTERM_loot.cache = {}
local CACHE = esoTERM_loot.cache

function esoTERM_loot.get_loot_quantity(cache)
    if cache.loot_quantity ~= nil then
        return cache.loot_quantity
    else
        return 0
    end
end

function esoTERM_loot.get_looted_item(cache)
    if cache.looted_item ~= nil then
        return cache.looted_item
    else
        return "N/A"
    end
end

local function get_loot_message()
    return string.format("Received %d %s",
                         esoTERM_loot.get_loot_quantity(CACHE),
                         zo_strformat(SI_TOOLTIP_ITEM_NAME,
                                      esoTERM_loot.get_looted_item(CACHE)))
end

function esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if not self then
        return
    end

    CACHE.loot_quantity = quantity
    CACHE.looted_item = item
    esoTERM_output.stdout(get_loot_message())
end

function esoTERM_loot.initialize()
    CACHE.loot_quantity = esoTERM_loot.get_loot_quantity(CACHE)
    CACHE.looted_item = esoTERM_loot.get_looted_item(CACHE)

    EVENT_MANAGER:RegisterForEvent(esoTERM.ADDON_NAME,
                                   EVENT_LOOT_RECEIVED,
                                   esoTERM_loot.on_loot_received)
end

return esoTERM_loot
