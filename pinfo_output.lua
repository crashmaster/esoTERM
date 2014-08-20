local CACHE = pinfo.CACHE

pinfo_output = {}
pinfo_output.PROMPT = "[pinfo] $ "
pinfo_output.default_settings = {chat_tab_number = 1}


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
    pinfo_output.system_message("output chat tab is: " .. pinfo_output.chat_tab_name)
end

function pinfo_output.on_player_activated(event)
    local chat_tab_number = pinfo_output.default_settings.chat_tab_number

    if pinfo_output.settings.chat_tab_number ~= nil then
        chat_tab_number = pinfo_output.settings.chat_tab_number
    end

    pinfo_output.set_n_th_chat_tab_as_output(chat_tab_number)
end

function pinfo_output.xp_to_chat_tab()
    pinfo_output.chat_tab:AddMessage(
        string.format("+%s+ +%d+ +%s+ +%.2f%%+ (+%d XP)",
            pinfo_char.get_character_name(CACHE),
            pinfo_char.get_character_level(CACHE),
            pinfo_char.get_character_class(CACHE),
            pinfo_char.get_character_level_xp_percent(CACHE),
            pinfo_char.get_character_xp_gain(CACHE)))
end

function pinfo_output.ap_to_chat_tab()
    pinfo_output.chat_tab:AddMessage(
        string.format("+%s+ +%s+ +%s+ +%.2f%%+ (+%d AP)",
            pinfo_char.get_character_ava_rank_name(CACHE),
            pinfo_char.get_character_name(CACHE),
            pinfo_char.get_character_class(CACHE),
            pinfo_char.get_character_ava_rank_points_percent(CACHE),
            pinfo_char.get_character_ava_points_gain(CACHE)))
end

function pinfo_output.system_message(message)
    d(pinfo_output.PROMPT .. message)
end

return pinfo_output
