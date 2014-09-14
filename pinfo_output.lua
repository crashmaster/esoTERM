local CACHE = pinfo.CACHE

pinfo_output = {}
pinfo_output.PROMPT = "[pinfo] "
pinfo_output.default_settings = {chat_tab_number = 1}

local xp_message_buffer = {}
local ap_message_buffer = {}

function pinfo_output.initialize()
    pinfo_output.settings = ZO_SavedVars:New("pinfo_saved_variables",
                                             1,
                                             nil,
                                             pinfo_output.default_settings)
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   pinfo_output.on_player_activated)
end

function pinfo_output.set_n_th_chat_tab_as_output(chat_tab_number)
    local chat_tab = string.format("ZO_ChatWindowTemplate%d", chat_tab_number)
    local chat_tab_name = string.format("ZO_ChatWindowTabTemplate%dText", chat_tab_number)

    pinfo_output.chat_tab = _G[chat_tab].buffer
    pinfo_output.chat_tab_name = _G[chat_tab_name]:GetText()
    if chat_tab_number ~= pinfo_output.settings.chat_tab_number then
        pinfo_output.settings.chat_tab_number = chat_tab_number
    end
    pinfo_output.system_message("Output chat tab is: " .. pinfo_output.chat_tab_name)
end

local function xp_message_to_print()
    return string.format("+%s+ +%d+ +%s+ +%.2f%%+ (+%d XP)",
                pinfo_char.get_character_name(CACHE),
                pinfo_char.get_character_level(CACHE),
                pinfo_char.get_character_class(CACHE),
                pinfo_char.get_character_level_xp_percent(CACHE),
                pinfo_char.get_character_xp_gain(CACHE))
end

local function ap_message_to_print()
    return string.format("+%s+ +%s+ +%s+ +%.2f%%+ (+%d AP)",
                pinfo_char.get_character_ava_rank_name(CACHE),
                pinfo_char.get_character_name(CACHE),
                pinfo_char.get_character_class(CACHE),
                pinfo_char.get_character_ava_rank_points_percent(CACHE),
                pinfo_char.get_character_ava_points_gain(CACHE))
end

local function store_xp_message_before_player_activated()
    table.insert(xp_message_buffer, xp_message_to_print())
end

local function print_xp_message()
    pinfo_output.chat_tab:AddMessage(xp_message_to_print())
end

local function store_ap_message_before_player_activated()
    table.insert(ap_message_buffer, ap_message_to_print())
end

local function print_ap_message()
    pinfo_output.chat_tab:AddMessage(ap_message_to_print())
end

pinfo_output.xp_to_chat_tab = store_xp_message_before_player_activated
pinfo_output.ap_to_chat_tab = store_ap_message_before_player_activated

local function print_message_buffer(buffer)
    for _, message in ipairs(buffer) do
        pinfo_output.chat_tab:AddMessage(message)
    end
end

function pinfo_output.on_player_activated(event)
    local chat_tab_number = pinfo_output.default_settings.chat_tab_number

    if pinfo_output.settings.chat_tab_number ~= nil then
        chat_tab_number = pinfo_output.settings.chat_tab_number
    end

    pinfo_output.set_n_th_chat_tab_as_output(chat_tab_number)

    print_message_buffer(xp_message_buffer)
    pinfo_output.xp_to_chat_tab = print_xp_message

    print_message_buffer(ap_message_buffer)
    pinfo_output.ap_to_chat_tab = print_ap_message
end

function pinfo_output.item_to_chat_tab(item_name, quantity)
    formatted_item = zo_strformat("<<t:1>>", item_name)
    pinfo_output.chat_tab:AddMessage(string.format("+%s+ receives +%d+ +%s+",
                                                   pinfo_char.get_character_name(CACHE),
                                                   quantity,
                                                   formatted_item))
end

function pinfo_output.combat_state_to_chat_tab()
    local message
    if pinfo_char.get_character_combat_state(CACHE) then
        message = string.format("+%s+ enters the fight",
                                pinfo_char.get_character_name(CACHE))
    else
        message = string.format("+%s+ leaves the fight (lasted: %.2f s)",
                                pinfo_char.get_character_name(CACHE),
                                pinfo_char.get_combat_lenght(CACHE) / 1000)
    end
    pinfo_output.chat_tab:AddMessage(message)
end

function pinfo_output.system_message(message)
    d(pinfo_output.PROMPT .. message)
end

return pinfo_output
