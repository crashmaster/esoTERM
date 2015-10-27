local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_pvp_library")

-- Locals {{{
local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_module_is_inactive_was_saved = tl.and_module_is_inactive_was_saved
local and_register_for_event_was_called_with_expected_parameters = tl.and_register_for_event_was_called_with_expected_parameters
local and_register_module_was_called = tl.and_register_module_was_called
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_esoTERM_pvp_activate_is_stubbed = tl.and_that_esoTERM_pvp_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_getter_functions_are_stubbed = tl.and_that_getter_functions_are_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called = tl.and_unregister_from_all_events_was_called
local and_ZO_SavedVars_new_was_called = tl.and_ZO_SavedVars_new_was_called
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_esoTERM_pvp_activate_was_called = tl.then_esoTERM_pvp_activate_was_called
local then_esoTERM_pvp_activate_was_not_called = tl.then_esoTERM_pvp_activate_was_not_called
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_pvp_module_has_the_expected_name = tl.verify_that_esoTERM_pvp_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_is_called = tl.when_initialize_is_called
-- }}}

describe("Test module.", function()
    it("Module is called: pvp.",
    function()
        verify_that_esoTERM_pvp_module_has_the_expected_name()
    end)
end)

describe("Test the esoTERM_pvp module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_configured_as_inactive()
            and_that_register_module_is_stubbed()
            and_that_esoTERM_pvp_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_pvp_activate_was_not_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_register_module_is_stubbed()
            and_that_esoTERM_pvp_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_pvp_activate_was_called()
            and_ZO_SavedVars_new_was_called()
            and_register_module_was_called()
    end)
end)

