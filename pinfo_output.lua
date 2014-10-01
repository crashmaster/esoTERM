local CACHE = pinfo.CACHE

pinfo_output = {}
pinfo_output.PROMPT = "[pinfo] "
pinfo_output.default_settings = {chat_tab_number = 1}
pinfo_output.message_buffers = {}

function pinfo_output.initialize()
    pinfo_output.initialize_message_buffers()
    pinfo_output.settings = ZO_SavedVars:New("pinfo_saved_variables",
                                             1,
                                             nil,
                                             pinfo_output.default_settings)
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   pinfo_output.on_player_activated)
end

function pinfo_output.initialize_message_buffers()
    pinfo_output.message_buffers.xp_messages = {}
    pinfo_output.message_buffers.ap_messages = {}
end

function pinfo_output.set_n_th_chat_tab_as_output(chat_tab_number)
    local chat_tab = string.format("ZO_ChatWindowTemplate%d", chat_tab_number)
    local chat_tab_name = string.format("ZO_ChatWindowTabTemplate%dText", chat_tab_number)

    if _G[chat_tab] == nil or _G[chat_tab_name] == nil then
        pinfo_output.chat_tab = _G["ZO_ChatWindowTemplate1"].buffer
        pinfo_output.chat_tab_name = _G["ZO_ChatWindowTabTemplate1Text"]:GetText()
    else
        pinfo_output.chat_tab = _G[chat_tab].buffer
        pinfo_output.chat_tab_name = _G[chat_tab_name]:GetText()
    end
    if chat_tab_number ~= pinfo_output.settings.chat_tab_number then
        pinfo_output.settings.chat_tab_number = chat_tab_number
    end
    pinfo_output.system_print("Output chat tab is: " .. pinfo_output.chat_tab_name)
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
                pinfo_char.get_character_name(CACHE),
                pinfo_char.get_character_ava_rank_name(CACHE),
                pinfo_char.get_character_class(CACHE),
                pinfo_char.get_character_ava_rank_points_percent(CACHE),
                pinfo_char.get_character_ava_points_gain(CACHE))
end

local function store_xp_message_before_player_activated()
    table.insert(pinfo_output.message_buffers.xp_messages, xp_message_to_print())
end

local function print_xp_message()
    pinfo_output.normal_print(xp_message_to_print())
end

local function store_ap_message_before_player_activated()
    table.insert(pinfo_output.message_buffers.ap_messages, ap_message_to_print())
end

local function print_ap_message()
    pinfo_output.normal_print(ap_message_to_print())
end

pinfo_output.xp_to_chat_tab = store_xp_message_before_player_activated
pinfo_output.ap_to_chat_tab = store_ap_message_before_player_activated

local function print_message_buffers()
    for _, buffer in pairs(pinfo_output.message_buffers) do
        for _, message in ipairs(buffer) do
            pinfo_output.normal_print(message)
        end
    end
end

function pinfo_output.on_player_activated(event)
    local chat_tab_number = pinfo_output.default_settings.chat_tab_number

    if pinfo_output.settings.chat_tab_number ~= nil then
        chat_tab_number = pinfo_output.settings.chat_tab_number
    end

    pinfo_output.set_n_th_chat_tab_as_output(chat_tab_number)

    pinfo_output.xp_to_chat_tab = print_xp_message
    pinfo_output.ap_to_chat_tab = print_ap_message

    print_message_buffers()
end

function pinfo_output.item_to_chat_tab(item_name, quantity)
    formatted_item = zo_strformat("<<t:1>>", item_name)
    pinfo_output.normal_print(string.format("+%s+ receives +%d+ +%s+",
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
    pinfo_output.normal_print(message)
end

function pinfo_output.normal_print(message)
    pinfo_output.chat_tab:AddMessage(message)
end

function pinfo_output.system_print(message)
    d(pinfo_output.PROMPT .. message)
end

return pinfo_output
