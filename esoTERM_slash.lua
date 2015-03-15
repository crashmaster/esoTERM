esoTERM_slash = {}

esoTERM_slash.command_handlers = {}

local function get_about()
    return "About\n" ..
           "Name: " .. esoTERM.ADDON_NAME .. "\n" ..
           "Author: " .. esoTERM.ADDON_AUTHOR .. " @ EU"
end

local function handle_empty_command()
    return get_about()
end

local function get_help()
    return "Available command for esoTERM:\n" ..
           " - show about: /esoterm\n" ..
           " - show help: /esoterm help\n" ..
           " - show status: /esoterm status"
end

local function handle_help_command()
    return get_help()
end

local function get_module_status(module)
    return string.format("\n%s is %s",
                         module.module_name,
                         module.is_active and "ACTIVE" or "INACTIVE")
end

local function get_module_statuses(module_register)
    local array = {}
    for i, module in ipairs(module_register) do
        table.insert(array, get_module_status(module))
    end
    return table.concat(array, "")
end

local function handle_status_command()
    local register = esoTERM.module_register
    if #register == 0 then
        status = "\nNo registered modules"
    elseif #register == 1 then
        status = get_module_status(register[1])
    else
        status = get_module_statuses(register)
    end
    return "Status of modules" .. status
end

function esoTERM_slash.slash_command_handler(command_and_arg)
    local output
    local command_handlers = esoTERM_slash.command_handlers
    local command = string.lower(esoTERM_common.split(command_and_arg)[1] or "")
    local arg = string.lower(esoTERM_common.split(command_and_arg)[2] or "")

    if command_handlers[command] == nil then
        output = "Invalid slash-command: " .. command_and_arg
    else
        output = command_handlers[command](arg)
    end

    esoTERM_output.sysout(output)
end

function esoTERM_slash.initialize()
    SLASH_COMMANDS["/" .. string.lower(esoTERM.ADDON_NAME)] = esoTERM_slash.slash_command_handler

    local command_handlers = esoTERM_slash.command_handlers
    command_handlers[""] = handle_empty_command
    command_handlers["help"] = handle_help_command
    command_handlers["status"] = handle_status_command
end

return esoTERM_slash
