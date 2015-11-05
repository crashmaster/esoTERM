local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_pve_library")

-- Locals {{{
local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_module_became_active = tl.and_module_became_active
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_register_module_was_called_with = tl.and_register_module_was_called_with
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_esoTERM_pve_activate_is_stubbed = tl.and_that_esoTERM_pve_activate_is_stubbed
local and_that_esoTERM_pve_activate_is_stubbed = tl.and_that_esoTERM_pve_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_getter_functions_are_stubbed = tl.and_that_getter_functions_are_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_module_is_set_active_in_the_config_file = tl.given_that_module_is_set_active_in_the_config_file
local given_that_module_is_set_inactive_in_the_config_file = tl.given_that_module_is_set_inactive_in_the_config_file
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_esoTERM_pve_activate_was_called = tl.then_esoTERM_pve_activate_was_called
local then_esoTERM_pve_activate_was_not_called = tl.then_esoTERM_pve_activate_was_not_called
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_module_has_the_expected_name = tl.verify_that_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called

local EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN = tl.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN
local EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN = tl.EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN
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
            and_that_esoTERM_pve_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_pve_activate_was_not_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called_with(esoTERM_pve)
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_is_set_active_in_the_config_file("pve")
            and_that_register_module_is_stubbed()
            and_that_esoTERM_pve_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_pve_activate_was_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called_with(esoTERM_pve)
    end)
end)

describe("Test esoTERM_pve module activate.", function()
    after_each(function()
        tl.cache_is_cleared()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on activate for non veteran unit.",
    function()
        tl.given_that_module_is_inactive()
            tl.and_that_cache_is_empty()
            tl.and_that_expected_register_for_event_calls_for_non_veteran_unit_are_set_up()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_for_non_veteran_unit_are_stubbed()

        tl.when_activate_is_called()

        tl.and_module_became_active()
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_for_non_veteran_unit_was_called_with(EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN)
            tl.and_getter_function_stubs_were_called()
            tl.and_cached_values_for_non_veteran_unit_became_initialized()
            tl.and_active_state_of_the_module_was_saved()
    end)

    it("Update cache and subscribe for events on activate for veteran unit.",
    function()
        tl.given_that_module_is_inactive()
            tl.and_that_cache_is_empty()
            tl.and_that_expected_register_for_event_calls_for_veteran_unit_are_set_up()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_for_veteran_unit_are_stubbed()

        tl.when_activate_is_called()

        tl.and_module_became_active()
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_for_veteran_unit_was_called_with(EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN)
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
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive()
            and_unregister_from_all_events_was_called_with(esoTERM_pve)
            and_inactive_state_of_the_module_was_saved()
    end)
end)

describe("Test PvE related data getters.", function()
    local results = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        results = nil
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is_not_set()
        tl.CACHE.veteran = nil
    end

    local function and_that_IsUnitVeteran_returns(veteranness)
        ut_helper.stub_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function when_is_veteran_is_called()
        results.veteran = esoTERM_pve.is_veteran()
    end

    local function then_the_returned_character_veteranness_was(veteranness)
        assert.is.equal(veteranness, results.veteran)
    end

    local function and_IsUnitVeteran_was_called_once_with_player()
        assert.spy(GLOBAL.IsUnitVeteran).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER VETERANNESS, when NOT CACHED.",
    function()
        given_that_cached_character_veteranness_is_not_set()
            and_that_IsUnitVeteran_returns(tl.VETERANNESS_1)

        when_is_veteran_is_called()

        then_the_returned_character_veteranness_was(tl.VETERANNESS_1)
            and_IsUnitVeteran_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is(veteranness)
        tl.CACHE.veteran = veteranness
    end

    local function and_that_IsUnitVeteran_returns(veteranness)
        ut_helper.stub_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_IsUnitVeteran_was_not_called()
        assert.spy(GLOBAL.IsUnitVeteran).was_not.called()
    end
    -- }}}

    it("Query CHARACTER VETERANNESS, when CACHED.",
    function()
        given_that_cached_character_veteranness_is(tl.VETERANNESS_1)
            and_that_IsUnitVeteran_returns(VETERANNESS_2)

        when_is_veteran_is_called()

        then_the_returned_character_veteranness_was(tl.VETERANNESS_1)
            and_IsUnitVeteran_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_is_not_set()
        tl.CACHE.level = nil
    end

    local function when_get_level_is_called()
        results.level = esoTERM_pve.get_level()
    end

    local function then_the_returned_level_was(level)
        assert.is.equal(level, results.level)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_character_level_is_not_set()
            tl.and_that_GetUnitLevel_returns(tl.LEVEL_1)
            tl.and_character_is_not_veteran()

        when_get_level_is_called()

        then_the_returned_level_was(tl.LEVEL_1)
            tl.and_GetUnitLevel_was_called_once_with_player()
    end)

    it("Query VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_character_level_is_not_set()
            tl.and_that_GetUnitVeteranRank_returns(tl.LEVEL_1)
            tl.and_character_is_veteran()

        when_get_level_is_called()

        then_the_returned_level_was(tl.LEVEL_1)
            tl.and_GetUnitVeteranRank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_is(level)
        tl.CACHE.level = level
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_character_level_is(tl.LEVEL_1)
            tl.and_that_GetUnitLevel_returns(tl.LEVEL_2)
            tl.and_character_is_not_veteran()

        when_get_level_is_called()

        then_the_returned_level_was(tl.LEVEL_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitLevel_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_character_level_is(tl.LEVEL_1)
            tl.and_that_GetUnitVeteranRank_returns(tl.LEVEL_2)
            tl.and_character_is_veteran()

        when_get_level_is_called()

        then_the_returned_level_was(tl.LEVEL_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitVeteranRank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is_not_set()
        tl.CACHE.level_xp = nil
    end

    local function when_get_level_xp_is_called()
        results.level_xp = esoTERM_pve.get_level_xp()
    end

    local function then_the_returned_level_xp_was(xp)
        assert.is.equal(xp, results.level_xp)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_is_not_set()
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_1)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_1)
            tl.and_character_is_not_veteran()

        when_get_level_xp_is_called()

        then_the_returned_level_xp_was(tl.LEVEL_XP_1)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXP_was_called_once_with_player()
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_is_not_set()
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_1)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_1)
            tl.and_character_is_veteran()

        when_get_level_xp_is_called()

        then_the_returned_level_xp_was(tl.LEVEL_VP_1)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitVeteranPoints_was_called_once_with_player()
            tl.and_GetUnitXP_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is(xp)
        tl.CACHE.level_xp = xp
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when CACHED.",
    function()
        given_that_cached_character_level_xp_is(tl.LEVEL_XP_1)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_2)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_2)
            tl.and_character_is_not_veteran()

        when_get_level_xp_is_called()

        then_the_returned_level_xp_was(tl.LEVEL_XP_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXP_was_not_called()
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP, when CACHED.",
    function()
        given_that_cached_character_level_xp_is(tl.LEVEL_VP_1)
            tl.and_that_GetUnitXP_returns(tl.LEVEL_XP_2)
            tl.and_that_GetUnitVeteranPoints_returns(tl.LEVEL_VP_2)
            tl.and_character_is_not_veteran()

        when_get_level_xp_is_called()

        then_the_returned_level_xp_was(tl.LEVEL_VP_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXP_was_not_called()
            tl.and_GetUnitVeteranPoints_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is_not_set()
        tl.CACHE.level_xp_max = nil
    end

    local function when_get_level_xp_max_is_called()
        results.level_xp_max = esoTERM_pve.get_level_xp_max()
    end

    local function then_the_returned_level_xp_max_was(xp)
        assert.is.equal(xp, results.level_xp_max)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_max_is_not_set()
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_1)
            tl.and_character_is_not_veteran()

        when_get_level_xp_max_is_called()

        then_the_returned_level_xp_max_was(tl.LEVEL_XP_MAX_1)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXPMax_was_called_once_with_player()
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP MAX, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_max_is_not_set()
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_1)
            tl.and_character_is_veteran()

        when_get_level_xp_max_is_called()

        then_the_returned_level_xp_max_was(tl.LEVEL_VP_MAX_1)
            tl.and_is_veteran_was_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is(xp)
        tl.CACHE.level_xp_max = xp
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when CACHED.",
    function()
        given_that_cached_character_level_xp_max_is(tl.LEVEL_XP_MAX_1)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_2)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_2)
            tl.and_character_is_not_veteran()

        when_get_level_xp_max_is_called()

        then_the_returned_level_xp_max_was(tl.LEVEL_XP_MAX_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    it("Query VETERAN CHARACTER LEVEL-XP MAX, when CACHED.",
    function()
        given_that_cached_character_level_xp_max_is(tl.LEVEL_VP_MAX_1)
            tl.and_that_GetUnitXPMax_returns(tl.LEVEL_XP_MAX_2)
            tl.and_that_GetUnitVeteranPointsMax_returns(tl.LEVEL_VP_MAX_2)
            tl.and_character_is_veteran()

        when_get_level_xp_max_is_called()

        then_the_returned_level_xp_max_was(tl.LEVEL_VP_MAX_1)
            tl.and_is_veteran_was_not_called()
            tl.and_GetUnitXPMax_was_not_called()
            tl.and_GetUnitVeteranPointsMax_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is_not_set()
        tl.CACHE.level_xp_percent = nil
    end

    local function and_that_get_level_xp_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp", xp)
    end

    local function and_that_get_level_xp_max_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp_max", xp)
    end

    local function when_get_level_xp_percent_is_called()
        results.level_xp_percent = esoTERM_pve.get_level_xp_percent()
    end

    local function then_the_returned_level_xp_percent_was(level_xp_percent)
        assert.is.equal(level_xp_percent, results.level_xp_percent)
    end

    local function and_get_level_xp_was_called()
        assert.spy(esoTERM_pve.get_level_xp).was.called_with()
    end

    local function and_get_level_xp_max_was_called()
        assert.spy(esoTERM_pve.get_level_xp_max).was.called_with()
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_level_xp_returns(82)
            and_that_get_level_xp_max_returns(500)

        when_get_level_xp_percent_is_called()

        then_the_returned_level_xp_percent_was(16.4)
            and_get_level_xp_was_called()
            and_get_level_xp_max_was_called()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED and LEVEL-XP MAX is 0.",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_level_xp_returns(100)
            and_that_get_level_xp_max_returns(0)

        when_get_level_xp_percent_is_called()

        then_the_returned_level_xp_percent_was(0)
            and_get_level_xp_was_called()
            and_get_level_xp_max_was_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is(percent)
        tl.CACHE.level_xp_percent = percent
    end

    local function and_that_get_level_xp_max_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp_max", xp)
    end

    local function and_that_get_level_xp_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp", xp)
    end

    local function and_get_level_xp_max_was_not_called()
        assert.spy(esoTERM_pve.get_level_xp_max).was_not.called()
    end

    local function and_get_level_xp_was_not_called()
        assert.spy(esoTERM_pve.get_level_xp).was_not.called()
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT, when CACHED.",
    function()
        given_that_cached_character_level_xp_percent_is(tl.LEVEL_XP_PERCENT)
            and_that_get_level_xp_max_returns(tl.LEVEL_XP_MAX_1)
            and_that_get_level_xp_returns(tl.LEVEL_XP_1)

        when_get_level_xp_percent_is_called()

        then_the_returned_level_xp_percent_was(tl.LEVEL_XP_PERCENT)
            and_get_level_xp_max_was_not_called()
            and_get_level_xp_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is_not_set()
        tl.CACHE.xp_gain = nil
    end

    local function when_get_xp_gain_is_called()
        results.xp_gain = esoTERM_pve.get_xp_gain()
    end

    local function then_the_returned_level_xp_gain_was(gain)
        assert.is.equal(gain, results.xp_gain)
    end
    -- }}}

    it("Query CHARACTER XP-GAIN, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_gain_is_not_set()

        when_get_xp_gain_is_called()

        then_the_returned_level_xp_gain_was(0)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is(gain)
        tl.CACHE.xp_gain = gain
    end
    -- }}}

    it("Query CHARACTER XP-GAIN, when CACHED.",
    function()
        given_that_cached_character_level_xp_gain_is(tl.LEVEL_XP_GAIN)

        when_get_xp_gain_is_called()

        then_the_returned_level_xp_gain_was(tl.LEVEL_XP_GAIN)
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function get_xp_message()
        return string.format("Gained %d XP (%.2f%%)",
                             tl.CACHE.xp_gain,
                             tl.CACHE.level_xp_percent)
    end

    local function and_esoTERM_output_stdout_was_called_with_xp_message()
        local message = get_xp_message()
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function and_esoTERM_output_stdout_was_not_called()
        assert.spy(esoTERM_output.stdout).was_not.called()
    end
    -- }}}

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

        -- {{{
        local function when_on_experience_update_is_called_with(event, unit, xp, xp_max, reason)
            esoTERM_pve.on_experience_update(event, unit, xp, xp_max, reason)
        end

        local function then_the_xp_properties_in_character_info_where_updated()
            assert.is.equal(NEW_XP, tl.CACHE.level_xp)
            assert.is.equal(NEW_XP_MAX, tl.CACHE.level_xp_max)
            assert.is.equal(NEW_XP_PCT, tl.CACHE.level_xp_percent)
            assert.is.equal(NEW_XP - OLD_XP, tl.CACHE.xp_gain)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
            assert.is.equal(NEW_XP_LVL_UP, tl.CACHE.level_xp)
            assert.is.equal(OLD_XP_MAX, tl.CACHE.level_xp_max)
            assert.is.equal(100, tl.CACHE.level_xp_percent)
            assert.is.equal(NEW_XP_LVL_UP - OLD_XP, tl.CACHE.xp_gain)
        end
        -- }}}

        it("If xp > level xp maximum, then 100%.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP_LVL_UP, OLD_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_XP, tl.CACHE.level_xp)
            assert.is.equal(OLD_XP_MAX, tl.CACHE.level_xp_max)
            assert.is.equal(OLD_XP_PCT, tl.CACHE.level_xp_percent)
        end
        -- }}}

        it("If unit is incorrect.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, "foo", NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_esoTERM_output_stdout_was_not_called()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_partly_updated()
            assert.is.equal(NEW_XP, tl.CACHE.level_xp)
            assert.is.equal(NEW_XP_MAX, tl.CACHE.level_xp_max)
            assert.is.equal(NEW_XP_PCT, tl.CACHE.level_xp_percent)
            assert.is.equal(OLD_XP_GAIN, tl.CACHE.xp_gain)
        end
        -- }}}
        it("If reason is incorrect (level up drift handling).", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, NEW_XP_MAX, -1)

            then_the_xp_properties_in_character_info_where_partly_updated()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        it("If total maximum xp reached.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, PLAYER, NEW_XP, 0, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_esoTERM_output_stdout_was_not_called()
        end)
    end)

    describe("The on level update event handler.", function()
        local OLD_LEVEL = 1
        local NEW_LEVEL = 2

        before_each(function()
            tl.CACHE.level = OLD_LEVEL
        end)

        -- {{{
        local function when_on_level_update_is_called_with(event, unit, level)
            esoTERM_pve.on_level_update(event, unit, level)
        end

        local function then_the_level_property_in_character_info_was_updated()
            assert.is.equal(NEW_LEVEL, tl.CACHE.level)
        end
        -- }}}

        it("Happy flow.", function()
            when_on_level_update_is_called_with(EVENT, PLAYER, NEW_LEVEL)

            then_the_level_property_in_character_info_was_updated()
        end)

        -- {{{
        local function then_the_level_property_in_character_info_was_not_updated()
            assert.is.equal(OLD_LEVEL, tl.CACHE.level)
        end
        -- }}}

        it("If unit incorrect.", function()
            when_on_level_update_is_called_with(EVENT, "foo", NEW_LEVEL)

            then_the_level_property_in_character_info_was_not_updated()
        end)
    end)
end)
