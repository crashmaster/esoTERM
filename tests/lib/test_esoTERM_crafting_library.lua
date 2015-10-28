local test_library = require("tests/lib/test_library")
local esoTERM_crafting = require("esoTERM_crafting")

test_esoTERM_crafting_library = {}

local MODULE_NAME = "crafting"

-- Module Name {{{
function test_esoTERM_crafting_library.verify_that_esoTERM_crafting_module_has_the_expected_name()
    assert.is.equal(MODULE_NAME, esoTERM_crafting.module_name)
end
-- }}}

-- setup_test_functions {{{
function test_esoTERM_crafting_library.setup_test_functions(functions)
    for function_name, function_properties in pairs(functions) do
        local module = function_properties.module
        for _i, function_type in ipairs(function_properties.function_types) do
            if function_type == AND_THAT_X_IS_STUBBED then
                test_esoTERM_crafting_library["and_that_" .. function_name .. "_is_stubbed" ] = function ()
                    test_library.stub_function_with_no_return_value(module, function_name)
                end
            end
            if function_type == WHEN_X_IS_CALLED then
                test_esoTERM_crafting_library["when_" .. function_name .. "_is_called"] = function ()
                    module[function_name]()
                end
            end
            if function_type == THEN_X_WAS_CALLED then
                test_esoTERM_crafting_library["then_" .. function_name .. "_was_called" ] = function ()
                    test_library.stub_function_called_without_arguments(module[function_name])
                end
            end
            if function_type == THEN_X_WAS_NOT_CALLED then
                test_esoTERM_crafting_library["then_" .. function_name .. "_was_not_called" ] = function ()
                    test_library.stub_function_was_not_called(module[function_name])
                end
            end
        end
    end
end
-- }}}

-- initialize {{{
function test_esoTERM_crafting_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_crafting)
end
-- }}}

-- ZO_SavedVars {{{
function test_esoTERM_crafting_library.given_that_module_configured_as_inactive()
    test_library.configure_module_as_inactive(MODULE_NAME)
end

function test_esoTERM_crafting_library.given_that_module_configured_as_active()
    test_library.configure_module_as_active(MODULE_NAME)
end

function test_esoTERM_crafting_library.and_ZO_SavedVars_new_was_called()
    test_library.ZO_SavedVars_new_was_called_with_module(MODULE_NAME)
end
-- }}}

-- register_module {{{
function test_esoTERM_crafting_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_crafting_library.and_register_module_was_called()
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, esoTERM_crafting)
end
-- }}}

-- Module activeness {{{
function test_esoTERM_crafting_library.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_crafting)
end

function test_esoTERM_crafting_library.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_crafting)
end

function test_esoTERM_crafting_library.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_crafting)
end

function test_esoTERM_crafting_library.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_crafting)
end

function test_esoTERM_crafting_library.and_module_is_active_was_saved()
    assert.is.equal(esoTERM_crafting.settings[MODULE_NAME], true)
end

function test_esoTERM_crafting_library.and_module_is_inactive_was_saved()
    assert.is.equal(esoTERM_crafting.settings[MODULE_NAME], false)
end
-- }}}

-- register_for_event {{{
test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function test_esoTERM_crafting_library.expected_register_for_event_calls_are_cleared()
    test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}
end

function test_esoTERM_crafting_library.and_that_expected_register_for_event_calls_are_set_up()
    test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.craft_completed_update = {
        module = esoTERM_crafting,
        event = EVENT_CRAFT_COMPLETED,
        callback = esoTERM_crafting.on_craft_completed_update
    }
end

function test_esoTERM_crafting_library.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

function test_esoTERM_crafting_library.and_register_for_event_was_called_with()
    test_library.register_for_event_was_called_with_expected_parameters(
        test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS
    )
end
-- }}}

-- unregister_from_all_events {{{
function test_esoTERM_crafting_library.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function test_esoTERM_crafting_library.and_unregister_from_all_events_was_called_with(...)
    test_library.stub_function_called_with_arguments(esoTERM_common.unregister_from_all_events, esoTERM_crafting)
end
-- }}}

return test_esoTERM_crafting_library

-- vim:fdm=marker
