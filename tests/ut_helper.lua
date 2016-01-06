local spy = require("luassert.spy")

local ORIGINAL_FUNCTIONS = {}
local REPLACED_FUNCTIONS = {}

local function _get_function_id(scope, function_name)
    return string.format("%s,%s", tostring(scope), function_name)
end

local function _update_function(scope, function_name, new_function)
    local key = _get_function_id(scope, function_name)
    ORIGINAL_FUNCTIONS[key] = scope[function_name]
    scope[function_name] = new_function
end

local function _engage_spy_on_function(scope, function_name)
    spy.on(scope, function_name)
end

local function _register_replaced_function(scope, function_name)
    local key = _get_function_id(scope, function_name)
    REPLACED_FUNCTIONS[key] = { scope = scope, function_name = function_name }
end

local function stub_function(scope, function_name, ...)
    local return_value = {...}
    local new_function = function(arg) return unpack(return_value) end
    _update_function(scope, function_name, new_function)
    _engage_spy_on_function(scope, function_name)
    _register_replaced_function(scope, function_name)
end

local function _recall_spy_from_function(scope, function_name)
    scope[function_name]:revert()
end

local function _restore_function(scope, function_name)
    local key = _get_function_id(scope, function_name)
    scope[function_name] = ORIGINAL_FUNCTIONS[key]
end

local function _unregister_replaced_function(scope, function_name)
    local key = _get_function_id(scope, function_name)
    REPLACED_FUNCTIONS[key] = nil
end

local function restore_stubbed_function(scope, function_name)
    _recall_spy_from_function(scope, function_name)
    _restore_function(scope, function_name)
    _unregister_replaced_function(scope, function_name)
end

local function restore_stubbed_functions()
    for index, value in pairs(REPLACED_FUNCTIONS) do
        restore_stubbed_function(value.scope, value.function_name)
    end
end

local function table_size(table)
    local size = 0
    for _ in pairs(table) do size = size + 1 end
    return size
end

local function clear_table(table)
    for key in pairs(table) do table[key] = nil end
end

local ut_helper = {
    stub_function = stub_function,
    restore_stubbed_function = restore_stubbed_function,
    restore_stubbed_functions = restore_stubbed_functions,
    table_size = table_size,
    clear_table = clear_table
}

return ut_helper
