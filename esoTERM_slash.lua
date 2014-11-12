esoTERM_slash = {}

function esoTERM_slash.slash_command_handler(command)
    if command == "" then
        esoTERM_output.sysout("Running")
    elseif string.lower(command) == "help" then
        esoTERM_output.sysout("Use /" .. esoTERM.ADDON_NAME .. " <number> to set output chat tab")
    else
        esoTERM_output.sysout("Invalid command")
    end
end

function esoTERM_slash.initialize()
    SLASH_COMMANDS["/" .. string.lower(esoTERM.ADDON_NAME)] = esoTERM_slash.slash_command_handler
end

return esoTERM_slash
