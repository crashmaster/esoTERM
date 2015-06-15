local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_champ_library")

describe("Test the esoTERM_champ module.", function()
    it("Module is called: esoTERM-champion.",
    function()
        tl.verify_that_the_module_name_is_the_expected_one()
    end)
end)

describe("Test the esoTERM_champ module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Do not initialize if character is not eligible for champion system.",
    function()
        tl.given_that_character_is_not_eligible_for_champion_xp()
            tl.and_zo_savedvars_new_is_stubbed()
            tl.and_that_register_module_is_stubbed()

        tl.when_initialize_is_called()

        tl.then_GetPlayerChampionPointsEarned_was_called()
            tl.and_GetChampionXPInRank_was_called()
            tl.and_zo_savedvars_new_was_not_called()
            tl.and_register_module_was_not_called()
    end)

    it("Initialize, but do not activate because configured as inactive.",
    function()
        tl.given_that_module_configured_as_inactive()
            tl.and_that_character_is_eligible_for_champion_xp()
            tl.and_that_esoTERM_champ_activate_is_stubbed()
            tl.and_that_register_module_is_stubbed()

        tl.when_initialize_is_called()

        tl.then_esoTERM_champ_activate_was_not_called()
            tl.and_zo_savedvars_new_was_called()
            tl.and_register_module_was_called()
    end)

    it("Initialize, and activate because configured as active.",
    function()
        tl.given_that_module_configured_as_active()
            tl.and_that_character_is_eligible_for_champion_xp()
            tl.and_that_esoTERM_champ_activate_is_stubbed()
            tl.and_that_register_module_is_stubbed()

        tl.when_initialize_is_called()

        tl.then_esoTERM_champ_activate_was_called()
            tl.and_zo_savedvars_new_was_called()
            tl.and_register_module_was_called()
    end)
end)

describe("Test esoTERM_champ module activate.", function()
    after_each(function()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on initialization for champion characters.",
    function()
        tl.given_that_module_is_inactive()
            tl.and_that_cache_is_empty()
            tl.and_that_expected_register_for_event_calls_are_set_up()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_are_stubbed()

        tl.when_activate_is_called()

        tl.and_module_became_active()
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_with_expected_parameters()
            tl.and_getter_function_stubs_were_called()
            tl.and_cached_values_became_initialized()
            tl.and_module_is_active_was_saved()
    end)
end)

describe("Test esoTERM_champ module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events and set activeness to false.",
    function()
        tl.given_that_module_is_active()
            tl.and_that_unregister_from_all_events_is_stubbed()

        tl.when_deactivate_for_the_module_is_called()

        tl.then_module_became_inactive()
            tl.and_unregister_from_all_events_was_called()
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
