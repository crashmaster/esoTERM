-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_champ_library")

local and_GetChampionXPInRank_was_called = tl.and_GetChampionXPInRank_was_called
local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_module_is_inactive_was_saved = tl.and_module_is_inactive_was_saved
local and_register_for_event_was_called_with_expected_parameters = tl.and_register_for_event_was_called_with_expected_parameters
local and_register_module_was_called = tl.and_register_module_was_called
local and_register_module_was_not_called = tl.and_register_module_was_not_called
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_character_is_eligible_for_champion_xp = tl.and_that_character_is_eligible_for_champion_xp
local and_that_esoTERM_champ_activate_is_stubbed = tl.and_that_esoTERM_champ_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_getter_functions_are_stubbed = tl.and_that_getter_functions_are_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called = tl.and_unregister_from_all_events_was_called
local and_ZO_SavedVars_new_is_stubbed = tl.and_ZO_SavedVars_new_is_stubbed
local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local and_ZO_SavedVars_new_was_not_called = tl.and_ZO_SavedVars_new_was_not_called
local given_that_character_is_not_eligible_for_champion_xp = tl.given_that_character_is_not_eligible_for_champion_xp
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_GetPlayerChampionPointsEarned_was_called = tl.then_GetPlayerChampionPointsEarned_was_called
local then_esoTERM_champ_activate_was_called = tl.then_esoTERM_champ_activate_was_called
local then_esoTERM_champ_activate_was_not_called = tl.then_esoTERM_champ_activate_was_not_called
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_champ_module_has_the_expected_name = tl.verify_that_esoTERM_champ_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called
-- }}}

describe("Test the esoTERM_champ module.", function()
    it("Module is called: champion.",
    function()
        verify_that_esoTERM_champ_module_has_the_expected_name()
    end)
end)

describe("Test the esoTERM_champ module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Do not initialize if character is not eligible for champion system.",
    function()
        given_that_character_is_not_eligible_for_champion_xp()
            and_ZO_SavedVars_new_is_stubbed()
            and_that_register_module_is_stubbed()

        when_initialize_is_called()

        then_GetPlayerChampionPointsEarned_was_called()
            and_GetChampionXPInRank_was_called()
            and_ZO_SavedVars_new_was_not_called()
            and_register_module_was_not_called()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_configured_as_inactive()
            and_that_character_is_eligible_for_champion_xp()
            and_that_esoTERM_champ_activate_is_stubbed()
            and_that_register_module_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_champ_activate_was_not_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_character_is_eligible_for_champion_xp()
            and_that_esoTERM_champ_activate_is_stubbed()
            and_that_register_module_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_champ_activate_was_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called()
    end)
end)

describe("Test esoTERM_champ module activate.", function()
    after_each(function()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)
    -- TODO: clear chache after tests?

    it("Update cache and subscribe for events for champion characters on activate.",
    function()
        given_that_module_is_inactive()
            and_that_cache_is_empty()
            and_that_expected_register_for_event_calls_are_set_up()
            and_that_register_for_event_is_stubbed()
            and_that_getter_functions_are_stubbed()

        when_activate_is_called()

        and_module_became_active()
            and_cache_is_no_longer_empty()
            and_register_for_event_was_called_with_expected_parameters()
            and_getter_function_stubs_were_called()
            and_cached_values_became_initialized()
            and_module_is_active_was_saved()
    end)
end)

describe("Test esoTERM_champ module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive()
            and_unregister_from_all_events_was_called()
            and_module_is_inactive_was_saved()
    end)
end)

describe("Test on experience update handler.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Character gained champion xp, not enough to level up.",
    function()
        tl.given_that_esoTERM_output_stdout_is_stubbed()
            tl.and_that_GetPlayerChampionXP_returns(500)
            tl.and_that_champion_xp_before_was(400)
            tl.and_that_champion_xp_max_is(2000)

        tl.when_on_experience_update_is_called()

        tl.then_esoTERM_output_stdout_was_called_with(
            "Gained " .. 100 .. " champion XP (25.00%)"
        )
    end)

    it("Character gained 0 champion xp, no output.",
    function()
        tl.given_that_esoTERM_output_stdout_is_stubbed()
            tl.and_that_GetPlayerChampionXP_returns(400)
            tl.and_that_champion_xp_before_was(400)
            tl.and_that_champion_xp_max_is(2000)

        tl.when_on_experience_update_is_called()

        tl.then_esoTERM_output_stdout_was_not_called()
    end)

    it("Character gained champion xp, almost enough to level up.",
    function()
        tl.given_that_esoTERM_output_stdout_is_stubbed()
            tl.and_that_GetPlayerChampionXP_returns(2000)
            tl.and_that_champion_xp_before_was(400)
            tl.and_that_champion_xp_max_is(2000)

        tl.when_on_experience_update_is_called()

        tl.then_esoTERM_output_stdout_was_called_with(
            "Gained " .. 1600 .. " champion XP (100.00%)"
        )
    end)

    it("Character gained champion xp, enough to level up.",
    function()
        tl.given_that_esoTERM_output_stdout_is_stubbed()
            tl.and_that_GetPlayerChampionXP_returns(500)
            tl.and_that_GetChampionXPInRank_returns(5000)
            tl.and_that_champion_xp_before_was(1900)
            tl.and_that_champion_xp_max_before_was(2000)

        tl.when_on_experience_update_is_called()

        tl.then_esoTERM_output_stdout_was_called_with2(
            "Gained " .. 100 .. " champion XP (100.00%)",
            "Gained " .. 500 .. " champion XP (10.00%)"
        )
            tl.and_champion_xp_max_became(5000)
    end)
end)
