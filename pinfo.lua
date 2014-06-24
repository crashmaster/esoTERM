--
-- Planned player info layout:
--
-- [#1] [#2], [#3] [#4], [#5] [#6] [#7], [#8] [#9] [#10]
--
-- Legend:
--  #1  - Alliance vs. Alliance (AvA.) Rank Name (e.g.: Sergeant)
--  #2  - Character Name (e.g.: Hank)
--  #3  - Level Information (e.g.: Veteran 3)
--  #4  - Class (e.g.: Dragon Knight)
--  #5  - Actual Level Experience / Maximal Level Experience (e.g.: 123/500)
--  #6  - Actual Level Experience per cent (e.g.: 24,6%)
--  #7  - Last Experience Gain (e.g.: +72)
--  #8  - Actual AvA. Experience / Maximal AvA Experience (e.g.: 321/800)
--  #9  - Last AvA. Experience Gain (e.g.: +8)
--  #10 - Actual AvA. Experience per cent (e.g.: 44,6%)
--
-- Not applicable information is skipped.

local pinfo = {}
local character_info = {}

pinfo.addon_name = "pinfo"


function pinfo.on_experience_update(event, unit_tag, current_xp, max_xp, reason)
    if ((unit_tag ~= "player") or (reason < 0) or (max_xp == 0)) then
        return
    end
    d(string.format("+%s+ +%s+ +%d+ +%s+ +%.2f+",
                    pinfo_char.get_character_ava_rank_name(character_info),
                    pinfo_char.get_character_name(character_info),
                    pinfo_char.get_character_level(character_info),
                    pinfo_char.get_character_class(character_info),
                    current_xp * 100 / max_xp))
end


function pinfo.on_addon_loaded(event, addon_name)
    if addon_name == pinfo.addon_name then
        EVENT_MANAGER:RegisterForEvent(pinfo.addon_name,
                                       EVENT_VETERAN_POINTS_UPDATE,
                                       pinfo.on_experience_update)

        EVENT_MANAGER:RegisterForEvent(pinfo.addon_name,
                                       EVENT_EXPERIENCE_UPDATE,
                                       pinfo.on_experience_update)
    end
end


EVENT_MANAGER:RegisterForEvent(pinfo.addon_name,
                               EVENT_ADD_ON_LOADED,
                               pinfo.on_addon_loaded)
