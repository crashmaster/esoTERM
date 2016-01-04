-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_pve_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_pve, module_name_in_settings = "pve" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_CACHED_VALUE_BECAME] = {
            {  module = esoTERM_pve },
        },
        [FUNCTION_NAME_TEMPLATES.AND_INACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_pve, module_name_in_settings = "pve" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "register_for_event", },
            { module = esoTERM_common, function_name = "register_module", },
            { module = esoTERM_common, function_name = "unregister_from_all_events", },
            { module = esoTERM_pve, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_RETURNS] = {
            { module = GLOBAL, function_name = "GetUnitLevel", },
            { module = GLOBAL, function_name = "GetUnitVeteranPoints", },
            { module = GLOBAL, function_name = "GetUnitVeteranPointsMax", },
            { module = GLOBAL, function_name = "GetUnitVeteranRank", },
            { module = GLOBAL, function_name = "GetUnitXP", },
            { module = GLOBAL, function_name = "GetUnitXPMax", },
            { module = GLOBAL, function_name = "IsUnitVeteran", },
            { module = esoTERM_pve, function_name = "get_level_xp", },
            { module = esoTERM_pve, function_name = "get_level_xp_max", },
            { module = esoTERM_pve, function_name = "is_veteran", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED] = {
            { module = esoTERM_pve, function_name = "is_veteran", },
            { module = esoTERM_pve, function_name = "get_level_xp", },
            { module = esoTERM_pve, function_name = "get_level_xp_max", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = GLOBAL, function_name = "GetUnitLevel", },
            { module = GLOBAL, function_name = "GetUnitVeteranPoints", },
            { module = GLOBAL, function_name = "GetUnitVeteranPointsMax", },
            { module = GLOBAL, function_name = "GetUnitVeteranRank", },
            { module = GLOBAL, function_name = "GetUnitXP", },
            { module = GLOBAL, function_name = "GetUnitXPMax", },
            { module = GLOBAL, function_name = "IsUnitVeteran", },
            { module = esoTERM_common, function_name = "register_module", },
            { module = esoTERM_common, function_name = "unregister_from_all_events", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_NOT_CALLED] = {
            { module = GLOBAL, function_name = "GetUnitLevel", },
            { module = GLOBAL, function_name = "GetUnitVeteranPoints", },
            { module = GLOBAL, function_name = "GetUnitVeteranPointsMax", },
            { module = GLOBAL, function_name = "GetUnitVeteranRank", },
            { module = GLOBAL, function_name = "GetUnitXP", },
            { module = GLOBAL, function_name = "GetUnitXPMax", },
            { module = GLOBAL, function_name = "IsUnitVeteran", },
            { module = esoTERM_pve, function_name = "get_level_xp", },
            { module = esoTERM_pve, function_name = "get_level_xp_max", },
            { module = esoTERM_pve, function_name = "is_veteran", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_ZO_SAVEDVARS_NEW_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_CACHED_VALUE_IS] = {
            {  module = esoTERM_pve },
        },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_ACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_INACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_X_IS_STUBBED] = {
            { module = esoTERM_output, function_name = "stdout", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_CACHED_VALUE_BECAME] = {
            {  module = esoTERM_pve },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_THE_RETURNED_VALUE_WAS] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED] = {
            { module = esoTERM_pve, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED_WITH] = {
            { module = esoTERM_output, function_name = "stdout", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = {
            { module = esoTERM_output, function_name = "stdout", },
            { module = esoTERM_pve, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME] = { { }, },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = esoTERM_pve, function_name = "activate", },
            { module = esoTERM_pve, function_name = "deactivate", },
            { module = esoTERM_pve, function_name = "get_level", },
            { module = esoTERM_pve, function_name = "get_level_xp", },
            { module = esoTERM_pve, function_name = "get_level_xp_max", },
            { module = esoTERM_pve, function_name = "get_level_xp_percent", },
            { module = esoTERM_pve, function_name = "get_xp_gain", },
            { module = esoTERM_pve, function_name = "initialize", },
            { module = esoTERM_pve, function_name = "is_veteran", },
        },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED_WITH] = {
            { module = esoTERM_pve, function_name = "on_experience_update", },
            { module = esoTERM_pve, function_name = "on_level_update", },
        },
    }
)

local and_IsUnitVeteran_was_called_with = tl.and_IsUnitVeteran_was_called_with
local and_IsUnitVeteran_was_not_called = tl.and_IsUnitVeteran_was_not_called
local and_ZO_SavedVars_new_was_called_with = tl.and_ZO_SavedVars_new_was_called_with
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_value_became = tl.and_cached_value_became
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_get_level_xp_max_was_called = tl.and_get_level_xp_max_was_called
local and_get_level_xp_max_was_not_called = tl.and_get_level_xp_max_was_not_called
local and_get_level_xp_was_called = tl.and_get_level_xp_was_called
local and_get_level_xp_was_not_called = tl.and_get_level_xp_was_not_called
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_register_module_was_called_with = tl.and_register_module_was_called_with
local and_that_IsUnitVeteran_returns = tl.and_that_IsUnitVeteran_returns
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_get_level_xp_max_returns = tl.and_that_get_level_xp_max_returns
local and_that_get_level_xp_returns = tl.and_that_get_level_xp_returns
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local given_that_cached_value_is = tl.given_that_cached_value_is
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local given_that_module_is_set_active_in_the_config_file = tl.given_that_module_is_set_active_in_the_config_file
local given_that_module_is_set_inactive_in_the_config_file = tl.given_that_module_is_set_inactive_in_the_config_file
local given_that_stdout_is_stubbed = tl.given_that_stdout_is_stubbed
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local then_cached_value_became = tl.then_cached_value_became
local then_module_became_active = tl.then_module_became_active
local then_module_became_inactive = tl.then_module_became_inactive
local then_stdout_was_called_with = tl.then_stdout_was_called_with
local then_stdout_was_not_called = tl.then_stdout_was_not_called
local then_the_returned_value_was = tl.then_the_returned_value_was
local verify_that_module_has_the_expected_name = tl.verify_that_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_get_level_is_called = tl.when_get_level_is_called
local when_get_level_xp_is_called = tl.when_get_level_xp_is_called
local when_get_level_xp_max_is_called = tl.when_get_level_xp_max_is_called
local when_get_level_xp_percent_is_called = tl.when_get_level_xp_percent_is_called
local when_get_xp_gain_is_called = tl.when_get_xp_gain_is_called
local when_initialize_is_called = tl.when_initialize_is_called
local when_is_veteran_is_called = tl.when_is_veteran_is_called
local when_on_experience_update_is_called_with = tl.when_on_experience_update_is_called_with
local when_on_level_update_is_called_with = tl.when_on_level_update_is_called_with
-- }}}

