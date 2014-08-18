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

pinfo = {}
pinfo.ADDON_NAME = "pinfo"
pinfo.CACHE = {}

function pinfo.on_addon_loaded(event, addon_name)
    pinfo_init.initialize(addon_name)
end

SLASH_COMMANDS[string.format("/%s", pinfo.ADDON_NAME)] = function(command)
    if command == "" then
        d(string.format("%s: running", pinfo.ADDON_NAME))
    elseif string.lower(command) == "help" then
        d(string.format("%s: use /%s <number> to set output chat tab", pinfo.ADDON_NAME, pinfo.ADDON_NAME))
    elseif tonumber(command) ~= nil then
        pinfo_output.set_n_th_chat_tab_as_output(tonumber(command))
    else
        d(string.format("%s: invalid command", pinfo.ADDON_NAME))
    end
end


EVENT_MANAGER:RegisterForEvent(pinfo.ADDON_NAME,
                               EVENT_ADD_ON_LOADED,
                               pinfo.on_addon_loaded)

return pinfo
