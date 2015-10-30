-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_crafting_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_crafting, module_name_in_settings = "crafting" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_INACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_crafting, module_name_in_settings = "crafting" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "register_for_event", },
            { module = esoTERM_common, function_name = "register_module", },
            { module = esoTERM_common, function_name = "unregister_from_all_events", },
            { module = esoTERM_crafting, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = esoTERM_common, function_name = "register_module", called_with = {esoTERM.module_register, esoTERM_crafting, }, },
            { module = esoTERM_common, function_name = "unregister_from_all_events", called_with = {esoTERM_crafting, }, },
        },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = {
            { module = esoTERM_crafting, },
        },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = {
            { module = esoTERM_crafting, },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = {
            { module = esoTERM_crafting, },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_INACTIVE] = {
            { module = esoTERM_crafting, },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED] = {
            { module = esoTERM_crafting, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = {
            { module = esoTERM_crafting, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = esoTERM_crafting, function_name = "activate", },
            { module = esoTERM_crafting, function_name = "deactivate", },
            { module = esoTERM_crafting, function_name = "initialize", },
        },
    }
)

local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_register_for_event_was_called_with = tl.and_register_for_event_was_called_with
local and_register_module_was_called_with = tl.and_register_module_was_called_with
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local then_module_became_active = tl.then_module_became_active
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_crafting_module_has_the_expected_name = tl.verify_that_esoTERM_crafting_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called

local EXPECTED_REGISTER_FOR_EVENT_CALLS = tl.EXPECTED_REGISTER_FOR_EVENT_CALLS
-- }}}

describe("Test the esoTERM_crafting module.", function()
    it("Module is called: crafting.",
    function()
        verify_that_esoTERM_crafting_module_has_the_expected_name()
    end)
end)

describe("Test the esoTERM_crafting module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_configured_as_inactive()
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_not_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called_with(esoTERM_crafting)
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called_with(esoTERM_crafting)
    end)
end)

describe("Test esoTERM_crafting module activate.", function()
    after_each(function()
        expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on activate.",
    function()
        given_that_module_is_inactive()
            and_that_expected_register_for_event_calls_are_set_up()
            and_that_register_for_event_is_stubbed()

        when_activate_is_called()

        then_module_became_active()
            and_register_for_event_was_called_with(EXPECTED_REGISTER_FOR_EVENT_CALLS)
            and_active_state_of_the_module_was_saved()
    end)
end)

describe("Test esoTERM_crafting module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive()
            and_unregister_from_all_events_was_called_with(esoTERM_crafting)
            and_inactive_state_of_the_module_was_saved()
    end)
end)
