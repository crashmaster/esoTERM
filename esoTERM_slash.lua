esoTERM_slash = {}

function esoTERM_slash.slash_command_handler(command)
    if command == "" then
        esoTERM_output.sysout("Running")
    elseif string.lower(command) == "help" then
        esoTERM_output.sysout("Use /" .. esoTERM.ADDON_NAME .. " <number> to set output chat tab")
    elseif tonumber(command) ~= nil then
        esoTERM_output.set_n_th_chat_tab_as_output(tonumber(command))
    else
        esoTERM_output.sysout("Invalid command")
    end
end

function esoTERM_slash.initialize()
    SLASH_COMMANDS["/" .. esoTERM.ADDON_NAME] = esoTERM_slash.slash_command_handler
end

return esoTERM_slash
