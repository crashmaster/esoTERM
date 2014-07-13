local CACHE = pinfo.CHARACTER_INFO

pinfo_output = {}

function pinfo_output.character_info_to_debug()
    d(string.format("+%s+ +%s+ +%d+ +%s+ +%.2f%%+ (+%d xp)",
                    pinfo_char.get_character_ava_rank_name(CACHE),
                    pinfo_char.get_character_name(CACHE),
                    pinfo_char.get_character_level(CACHE),
                    pinfo_char.get_character_class(CACHE),
                    pinfo_char.get_character_level_xp_percent(CACHE),
                    pinfo_char.get_character_xp_gain(CACHE)))
end

return pinfo_output
