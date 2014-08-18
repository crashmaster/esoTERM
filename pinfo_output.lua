local CACHE = pinfo.CACHE

pinfo_output = {}


function pinfo_output.initialize()
    EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                                   EVENT_PLAYER_ACTIVATED,
                                   pinfo_output.on_player_activated)
end

function pinfo_output.set_n_th_chat_tab_as_output(tab_number)
    local chat_tab = string.format("ZO_ChatWindowTemplate%d", tab_number)
    local chat_tab_name = string.format("ZO_ChatWindowTabTemplate%dText", tab_number)

    if _G[chat_tab] ~= nil then
        pinfo_output.chat_tab = _G[chat_tab]["buffer"]
        pinfo_output.chat_tab_name = _G[chat_tab_name]:GetText()
        d(string.format("pinfo: output chat tab is: %s", pinfo_output.chat_tab_name))
    else
        d(string.format("pinfo: invalid chat tab number: %s", tostring(tab_number)))
    end
end

function pinfo_output.on_player_activated(event)
    pinfo_output.chat_tab = ZO_ChatWindowTemplate1["buffer"]
    pinfo_output.chat_tab_name = ZO_ChatWindowTabTemplate1Text:GetText()
    d("pinfo: hello")
    d(string.format("pinfo: output chat tab is: %s", pinfo_output.chat_tab_name))
end

function pinfo_output.xp_to_debug()
    pinfo_output.chat_tab:AddMessage(
        string.format("+%s+ +%d+ +%s+ +%.2f%%+ (+%d XP)",
            pinfo_char.get_character_name(CACHE),
            pinfo_char.get_character_level(CACHE),
            pinfo_char.get_character_class(CACHE),
            pinfo_char.get_character_level_xp_percent(CACHE),
            pinfo_char.get_character_xp_gain(CACHE)))
end

function pinfo_output.ap_to_debug()
    pinfo_output.chat_tab:AddMessage(
        string.format("+%s+ +%s+ +%s+ +%.2f%%+ (+%d AP)",
            pinfo_char.get_character_ava_rank_name(CACHE),
            pinfo_char.get_character_name(CACHE),
            pinfo_char.get_character_class(CACHE),
            pinfo_char.get_character_ava_rank_points_percent(CACHE),
            pinfo_char.get_character_ava_points_gain(CACHE)))
end

return pinfo_output
