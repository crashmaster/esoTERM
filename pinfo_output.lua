local CACHE = pinfo.CACHE

pinfo_output = {}

function pinfo_output.xp_to_debug()
    d(string.format("+%s+ +%d+ +%s+ +%.2f%%+ (+%d XP)",
                    pinfo_char.get_character_name(CACHE),
                    pinfo_char.get_character_level(CACHE),
                    pinfo_char.get_character_class(CACHE),
                    pinfo_char.get_character_level_xp_percent(CACHE),
                    pinfo_char.get_character_xp_gain(CACHE)))
end

function pinfo_output.ap_to_debug()
    d(string.format("+%s+ +%s+ +%s+ +%.2f%%+ (+%d AP)",
                    pinfo_char.get_character_ava_rank_name(CACHE),
                    pinfo_char.get_character_name(CACHE),
                    pinfo_char.get_character_class(CACHE),
                    pinfo_char.get_character_ava_rank_points_percent(CACHE),
                    pinfo_char.get_character_ava_points_gain(CACHE)))
end

return pinfo_output