describe("Test module.", function()
    it("Module is called: pve.",
    function()
        verify_that_module_has_the_expected_name(esoTERM_pve, "pve")
    end)
end)

describe("Test the esoTERM_pve module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_is_set_inactive_in_the_config_file("pve")
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_not_called()
            and_ZO_SavedVars_new_was_called_with("pve")
            and_register_module_was_called_with(esoTERM.module_register, esoTERM_pve)
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_is_set_active_in_the_config_file("pve")
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_called()
            and_ZO_SavedVars_new_was_called_with("pve")
            and_register_module_was_called_with(esoTERM.module_register, esoTERM_pve)
    end)
end)

describe("Test esoTERM_pve module activate.", function()
    after_each(function()
        tl.cache_is_cleared()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on activate for non veteran unit.",
    function()
        tl.given_that_module_is_inactive(esoTERM_pve)
            tl.and_that_cache_is_empty()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_for_non_veteran_unit_are_stubbed()

        tl.when_activate_is_called()

        tl.then_module_became_active(esoTERM_pve)
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_for_non_veteran_unit_was_called_with(
                tl.get_expected_register_for_event_call_parameters_for_non_veteran_unit()
            )
            tl.and_getter_function_stubs_were_called()
            tl.and_cached_values_for_non_veteran_unit_became_initialized()
            tl.and_active_state_of_the_module_was_saved()
    end)

    it("Update cache and subscribe for events on activate for veteran unit.",
    function()
        tl.given_that_module_is_inactive(esoTERM_pve)
            tl.and_that_cache_is_empty()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_for_veteran_unit_are_stubbed()

        tl.when_activate_is_called()

        tl.then_module_became_active(esoTERM_pve)
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_for_veteran_unit_was_called_with(
                tl.get_expected_register_for_event_call_parameters_for_veteran_unit()
            )
            tl.and_getter_function_stubs_were_called()
            tl.and_cached_values_for_veteran_unit_became_initialized()
            tl.and_active_state_of_the_module_was_saved()
    end)
end)

