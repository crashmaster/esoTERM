local CHARACTER_INFO = nil

pinfo_output = {}

function pinfo_output.initialize(pinfo)
    CHARACTER_INFO = pinfo.CHARACTER_INFO
end

function pinfo_output.character_info_to_debug()
    d(string.format("+%s+ +%s+ +%d+ +%s+ +%.2f%%+",
                    pinfo_char.get_character_ava_rank_name(CHARACTER_INFO),
                    pinfo_char.get_character_name(CHARACTER_INFO),
                    pinfo_char.get_character_level(CHARACTER_INFO),
                    pinfo_char.get_character_class(CHARACTER_INFO),
                    pinfo_char.get_character_level_xp_percent(CHARACTER_INFO)))
end

return pinfo_output
