pinfo_slash = {}

function slash_command_handler(command)
    if command == "" then
        pinfo_output.system_message("running")
    elseif string.lower(command) == "help" then
        pinfo_output.system_message("use /" .. pinfo.ADDON_NAME .. " <number> to set output chat tab")
    elseif tonumber(command) ~= nil then
        pinfo_output.set_n_th_chat_tab_as_output(tonumber(command))
    else
        pinfo_output.system_message("invalid command")
    end
end

function pinfo_slash.initialize()
    SLASH_COMMANDS["/" .. pinfo.ADDON_NAME] = pinfo_slash.slash_command_handler
end

return pinfo_slash
