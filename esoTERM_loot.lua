esoTERM_loot = {}

esoTERM_loot.cache = {}
esoTERM_loot.event_register = {}

esoTERM_loot.module_name = "esoTERM-loot"
esoTERM_loot.is_active = false

local ESOTERM_LOOT_CACHE = esoTERM_loot.cache
local ESOTERM_LOOT_EVENT_REGISTER = esoTERM_loot.event_register

function esoTERM_loot:get_loot_quantity()
    if ESOTERM_LOOT_CACHE.loot_quantity ~= nil then
        return ESOTERM_LOOT_CACHE.loot_quantity
    else
        return 0
    end
end

function esoTERM_loot:get_looted_item()
    if ESOTERM_LOOT_CACHE.looted_item ~= nil then
        return ESOTERM_LOOT_CACHE.looted_item
    else
        return "N/A"
    end
end

local function get_loot_message()
    local item = esoTERM_loot:get_looted_item()
    local color = GetItemQualityColor(GetItemLinkQuality(item))
    return string.format("Received %d %s%s%s",
                         esoTERM_loot:get_loot_quantity(),
                         color:Colorize("["),
                         zo_strformat(SI_TOOLTIP_ITEM_NAME, item),
                         color:Colorize("]"))
end

function esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
    if not self then
        return
    end

    ESOTERM_LOOT_CACHE.loot_quantity = quantity
    ESOTERM_LOOT_CACHE.looted_item = item

    esoTERM_output.stdout(get_loot_message())
end

local function get_money_loot_message(new_amount, old_amount)
    local looted = new_amount - old_amount
    return "Received " .. looted .. " gold, now you have " .. new_amount .. " gold"
end

function esoTERM_loot.on_money_received(event, new_amount, old_amount, reason)
    esoTERM_output.stdout(get_money_loot_message(new_amount, old_amount))
end

function esoTERM_loot:initialize()
    ESOTERM_LOOT_CACHE.loot_quantity = esoTERM_loot:get_loot_quantity()
    ESOTERM_LOOT_CACHE.looted_item = esoTERM_loot:get_looted_item()

    esoTERM_common.register_for_event(ESOTERM_LOOT_EVENT_REGISTER,
                                      EVENT_LOOT_RECEIVED,
                                      esoTERM_loot.on_loot_received)
    esoTERM_common.register_for_event(ESOTERM_LOOT_EVENT_REGISTER,
                                      EVENT_MONEY_UPDATE,
                                      esoTERM_loot.on_money_received)

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_loot)

    esoTERM_loot.is_active = true
end

function esoTERM_loot.deactivate()
    esoTERM_common.unregister_from_all_events(ESOTERM_LOOT_EVENT_REGISTER)

    esoTERM_loot.is_active = false
end

return esoTERM_loot
