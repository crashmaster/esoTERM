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

pinfo.ADDON_NAME = "pinfo"
pinfo.CHARACTER_INFO = {}

function pinfo.on_addon_loaded(event, addon_name)
    pinfo_init.initialize(addon_name, pinfo)
end

EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                               EVENT_ADD_ON_LOADED,
                               pinfo.on_addon_loaded)
