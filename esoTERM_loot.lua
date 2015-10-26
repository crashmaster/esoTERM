esoTERM_loot = {}

esoTERM_loot.cache = {}
esoTERM_loot.event_register = {}

esoTERM_loot.module_name = "loot"
esoTERM_loot.is_active = false

local ESOTERM_LOOT_CACHE = esoTERM_loot.cache

function esoTERM_loot.get_loot_quantity()
    if ESOTERM_LOOT_CACHE.loot_quantity ~= nil then
        return ESOTERM_LOOT_CACHE.loot_quantity
    else
        return 0
    end
end

function esoTERM_loot.get_looted_item()
    if ESOTERM_LOOT_CACHE.looted_item ~= nil then
        return ESOTERM_LOOT_CACHE.looted_item
    else
        return "N/A"
    end
end

local function get_loot_message()
    local item = esoTERM_loot.get_looted_item()
    local color = GetItemQualityColor(GetItemLinkQuality(item))
    return string.format("Received %d %s%s%s",
                         esoTERM_loot.get_loot_quantity(),
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

local function get_money_received_message(new_amount, old_amount)
    local received = new_amount - old_amount
    return "Received " .. received .. " gold, now you have " .. new_amount .. " gold"
end

local function get_money_spent_message(new_amount, old_amount)
    local spent = old_amount - new_amount
    return "Spent " .. spent .. " gold, now you have " .. new_amount .. " gold"
end

function esoTERM_loot.on_money_received(event, new_amount, old_amount, reason)
    if new_amount > old_amount then
        esoTERM_output.stdout(get_money_received_message(new_amount, old_amount))
    elseif old_amount > new_amount then
        esoTERM_output.stdout(get_money_spent_message(new_amount, old_amount))
    else
        return
    end
end

-- TODO: duplicate code
function esoTERM_loot.initialize()
    esoTERM_loot.settings = ZO_SavedVars:New(
        "esoTERM_settings",
        2,
        "active_modules",
        {[esoTERM_loot.module_name] = true}
    )

    esoTERM_common.register_module(esoTERM.module_register, esoTERM_loot)

    if esoTERM_loot.settings[esoTERM_loot.module_name] then
        esoTERM_loot.activate()
    end
end

function esoTERM_loot.activate()
    ESOTERM_LOOT_CACHE.loot_quantity = esoTERM_loot.get_loot_quantity()
    ESOTERM_LOOT_CACHE.looted_item = esoTERM_loot.get_looted_item()

    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_LOOT_RECEIVED,
                                      esoTERM_loot.on_loot_received)
    esoTERM_common.register_for_event(esoTERM_loot,
                                      EVENT_MONEY_UPDATE,
                                      esoTERM_loot.on_money_received)

    esoTERM_loot.is_active = true
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

function esoTERM_loot.deactivate()
    esoTERM_common.unregister_from_all_events(esoTERM_loot)

    esoTERM_loot.is_active = false
    esoTERM_loot.settings[esoTERM_loot.module_name] = esoTERM_loot.is_active
end

return esoTERM_loot