describe("Test esoTERM_pvp module activate.", function()
    after_each(function()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)
    -- TODO: clear chache after tests?

    it("Update cache and subscribe for events on activate.",
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

describe("Test esoTERM_pvp module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        tl.given_that_module_is_active()
            tl.and_that_unregister_from_all_events_is_stubbed()

        tl.when_deactivate_is_called()

        tl.then_module_became_inactive()
            tl.and_unregister_from_all_events_was_called()
            tl.and_module_is_inactive_was_saved()
    end)
end)

describe("Test PvP related data getters.", function()
    local results = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_is_not_set()
        tl.CACHE.ava_points = nil
    end

    local function and_that_GetUnitAvARankPoints_returns(points)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARankPoints", points)
    end

    local function when_get_ava_points_is_called()
        results.ava_points = esoTERM_pvp.get_ava_points()
    end

    local function then_the_returned_character_ava_points_was(points)
        assert.is.equal(points, results.ava_points)
    end

    local function and_GetUnitAvARankPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_points_is_not_set()
            and_that_GetUnitAvARankPoints_returns(tl.AVA_POINTS_1)

        when_get_ava_points_is_called()

        then_the_returned_character_ava_points_was(tl.AVA_POINTS_1)
            and_GetUnitAvARankPoints_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_is(points)
        tl.CACHE.ava_points = points
    end

    local function and_GetUnitAvARankPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_points_is(tl.AVA_POINTS_1)
            and_that_GetUnitAvARankPoints_returns(tl.AVA_POINTS_2)

        when_get_ava_points_is_called()

        then_the_returned_character_ava_points_was(tl.AVA_POINTS_1)
            and_GetUnitAvARankPoints_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is_not_set()
        tl.CACHE.ava_rank = nil
    end

    local function and_that_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_ava_rank_is_called()
        results.ava_rank = esoTERM_pvp.get_ava_rank()
    end

    local function then_the_returned_character_ava_rank_was(rank)
        assert.is.equal(rank, results.ava_rank)
    end

    local function and_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-RANK, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_is_not_set()
            and_that_GetUnitAvARank_returns(tl.AVA_RANK_1, tl.AVA_SUB_RANK_1)

        when_get_ava_rank_is_called()

        then_the_returned_character_ava_rank_was(tl.AVA_RANK_1)
            and_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is(rank)
        tl.CACHE.ava_rank = rank
    end

    local function and_that_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK, when CACHED.",
    function()
        given_that_cached_character_ava_rank_is(tl.AVA_RANK_1)
            and_that_GetUnitAvARank_returns(tl.AVA_RANK_2, tl.AVA_SUB_RANK_2)

        when_get_ava_rank_is_called()

        then_the_returned_character_ava_rank_was(tl.AVA_RANK_1)
            and_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is_not_set()
        tl.CACHE.ava_sub_rank = nil
    end

    local function and_that_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_ava_sub_rank_is_called()
        results.ava_sub_rank = esoTERM_pvp.get_ava_sub_rank()
    end

    local function then_the_returned_character_ava_sub_rank_was(sub_rank)
        assert.is.equal(sub_rank, results.ava_sub_rank)
    end

    local function and_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-SUB-RANK, when NOT CACHED.",
    function()
        given_that_cached_character_ava_sub_rank_is_not_set()
            and_that_GetUnitAvARank_returns(tl.AVA_RANK_1, tl.AVA_SUB_RANK_1)

        when_get_ava_sub_rank_is_called()

        then_the_returned_character_ava_sub_rank_was(tl.AVA_SUB_RANK_1)
            and_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is(sub_rank)
        tl.CACHE.ava_sub_rank = sub_rank
    end

    local function and_that_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-SUB-RANK, when CACHED.",
    function()
        given_that_cached_character_ava_sub_rank_is(tl.AVA_SUB_RANK_1)
            and_that_GetUnitAvARank_returns(tl.AVA_RANK_2, tl.AVA_SUB_RANK_2)

        when_get_ava_sub_rank_is_called()

        then_the_returned_character_ava_sub_rank_was(tl.AVA_SUB_RANK_1)
            and_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is_not_set()
        tl.CACHE.ava_rank_name = nil
    end

    local function and_that_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_that_get_gender_returns(gender)
        ut_helper.stub_function(esoTERM_char, "get_gender", gender)
    end

    local function and_that_get_ava_rank_returns(rank)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank", rank)
    end

    local function when_get_ava_rank_name_is_called()
        results.ava_rank_name = esoTERM_pvp.get_ava_rank_name()
    end

    local function then_the_returned_character_ava_rank_name_was(rank)
        assert.is.equal(rank, results.ava_rank_name)
    end

    local function and_GetAvARankName_was_called_once_with(gender, rank)
        assert.spy(GLOBAL.GetAvARankName).was.called_with(gender, rank)
    end

    local function and_get_gender_was_called_once()
        assert.spy(esoTERM_char.get_gender).was.called_with()
    end

    local function and_get_ava_rank_was_called_once()
        assert.spy(esoTERM_pvp.get_ava_rank).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK-NAME, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_name_is_not_set()
            and_that_GetAvARankName_returns(tl.AVA_RANK_NAME_1)
            and_that_get_gender_returns(GENDER_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)

        when_get_ava_rank_name_is_called()

        then_the_returned_character_ava_rank_name_was(tl.AVA_RANK_NAME_1)
            and_GetAvARankName_was_called_once_with(GENDER_1, tl.AVA_RANK_1)
            and_get_gender_was_called_once()
            and_get_ava_rank_was_called_once()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is(name)
        tl.CACHE.ava_rank_name = name
    end

    local function and_that_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_GetAvARankName_was_not_called()
        assert.spy(GLOBAL.GetAvARankName).was_not.called()
    end

    local function and_get_gender_was_not_called()
        assert.spy(esoTERM_char.get_gender).was_not.called()
    end

    local function and_get_ava_rank_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_rank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK-NAME, when CACHED.",
    function()
        given_that_cached_character_ava_rank_name_is(tl.AVA_RANK_NAME_1)
            and_that_GetAvARankName_returns(tl.AVA_RANK_NAME_2)
            and_that_get_gender_returns(GENDER_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)

        when_get_ava_rank_name_is_called()

        then_the_returned_character_ava_rank_name_was(tl.AVA_RANK_NAME_1)
            and_GetAvARankName_was_not_called()
            and_get_gender_was_not_called()
            and_get_ava_rank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_is_not_set()
        tl.CACHE.ava_rank_points = nil
    end

    local function and_that_get_ava_rank_points_lb_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_lb", points)
    end

    local function and_that_get_ava_points_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_points", points)
    end

    local function when_get_ava_rank_points_is_called()
        results.ava_rank_points = esoTERM_pvp.get_ava_rank_points()
    end

    local function then_the_returned_character_ava_rank_points_was(points)
        assert.is.equal(points, results.ava_rank_points)
    end

    local function and_get_ava_rank_was_called_once()
        assert.spy(esoTERM_pvp.get_ava_rank).was.called_with()
    end

    local function and_get_ava_points_was_called_once()
        assert.spy(esoTERM_pvp.get_ava_points).was.called_with()
    end

    local function and_get_ava_rank_points_lb_was_called_once()
        assert.spy(esoTERM_pvp.get_ava_rank_points_lb).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_is_not_set()
            and_that_get_ava_points_returns(150)
            and_that_get_ava_rank_points_lb_returns(100)

        when_get_ava_rank_points_is_called()

        then_the_returned_character_ava_rank_points_was(50)
            and_get_ava_points_was_called_once()
            and_get_ava_rank_points_lb_was_called_once()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_is(points)
        tl.CACHE.ava_rank_points = points
    end

    local function and_get_ava_points_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_points).was_not.called()
    end

    local function and_get_ava_rank_points_lb_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points_lb).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS from the CACHE.",
    function()
        given_that_cached_character_ava_rank_points_is(tl.AVA_RANK_POINTS_1)
            and_that_get_ava_points_returns(tl.AVA_POINTS_1)
            and_that_get_ava_rank_points_lb_returns(tl.AVA_RANK_POINTS_LB_1)

        when_get_ava_rank_points_is_called()

        then_the_returned_character_ava_rank_points_was(tl.AVA_RANK_POINTS_1)
            and_get_ava_points_was_not_called()
            and_get_ava_rank_points_lb_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_max_is_not_set()
        tl.CACHE.ava_rank_points_max = nil
    end

    local function and_that_get_ava_rank_points_lb_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_lb", points)
    end

    local function and_that_get_ava_rank_points_ub_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_ub", points)
    end

    local function when_get_ava_rank_points_max_is_called()
        results.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max()
    end

    local function then_the_returned_character_ava_rank_points_max_was(points)
        assert.is.equal(points, results.ava_rank_points_max)
    end

    local function and_get_ava_rank_points_ub_was_called_once()
        assert.spy(esoTERM_pvp.get_ava_rank_points_ub).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS MAX, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_max_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_get_ava_rank_points_lb_returns(tl.AVA_RANK_POINTS_LB_1)
            and_that_get_ava_rank_points_ub_returns(tl.AVA_RANK_POINTS_UB_1)

        when_get_ava_rank_points_max_is_called()

        then_the_returned_character_ava_rank_points_max_was(
                                tl.AVA_RANK_POINTS_UB_1 - tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_points_lb_was_called_once()
            and_get_ava_rank_points_ub_was_called_once()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_max_is(points)
        tl.CACHE.ava_rank_points_max = points
    end

    local function and_get_ava_rank_points_ub_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points_ub).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS MAX from the CACHE.",
    function()
        given_that_cached_character_ava_rank_points_max_is(tl.AVA_RANK_POINTS_MAX_1)
            and_that_get_ava_rank_points_lb_returns(tl.AVA_RANK_POINTS_LB_1)
            and_that_get_ava_rank_points_ub_returns(tl.AVA_RANK_POINTS_UB_1)

        when_get_ava_rank_points_max_is_called()

        then_the_returned_character_ava_rank_points_max_was(tl.AVA_RANK_POINTS_MAX_1)
            and_get_ava_rank_points_lb_was_not_called()
            and_get_ava_rank_points_ub_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_percent_is_not_set()
        tl.CACHE.ava_rank_points_percent = nil
    end

    local function and_that_get_ava_rank_points_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points", points)
    end

    local function and_that_get_ava_rank_points_max_returns(points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_max", points)
    end

    local function when_get_ava_rank_points_percent_is_called()
        results.rank_points_percent = esoTERM_pvp.get_ava_rank_points_percent()
    end

    local function then_the_returned_ava_rank_points_percent_was(rank_points_percent)
        assert.is.equal(rank_points_percent, results.rank_points_percent)
    end

    local function and_get_ava_rank_points_was_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points).was.called_with()
    end

    local function and_get_ava_rank_points_max_was_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points_max).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS PERCENT, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_percent_is_not_set()
            and_that_get_ava_rank_points_returns(82)
            and_that_get_ava_rank_points_max_returns(500)

        when_get_ava_rank_points_percent_is_called()

        then_the_returned_ava_rank_points_percent_was(16.4)
            and_get_ava_rank_points_was_called()
            and_get_ava_rank_points_max_was_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_percent_is(percent)
        tl.CACHE.ava_rank_points_percent = percent
    end

    local function and_that_get_ava_rank_points_max_returns(rank_points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_max", rank_points)
    end

    local function and_that_get_ava_rank_points_returns(rank_points)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points", rank_points)
    end

    local function and_get_ava_rank_points_max_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points_max).was_not.called()
    end

    local function and_get_ava_rank_points_was_not_called()
        assert.spy(esoTERM_pvp.get_ava_rank_points).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS PERCENT, when CACHED.",
    function()
        given_that_cached_character_ava_rank_points_percent_is(tl.AVA_RANK_POINTS_PERCENT)
            and_that_get_ava_rank_points_max_returns(tl.AVA_RANK_POINTS_MAX_1)
            and_that_get_ava_rank_points_returns(tl.AVA_RANK_POINTS_1)

        when_get_ava_rank_points_percent_is_called()

        then_the_returned_ava_rank_points_percent_was(tl.AVA_RANK_POINTS_PERCENT)
            and_get_ava_rank_points_max_was_not_called()
            and_get_ava_rank_points_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ap_gain_is_not_set()
        tl.CACHE.ap_gain = nil
    end

    local function when_get_ap_gain_is_called()
        results.ap_gain = esoTERM_pvp.get_ap_gain()
    end

    local function then_the_returned_ap_gain_was(gain)
        assert.is.equal(gain, results.ap_gain)
    end
    -- }}}

    it("Query CHARACTER AVA-POINTS GAIN, when NOT CACHED.",
    function()
        given_that_cached_character_ap_gain_is_not_set()

        when_get_ap_gain_is_called()

        then_the_returned_ap_gain_was(0)
    end)

    -- {{{
    local function given_that_cached_character_ap_gain_is(gain)
        tl.CACHE.ap_gain = gain
    end
    -- }}}

    it("Query CHARACTER AVA-POINTS GAIN, when CACHED.",
    function()
        given_that_cached_character_ap_gain_is(tl.AVA_POINTS_GAIN)

        when_get_ap_gain_is_called()

        then_the_returned_ap_gain_was(tl.AVA_POINTS_GAIN)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is_not_set()
        tl.CACHE.ava_rank_points_lb = nil
    end

    local function and_that_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_ava_rank_points_lb_is_called()
        results.ava_rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb()
    end

    local function then_the_returned_character_ava_rank_points_lb_was(point)
        assert.is.equal(point, results.ava_rank_points_lb)
    end

    local function and_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_lb_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_LB_1)

        when_get_ava_rank_points_lb_is_called()

        then_the_returned_character_ava_rank_points_lb_was(tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_was_called_once()
            and_GetNumPointsNeededForAvARank_was_called_once_with(tl.AVA_RANK_1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is(point)
        tl.CACHE.ava_rank_points_lb = point
    end

    local function and_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_rank_points_lb_is(tl.AVA_RANK_POINTS_LB_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_LB_2)

        when_get_ava_rank_points_lb_is_called()

        then_the_returned_character_ava_rank_points_lb_was(tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_was_not_called()
            and_GetNumPointsNeededForAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is_not_set()
        tl.CACHE.ava_rank_points_ub = nil
    end

    local function and_that_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_ava_rank_points_ub_is_called()
        results.ava_rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub()
    end

    local function then_the_returned_character_ava_rank_points_ub_was(point)
        assert.is.equal(point, results.ava_rank_points_ub)
    end

    local function and_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_ub_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_UB_1)

        when_get_ava_rank_points_ub_is_called()

        then_the_returned_character_ava_rank_points_ub_was(tl.AVA_RANK_POINTS_UB_1)
            and_get_ava_rank_was_called_once()
            and_GetNumPointsNeededForAvARank_was_called_once_with(tl.AVA_RANK_1 + 1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is(point)
        tl.CACHE.ava_rank_points_ub = point
    end

    local function and_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_rank_points_ub_is(tl.AVA_RANK_POINTS_UB_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_UB_2)

        when_get_ava_rank_points_ub_is_called()

        then_the_returned_character_ava_rank_points_ub_was(tl.AVA_RANK_POINTS_UB_1)
            and_get_ava_rank_was_not_called()
            and_GetNumPointsNeededForAvARank_was_not_called()
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

    local function get_ap_message()
        return string.format("Gained %d AP (%.2f%%)",
                             tl.CACHE.ap_gain,
                             tl.CACHE.ava_rank_points_percent)
    end

    local function and_esoTERM_output_stdout_was_called_with_ap_message()
        local message = get_ap_message()
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function and_esoTERM_output_ap_to_chat_tab_was_not_called()
        assert.spy(esoTERM_output.stdout).was_not.called()
    end
    -- }}}

    describe("The on AvA points update event handler.", function()
        local POINT = 0
        local SOUND = 0
        local OLD_RANK = 4
        local NEW_RANK = 5
        local OLD_GAIN = 0
        local NEW_GAIN = 100
        local GAIN_ZERO = 0
        local GAIN_NEGATIVE = -10000
        local GAIN_RANK_UP = 300
        local OLD_POINTS_MAX = 1000
        local NEW_POINTS_MAX = 2000
        local OLD_POINTS = 800
        local NEW_POINTS = OLD_POINTS + NEW_GAIN
        local NEW_POINTS_RANK_UP = OLD_POINTS + GAIN_RANK_UP - OLD_POINTS_MAX
        local OLD_POINTS_PCT = OLD_POINTS * 100 / OLD_POINTS_MAX
        local NEW_POINTS_PCT = NEW_POINTS * 100 / OLD_POINTS_MAX
        local NEW_POINTS_PCT_RANK_UP = NEW_POINTS_RANK_UP * 100 / NEW_POINTS_MAX

        before_each(function()
            tl.CACHE.ava_rank = OLD_RANK
            tl.CACHE.ava_rank_points = OLD_POINTS
            tl.CACHE.ava_rank_points_max = OLD_POINTS_MAX
            tl.CACHE.ava_rank_points_percent = OLD_POINTS_PCT
            tl.CACHE.ap_gain = OLD_GAIN
        end)

        -- {{{
        local function and_that_get_ava_rank_returns(rank)
            ut_helper.stub_function(esoTERM_pvp, "get_ava_rank", rank)
        end

        local function and_get_ava_rank_was_called_once_witch_cache()
            assert.spy(esoTERM_pvp.get_ava_rank).was.called_with()
        end

        local function and_that_get_ava_rank_points_max_returns(points)
            ut_helper.stub_function(esoTERM_pvp, "get_ava_rank_points_max", points)
        end

        local function and_get_ava_rank_points_max_was_called_once_witch_cache()
            assert.spy(esoTERM_pvp.get_ava_rank_points_max).was.called_with()
        end

        local function when_on_ava_points_update_is_called_with(event, point, sound, diff)
            esoTERM_pvp.on_ava_points_update(event, point, sound, diff)
        end

        local function then_the_ava_properties_in_character_info_where_updated_no_rank_up()
            assert.is.equal(OLD_RANK, tl.CACHE.ava_rank)
            assert.is.equal(NEW_POINTS, tl.CACHE.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT, tl.CACHE.ava_rank_points_percent)
            assert.is.equal(NEW_GAIN, tl.CACHE.ap_gain)
        end

        local function then_the_ava_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_RANK, tl.CACHE.ava_rank)
            assert.is.equal(OLD_POINTS, tl.CACHE.ava_rank_points)
            assert.is.equal(OLD_POINTS_PCT, tl.CACHE.ava_rank_points_percent)
            assert.is.equal(OLD_GAIN, tl.CACHE.ap_gain)
        end

        local function then_the_ava_properties_in_character_info_where_updated_rank_up()
            assert.is.equal(NEW_RANK, tl.CACHE.ava_rank)
            assert.is.equal(NEW_POINTS_RANK_UP, tl.CACHE.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT_RANK_UP, tl.CACHE.ava_rank_points_percent)
            assert.is.equal(GAIN_RANK_UP, tl.CACHE.ap_gain)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, NEW_GAIN)

            then_the_ava_properties_in_character_info_where_updated_no_rank_up()
                and_esoTERM_output_stdout_was_called_with_ap_message()
        end)

        it("Zero gain.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_ZERO)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_esoTERM_output_ap_to_chat_tab_was_not_called()
        end)

        it("Negative gain.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_NEGATIVE)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_esoTERM_output_ap_to_chat_tab_was_not_called()
        end)

        it("Gain enough AP to rank up.", function()
            given_that_esoTERM_output_stdout_is_stubbed()
                and_that_get_ava_rank_returns(NEW_RANK)
                and_that_get_ava_rank_points_max_returns(NEW_POINTS_MAX)

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_RANK_UP)

            then_the_ava_properties_in_character_info_where_updated_rank_up()
                and_get_ava_rank_was_called_once_witch_cache()
                and_get_ava_rank_points_max_was_called_once_witch_cache()
                and_esoTERM_output_stdout_was_called_with_ap_message()
        end)
    end)
end)

-- vim:fdm=marker
