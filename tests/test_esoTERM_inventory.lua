-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_inventory_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_inventory, module_name_in_settings = "inventory" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_INACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_inventory, module_name_in_settings = "inventory" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "register_for_event", },
            { module = esoTERM_common, function_name = "register_module", },
            { module = esoTERM_common, function_name = "unregister_from_all_events", },
            { module = esoTERM_inventory, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_REGISTER_FOR_EVENT_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = esoTERM_common, function_name = "register_module", },
            { module = esoTERM_common, function_name = "unregister_from_all_events", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_ZO_SAVEDVARS_NEW_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_ACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_INACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED] = {
            { module = esoTERM_inventory, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = {
            { module = esoTERM_inventory, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME] = { { }, },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = esoTERM_inventory, function_name = "activate", },
            { module = esoTERM_inventory, function_name = "deactivate", },
            { module = esoTERM_inventory, function_name = "initialize", },
        },
    }
)

local and_ZO_SavedVars_new_was_called_with = tl.and_ZO_SavedVars_new_was_called_with
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_register_for_event_was_called_with = tl.and_register_for_event_was_called_with
local and_register_module_was_called_with = tl.and_register_module_was_called_with
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local get_expected_register_for_event_call_parameters = tl.get_expected_register_for_event_call_parameters
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local given_that_module_is_set_active_in_the_config_file = tl.given_that_module_is_set_active_in_the_config_file
local given_that_module_is_set_inactive_in_the_config_file = tl.given_that_module_is_set_inactive_in_the_config_file
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local then_module_became_active = tl.then_module_became_active
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_module_has_the_expected_name = tl.verify_that_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called
-- }}}

describe("Test the esoTERM_inventory module.", function()
    it("Module is called: inventory.",
    function()
        verify_that_module_has_the_expected_name(esoTERM_inventory, "inventory")
    end)
end)

describe("Test the esoTERM_inventory module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_is_set_inactive_in_the_config_file("inventory")
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_not_called()
            and_ZO_SavedVars_new_was_called_with("inventory")
            and_register_module_was_called_with(esoTERM.module_register, esoTERM_inventory)
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_is_set_active_in_the_config_file("inventory")
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_called()
            and_ZO_SavedVars_new_was_called_with("inventory")
            and_register_module_was_called_with(esoTERM.module_register, esoTERM_inventory)
    end)
end)

describe("Test esoTERM_inventory module activate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on activate.",
    function()
        given_that_module_is_inactive(esoTERM_inventory)
            and_that_register_for_event_is_stubbed()

        when_activate_is_called()

        then_module_became_active(esoTERM_inventory)
            and_register_for_event_was_called_with(
                get_expected_register_for_event_call_parameters()
            )
            and_active_state_of_the_module_was_saved()
    end)
end)

describe("Test esoTERM_inventory module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active(esoTERM_inventory)
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive(esoTERM_inventory)
            and_unregister_from_all_events_was_called_with(esoTERM_inventory)
            and_inactive_state_of_the_module_was_saved()
    end)
end)
