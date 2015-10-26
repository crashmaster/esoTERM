-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_crafting_library")

local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_register_for_event_was_called_with_expected_parameters = tl.and_register_for_event_was_called_with_expected_parameters
local and_register_module_was_called = tl.and_register_module_was_called
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local verify_that_esoTERM_crafting_module_has_the_expected_name = tl.verify_that_esoTERM_crafting_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
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
            and_register_for_event_was_called_with_expected_parameters()
            and_module_is_active_was_saved()
    end)
end)
