esoTERM_slash = {}

local function get_module_status(module)
    return string.format("%s  <%s>",
                         module.module_name,
                         module.is_active and "ACTIVE" or "INACTIVE")
end

local function get_module_statuses(module_register)
    local array = {}
    for i, module in ipairs(module_register) do
        table.insert(array, get_module_status(module))
    end
    return array
end

function esoTERM_slash.slash_command_handler(command)
    local output
    local lower_case_command = string.lower(command)
    if lower_case_command == "" then
        output = esoTERM.ADDON_NAME .. " active"
    elseif lower_case_command == "help" then
        output = "No help here"
    elseif lower_case_command == "status" then
        local register = esoTERM.module_register
        if #register == 0 then
            output = "No registered modules"
        elseif #register == 1 then
            output = get_module_status(register[1])
        else
            output = table.concat(get_module_statuses(register), "\n")
        end
    else
        output = "Invalid command: " .. command
    end
    esoTERM_output.sysout(output)
end

function esoTERM_slash.initialize()
    SLASH_COMMANDS["/" .. string.lower(esoTERM.ADDON_NAME)] = esoTERM_slash.slash_command_handler
end

return esoTERM_slash
