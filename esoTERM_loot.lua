esoTERM_loot = {}
esoTERM_loot.cache = {}
esoTERM_loot.event_register = {}

local CACHE = esoTERM_loot.cache
local EVENT_REGISTER = esoTERM_loot.event_register

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
    local item = esoTERM_loot.get_looted_item(CACHE)
    local color = GetItemQualityColor(GetItemLinkQuality(item))
    return string.format("Received %d %s%s%s",
                         esoTERM_loot.get_loot_quantity(CACHE),
                         color:Colorize("["),
                         zo_strformat(SI_TOOLTIP_ITEM_NAME, item),
                         color:Colorize("]"))
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

    esoTERM_common.register_for_event(EVENT_REGISTER,
                                      EVENT_LOOT_RECEIVED,
                                      esoTERM_loot.on_loot_received)
end

return esoTERM_loot
