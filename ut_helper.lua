local ut_helper = {}

ut_helper.ORIGINAL_FUNCTIONS = {}
ut_helper.REPLACED_FUNCTIONS = {}

function ut_helper.update_function(scope, function_name, function_object)
    ut_helper.ORIGINAL_FUNCTIONS[function_name] = scope[function_name]
    scope[function_name] = function_object
end

function ut_helper.restore_function(scope, function_name)
    scope[function_name] = ut_helper.ORIGINAL_FUNCTIONS[function_name]
end

function ut_helper.engage_spy_on_function(scope, function_name)
    spy.on(scope, function_name)
end

function ut_helper.replace_function(scope, function_name, ...)
    local return_value = {...}
    local function_object = function(arg) return unpack(return_value) end
    ut_helper.update_function(scope, function_name, function_object)
    ut_helper.engage_spy_on_function(scope, function_name)
    ut_helper.REPLACED_FUNCTIONS[#ut_helper.REPLACED_FUNCTIONS+1] = {
        scope = scope,
        function_name = function_name
    }
end

function ut_helper.recall_spy_from_function(scope, function_name)
    scope[function_name]:revert()
end

function ut_helper.restore_fake_functions()
    for index, value in ipairs(ut_helper.REPLACED_FUNCTIONS) do
        ut_helper.recall_spy_from_function(value.scope, value.function_name)
        ut_helper.restore_function(value.scope, value.function_name)
    end
    ut_helper.REPLACED_FUNCTIONS = {}
end

return ut_helper
