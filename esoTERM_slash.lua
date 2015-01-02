esoTERM_slash = {}

function esoTERM_slash.slash_command_handler(command)
    if command == "" then
        esoTERM_output.sysout("Running")
    elseif string.lower(command) == "help" then
        esoTERM_output.sysout("No help here")
    elseif string.lower(command) == "status" then
        for i, module in ipairs(esoTERM.module_register) do
            local m = string.format("%s  <%s>",
                                    module.module_name,
                                    module.is_active and "ACTIVE" or "INACTIVE")
            esoTERM_output.sysout(m)
        end
    else
        esoTERM_output.sysout("Invalid command: " .. command)
    end
end

function esoTERM_slash.initialize()
    SLASH_COMMANDS["/" .. string.lower(esoTERM.ADDON_NAME)] = esoTERM_slash.slash_command_handler
end

return esoTERM_slash
