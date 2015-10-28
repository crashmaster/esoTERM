-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_crafting_library")

tl.setup_test_functions(
    {
        activate = {
            module = esoTERM_crafting,
            function_types = {
                {
                    name_template = FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED,
                },
                {
                    name_template = FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED,
                },
                {
                    name_template = FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED,
                },
                {
                    name_template = FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED,
                },
            },
        },
        deactivate = {
            module = esoTERM_crafting,
            function_types = {
                {
                    name_template = FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED,
                },
            },
        },
        unregister_from_all_events = {
            module = esoTERM_common,
            function_types = {
                {
                    name_template = FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED,
                },
                {
                    name_template = FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH,
                    argument = esoTERM_crafting,
                },
            },
        },
    }
)

local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_module_is_inactive_was_saved = tl.and_module_is_inactive_was_saved
local and_register_for_event_was_called_with = tl.and_register_for_event_was_called_with
local and_register_module_was_called = tl.and_register_module_was_called
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
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_crafting_module_has_the_expected_name = tl.verify_that_esoTERM_crafting_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called
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
            and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called()
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

        and_module_became_active()
            and_register_for_event_was_called_with(tl.EXPECTED_REGISTER_FOR_EVENT_CALLS)
            and_module_is_active_was_saved()
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
            and_module_is_inactive_was_saved()
    end)
end)