describe("Test esoTERM_pve module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active(esoTERM_pve)
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive(esoTERM_pve)
            and_unregister_from_all_events_was_called_with(esoTERM_pve)
            and_inactive_state_of_the_module_was_saved()
    end)
end)

describe("Test PvE related data getters.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Query CHARACTER VETERANNESS, when NOT CACHED.",
    function()
        given_that_cached_value_is("veteran", nil)
            and_that_IsUnitVeteran_returns(tl.VETERANNESS_1)

        veteranness = when_is_veteran_is_called()

        then_the_returned_value_was(tl.VETERANNESS_1, veteranness)
            and_IsUnitVeteran_was_called_with(PLAYER)
    end)

    it("Query CHARACTER VETERANNESS, when CACHED.",
    function()
        given_that_cached_value_is("veteran", tl.VETERANNESS_1)
            and_that_IsUnitVeteran_returns(tl.VETERANNESS_2)

        veteranness = when_is_veteran_is_called()

        then_the_returned_value_was(tl.VETERANNESS_1, veteranness)
            and_IsUnitVeteran_was_not_called()
    end)

    it("Query NON-VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_value_is("level", nil)
            tl.and_that_GetUnitLevel_returns(tl.LEVEL_1)
            tl.and_that_is_veteran_returns(false)

        level = when_get_level_is_called()

        then_the_returned_value_was(tl.LEVEL_1, level)
            tl.and_GetUnitLevel_was_called_with(PLAYER)
    end)

    it("Query VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_value_is("level", nil)
            tl.and_that_GetUnitVeteranRank_returns(tl.LEVEL_1)
            tl.and_that_is_veteran_returns(true)

        level = when_get_level_is_called()

        then_the_returned_value_was(tl.LEVEL_1, level)
            tl.and_GetUnitVeteranRank_was_called_with(PLAYER)
    end)

    it("Query NON-VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_value_is("level", tl.LEVEL_1)
            tl.and_that_GetUnitLevel_returns(tl.LEVEL_2)
            tl.and_that_is_veteran_returns(false)

        level = when_get_level_is_called()

        then_the_returned_value_was(tl.LEVEL_1, level)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitLevel_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_value_is("level", tl.LEVEL_1)
            tl.and_that_GetUnitVeteranRank_returns(tl.LEVEL_2)
            tl.and_that_is_veteran_returns(true)

        level = when_get_level_is_called()

        then_the_returned_value_was(tl.LEVEL_1, level)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitVeteranRank_was_not_called()
    end)

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when NOT CACHED.",
    function()
        given_that_cached_value_is("level_xp", nil)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_1)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_1)
            tl.and_that_is_veteran_returns(false)

        level_xp = when_get_level_xp_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_1, level_xp)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXP_was_called_with(PLAYER)
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP, when NOT CACHED.",
    function()
        given_that_cached_value_is("level_xp", nil)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_1)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_1)
            tl.and_that_is_veteran_returns(true)

        level_xp = when_get_level_xp_is_called()

        then_the_returned_value_was(tl.LEVEL_VP_1, level_xp)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitVeteranPoints_was_called_with(PLAYER)
            tl.and_GetUnitXP_was_not_called()
    end)

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when CACHED.",
    function()
        given_that_cached_value_is("level_xp", tl.LEVEL_XP_1)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_2)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_2)
            tl.and_that_is_veteran_returns(false)

        level_xp = when_get_level_xp_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_1, level_xp)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXP_was_not_called()
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP, when CACHED.",
    function()
        given_that_cached_value_is("level_xp", tl.LEVEL_VP_1)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_2)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_2)
            tl.and_that_is_veteran_returns(false)

        level_xp = when_get_level_xp_is_called()

        then_the_returned_value_was(tl.LEVEL_VP_1, level_xp)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXP_was_not_called()
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when NOT CACHED.",
    function()
        given_that_cached_value_is("level_xp_max", nil)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_1)
            tl.and_that_is_veteran_returns(false)

        level_xp_max = when_get_level_xp_max_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_MAX_1, level_xp_max)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXPMax_was_called_with(PLAYER)
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP MAX, when NOT CACHED.",
    function()
        given_that_cached_value_is("level_xp_max", nil)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_1)
            tl.and_that_is_veteran_returns(true)

        level_xp_max = when_get_level_xp_max_is_called()

        then_the_returned_value_was(tl.LEVEL_VP_MAX_1, level_xp_max)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_called_with(PLAYER)
    end)

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when CACHED.",
    function()
        given_that_cached_value_is("level_xp_max", tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_2)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_2)
            tl.and_that_is_veteran_returns(false)

        level_xp_max = when_get_level_xp_max_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_MAX_1, level_xp_max)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP MAX, when CACHED.",
    function()
        given_that_cached_value_is("level_xp_max", tl.LEVEL_VP_MAX_1)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_2)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_2)
            tl.and_that_is_veteran_returns(true)

        level_xp_max = when_get_level_xp_max_is_called()

        then_the_returned_value_was(tl.LEVEL_VP_MAX_1, level_xp_max)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED.",
    function()
        given_that_cached_value_is("level_xp_percent", nil)
            and_that_get_level_xp_returns(82)
            and_that_get_level_xp_max_returns(500)

        level_xp_percent = when_get_level_xp_percent_is_called()

        then_the_returned_value_was(16.4, level_xp_percent)
            and_get_level_xp_was_called()
            and_get_level_xp_max_was_called()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED and LEVEL-XP MAX is 0.",
    function()
        given_that_cached_value_is("level_xp_percent", nil)
            and_that_get_level_xp_returns(100)
            and_that_get_level_xp_max_returns(0)

        level_xp_percent = when_get_level_xp_percent_is_called()

        then_the_returned_value_was(0, level_xp_percent)
            and_get_level_xp_was_called()
            and_get_level_xp_max_was_called()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when CACHED.",
    function()
        given_that_cached_value_is("level_xp_percent", tl.LEVEL_XP_PERCENT)
            and_that_get_level_xp_max_returns(tl.LEVEL_XP_MAX_1)
            and_that_get_level_xp_returns(tl.LEVEL_XP_1)

        level_xp_percent = when_get_level_xp_percent_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_PERCENT, level_xp_percent)
            and_get_level_xp_max_was_not_called()
            and_get_level_xp_was_not_called()
    end)

    it("Query CHARACTER XP-GAIN, when NOT CACHED.",
    function()
        given_that_cached_value_is("xp_gain", nil)

        xp_gain = when_get_xp_gain_is_called()

        then_the_returned_value_was(0, xp_gain)
    end)

    it("Query CHARACTER XP-GAIN, when CACHED.",
    function()
        given_that_cached_value_is("xp_gain", tl.LEVEL_XP_GAIN)

        xp_gain = when_get_xp_gain_is_called()

        then_the_returned_value_was(tl.LEVEL_XP_GAIN, xp_gain)
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    local function get_xp_message()
        return string.format("Gained %d XP (%.2f%%)",
                             tl.CACHE.xp_gain,
                             tl.CACHE.level_xp_percent)
    end

    describe("The on experience update event handler.", function()
        local REASON = 0
        local OLD_XP = 100
        local OLD_XP_MAX = 1000
        local OLD_XP_PCT = OLD_XP * 100 / OLD_XP_MAX
        local OLD_XP_GAIN = 10
        local NEW_XP = 200
        local NEW_XP_LVL_UP = 1100
        local NEW_XP_MAX = 2000
        local NEW_XP_PCT = NEW_XP * 100 / NEW_XP_MAX

        before_each(function()
            tl.CACHE.level_xp = OLD_XP
            tl.CACHE.level_xp_max = OLD_XP_MAX
            tl.CACHE.level_xp_percent = OLD_XP_PCT
            tl.CACHE.xp_gain = OLD_XP_GAIN
        end)

        it("Happy flow.", function()
            given_that_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, NEW_XP_MAX, REASON)

            then_stdout_was_called_with(get_xp_message())
                and_cached_value_became("level_xp", NEW_XP)
                and_cached_value_became("level_xp_max", NEW_XP_MAX)
                and_cached_value_became("level_xp_percent", NEW_XP_PCT)
                and_cached_value_became("xp_gain", NEW_XP - OLD_XP)
        end)

        it("If xp > level xp maximum, then 100%.", function()
            given_that_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP_LVL_UP, OLD_XP_MAX, REASON)

            then_stdout_was_called_with(get_xp_message())
                and_cached_value_became("level_xp", NEW_XP_LVL_UP)
                and_cached_value_became("level_xp_max", OLD_XP_MAX)
                and_cached_value_became("level_xp_percent", 100)
                and_cached_value_became("xp_gain", NEW_XP_LVL_UP - OLD_XP)
        end)

        it("If unit is incorrect.", function()
            given_that_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, "foo", NEW_XP, NEW_XP_MAX, REASON)

            then_stdout_was_not_called()
                and_cached_value_became("level_xp", OLD_XP)
                and_cached_value_became("level_xp_max", OLD_XP_MAX)
                and_cached_value_became("level_xp_percent", OLD_XP_PCT)
        end)

        it("If reason is incorrect (level up drift handling).", function()
            given_that_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, NEW_XP_MAX, -1)

            then_stdout_was_called_with(get_xp_message())
                and_cached_value_became("level_xp", NEW_XP)
                and_cached_value_became("level_xp_max", NEW_XP_MAX)
                and_cached_value_became("level_xp_percent", NEW_XP_PCT)
                and_cached_value_became("xp_gain", OLD_XP_GAIN)
        end)

        it("If total maximum xp reached.", function()
            given_that_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, 0, REASON)

            then_stdout_was_not_called()
                and_cached_value_became("level_xp", OLD_XP)
                and_cached_value_became("level_xp_max", OLD_XP_MAX)
                and_cached_value_became("level_xp_percent", OLD_XP_PCT)
        end)
    end)

    describe("The on level update event handler.", function()
        local OLD_LEVEL = 1
        local NEW_LEVEL = 2

        before_each(function()
            tl.CACHE.level = OLD_LEVEL
        end)

        it("Happy flow.", function()
            when_on_level_update_is_called_with(EVENT, PLAYER, NEW_LEVEL)

            then_cached_value_became("level", NEW_LEVEL)
        end)

        it("If unit incorrect.", function()
            when_on_level_update_is_called_with(EVENT, "foo", NEW_LEVEL)

            then_cached_value_became("level", OLD_LEVEL)
        end)
    end)
end)
