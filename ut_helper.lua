local original_functions = {}
local replaced_functions = {}

local function _update_function(scope, function_name, new_function)
    original_functions[function_name] = scope[function_name]
    scope[function_name] = new_function
end

local function _engage_spy_on_function(scope, function_name)
    spy.on(scope, function_name)
end

local function _get_function_id(scope, function_name)
    return string.format("%s,%s", tostring(scope), function_name)
end

local function _register_replaced_function(scope, function_name)
    local key = _get_function_id(scope, function_name)
    replaced_functions[key] = { scope = scope, function_name = function_name }
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
    scope[function_name] = original_functions[function_name]
end

local function _unregister_replaced_function(scope, function_name)
    local key = _get_function_id(scope, function_name)
    replaced_functions[key] = nil
end

local function restore_stubbed_function(scope, function_name)
    _recall_spy_from_function(scope, function_name)
    _restore_function(scope, function_name)
    _unregister_replaced_function(scope, function_name)
end

local function restore_stubbed_functions()
    for index, value in pairs(replaced_functions) do
        restore_stubbed_function(value.scope, value.function_name)
    end
end

local ut_helper = {
    stub_function = stub_function,
    restore_stubbed_function = restore_stubbed_function,
    restore_stubbed_functions = restore_stubbed_functions
}

return ut_helper
