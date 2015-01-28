local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/test_esoTERM_pvp_library")

describe("Test module.", function()
    local name = "esoTERM-pvp"

    -- {{{
    local function when_module_name_is_get_then_expected_name_is_returned(name)
        assert.is.equal(name, esoTERM_pvp.module_name)
    end
    -- }}}

    it("Module is called: esoTERM-pvp.",
    function()
        when_module_name_is_get_then_expected_name_is_returned(name)
    end)
end)

describe("Test initialization.", function()
    local return_values_of_the_getter_stubs = {
        get_ava_points = tl.AVA_RANK_1,
        get_ava_rank = tl.AVA_RANK_1,
        get_ava_sub_rank = tl.AVA_SUB_RANK_1,
        get_ava_rank_name = tl.AVA_RANK_NAME_1,
        get_ava_rank_points_lb = tl.AVA_RANK_POINTS_LB_1,
        get_ava_rank_points_ub = tl.AVA_RANK_POINTS_UB_1,
        get_ava_rank_points = tl.AVA_RANK_POINTS_1,
        get_ava_rank_points_max = tl.AVA_RANK_POINTS_MAX_1,
        get_ava_rank_points_percent = tl.AVA_RANK_POINTS_PERCENT,
        get_ap_gain = tl.AVA_POINTS_GAIN,
    }
    local expected_cached_values = {
        ava_points = tl.AVA_POINTS_1,
        ava_rank = tl.AVA_RANK_1,
        ava_sub_rank = tl.AVA_SUB_RANK_1,
        ava_rank_name = tl.AVA_RANK_NAME_1,
        ava_rank_points_lb = tl.AVA_RANK_POINTS_LB_1,
        ava_rank_points_ub = tl.AVA_RANK_POINTS_UB_1,
        ava_rank_points = tl.AVA_RANK_POINTS_1,
        ava_rank_points_max = tl.AVA_RANK_POINTS_MAX_1,
        ava_rank_points_percent = tl.AVA_RANK_POINTS_PERCENT,
        ap_gain = tl.AVA_POINTS_GAIN,
    }

    local expected_register_params = {}

    local function setup_getter_stubs()
        for getter, return_value in pairs(return_values_of_the_getter_stubs) do
            ut_helper.stub_function(esoTERM_pvp, getter, return_value)
        end
    end

    setup(function()
        setup_getter_stubs()
    end)

    after_each(function()
        expected_register_params = nil
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cache_is_empty()
        assert.is.equal(0, ut_helper.table_size(tl.CACHE))
    end

    local function and_that_register_for_event_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
    end

    local function and_that_expected_register_event_parameters_are_set_up()
        expected_register_params.ava_xp_update = {
            local_register = tl.EVENT_REGISTER,
            event = EVENT_ALLIANCE_POINT_UPDATE,
            callback = esoTERM_pvp.on_ava_points_update
        }
    end

    local function and_that_register_module_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_module", nil)
    end

    local function when_initialize_is_called()
        esoTERM_pvp.initialize()
    end

    local function then_cache_is_no_longer_empty()
        assert.is_not.equal(0, ut_helper.table_size(tl.CACHE))
    end

    local function and_cached_values_became_initialized()
        for cache_attribute, expected_value in pairs(expected_cached_values) do
            assert.is.equal(expected_value, tl.CACHE[cache_attribute])
        end
    end

    local function and_getter_stubs_were_called()
        for getter, _ in pairs(return_values_of_the_getter_stubs) do
            assert.spy(esoTERM_pvp[getter]).was.called_with()
        end
    end

    local function and_register_for_event_was_called_with(expected_params)
        assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(esoTERM_common.register_for_event).was.called_with(
                expected_params[param].local_register,
                expected_params[param].event,
                expected_params[param].callback
            )
            assert.is_not.equal(nil, expected_params[param].callback)
        end
    end

    local function and_register_module_was_called()
        assert.spy(esoTERM_common.register_module).was.called_with(
            esoTERM.module_register, esoTERM_pvp)
    end

    local function and_module_is_active()
        assert.is.equal(true, esoTERM_pvp.is_active)
    end
    -- }}}

    it("Cached PvP data is updated and subscribed for events.",
    function()
        given_that_cache_is_empty()
            and_that_register_for_event_is_stubbed()
            and_that_expected_register_event_parameters_are_set_up()
            and_that_register_module_is_stubbed()

        when_initialize_is_called()

        then_cache_is_no_longer_empty()
            and_cached_values_became_initialized()
            and_getter_stubs_were_called()
            and_register_for_event_was_called_with(expected_register_params)
            and_register_module_was_called()
            and_module_is_active()
    end)
end)

describe("Test deactivate.", function()
    -- {{{
    local function given_that_module_is_active()
        esoTERM_pvp.is_active = true
    end

    local function and_that_unregister_from_all_events_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "unregister_from_all_events", nil)
    end

    local function when_deactivate_for_the_module_is_called()
        esoTERM_pvp.deactivate()
    end

    local function then_unregister_from_all_events_was_called()
        assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(tl.EVENT_REGISTER)
    end

    local function and_module_becomes_inactive()
        assert.is.equal(false, esoTERM_pvp.is_active)
    end
    -- }}}

    it("Unsubscribe from active events and set activeness to false.",
    function()
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_for_the_module_is_called()

        then_unregister_from_all_events_was_called()
            and_module_becomes_inactive()
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

    local function and_that_eso_GetUnitAvARankPoints_returns(points)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARankPoints", points)
    end

    local function when_get_ava_points_is_called_with_cache()
        results.ava_points = esoTERM_pvp.get_ava_points()
    end

    local function then_the_returned_character_ava_points_was(points)
        assert.is.equal(points, results.ava_points)
    end

    local function and_eso_GetUnitAvARankPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_points_is_not_set()
            and_that_eso_GetUnitAvARankPoints_returns(tl.AVA_POINTS_1)

        when_get_ava_points_is_called_with_cache()

        then_the_returned_character_ava_points_was(tl.AVA_POINTS_1)
            and_eso_GetUnitAvARankPoints_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_is(points)
        tl.CACHE.ava_points = points
    end

    local function and_eso_GetUnitAvARankPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_points_is(tl.AVA_POINTS_1)
            and_that_eso_GetUnitAvARankPoints_returns(tl.AVA_POINTS_2)

        when_get_ava_points_is_called_with_cache()

        then_the_returned_character_ava_points_was(tl.AVA_POINTS_1)
            and_eso_GetUnitAvARankPoints_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is_not_set()
        tl.CACHE.ava_rank = nil
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_ava_rank_is_called_with_cache()
        results.ava_rank = esoTERM_pvp.get_ava_rank()
    end

    local function then_the_returned_character_ava_rank_was(rank)
        assert.is.equal(rank, results.ava_rank)
    end

    local function and_eso_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-RANK, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_is_not_set()
            and_that_eso_GetUnitAvARank_returns(tl.AVA_RANK_1, tl.AVA_SUB_RANK_1)

        when_get_ava_rank_is_called_with_cache()

        then_the_returned_character_ava_rank_was(tl.AVA_RANK_1)
            and_eso_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is(rank)
        tl.CACHE.ava_rank = rank
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK, when CACHED.",
    function()
        given_that_cached_character_ava_rank_is(tl.AVA_RANK_1)
            and_that_eso_GetUnitAvARank_returns(tl.AVA_RANK_2, tl.AVA_SUB_RANK_2)

        when_get_ava_rank_is_called_with_cache()

        then_the_returned_character_ava_rank_was(tl.AVA_RANK_1)
            and_eso_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is_not_set()
        tl.CACHE.ava_sub_rank = nil
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_ava_sub_rank_is_called_with_cache()
        results.ava_sub_rank = esoTERM_pvp.get_ava_sub_rank()
    end

    local function then_the_returned_character_ava_sub_rank_was(sub_rank)
        assert.is.equal(sub_rank, results.ava_sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA-SUB-RANK, when NOT CACHED.",
    function()
        given_that_cached_character_ava_sub_rank_is_not_set()
            and_that_eso_GetUnitAvARank_returns(tl.AVA_RANK_1, tl.AVA_SUB_RANK_1)

        when_get_ava_sub_rank_is_called_with_cache()

        then_the_returned_character_ava_sub_rank_was(tl.AVA_SUB_RANK_1)
            and_eso_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is(sub_rank)
        tl.CACHE.ava_sub_rank = sub_rank
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-SUB-RANK, when CACHED.",
    function()
        given_that_cached_character_ava_sub_rank_is(tl.AVA_SUB_RANK_1)
            and_that_eso_GetUnitAvARank_returns(tl.AVA_RANK_2, tl.AVA_SUB_RANK_2)

        when_get_ava_sub_rank_is_called_with_cache()

        then_the_returned_character_ava_sub_rank_was(tl.AVA_SUB_RANK_1)
            and_eso_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is_not_set()
        tl.CACHE.ava_rank_name = nil
    end

    local function and_that_eso_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_that_get_gender_returns(gender)
        ut_helper.stub_function(esoTERM_char, "get_gender", gender)
    end

    local function and_that_get_ava_rank_returns(rank)
        ut_helper.stub_function(esoTERM_pvp, "get_ava_rank", rank)
    end

    local function when_get_ava_rank_name_is_called_with_cache()
        results.ava_rank_name = esoTERM_pvp.get_ava_rank_name()
    end

    local function then_the_returned_character_ava_rank_name_was(rank)
        assert.is.equal(rank, results.ava_rank_name)
    end

    local function and_eso_GetAvARankName_was_called_once_with(gender, rank)
        assert.spy(GLOBAL.GetAvARankName).was.called_with(gender, rank)
    end

    local function and_get_gender_was_called_once_with_cache()
        assert.spy(esoTERM_char.get_gender).was.called_with()
    end

    local function and_get_ava_rank_was_called_once_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK-NAME, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_name_is_not_set()
            and_that_eso_GetAvARankName_returns(tl.AVA_RANK_NAME_1)
            and_that_get_gender_returns(GENDER_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)

        when_get_ava_rank_name_is_called_with_cache()

        then_the_returned_character_ava_rank_name_was(tl.AVA_RANK_NAME_1)
            and_eso_GetAvARankName_was_called_once_with(GENDER_1, tl.AVA_RANK_1)
            and_get_gender_was_called_once_with_cache()
            and_get_ava_rank_was_called_once_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is(name)
        tl.CACHE.ava_rank_name = name
    end

    local function and_that_eso_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_eso_GetAvARankName_was_not_called()
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
            and_that_eso_GetAvARankName_returns(tl.AVA_RANK_NAME_2)
            and_that_get_gender_returns(GENDER_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)

        when_get_ava_rank_name_is_called_with_cache()

        then_the_returned_character_ava_rank_name_was(tl.AVA_RANK_NAME_1)
            and_eso_GetAvARankName_was_not_called()
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

    local function when_get_ava_rank_points_is_called_with_cache()
        results.ava_rank_points = esoTERM_pvp.get_ava_rank_points()
    end

    local function then_the_returned_character_ava_rank_points_was(points)
        assert.is.equal(points, results.ava_rank_points)
    end

    local function and_get_ava_rank_was_called_once_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank).was.called_with()
    end

    local function and_get_ava_points_was_called_once_with_cache()
        assert.spy(esoTERM_pvp.get_ava_points).was.called_with()
    end

    local function and_get_ava_rank_points_lb_was_called_once_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank_points_lb).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_is_not_set()
            and_that_get_ava_points_returns(150)
            and_that_get_ava_rank_points_lb_returns(100)

        when_get_ava_rank_points_is_called_with_cache()

        then_the_returned_character_ava_rank_points_was(50)
            and_get_ava_points_was_called_once_with_cache()
            and_get_ava_rank_points_lb_was_called_once_with_cache()
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

        when_get_ava_rank_points_is_called_with_cache()

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

    local function when_get_ava_rank_points_max_is_called_with_cache()
        results.ava_rank_points_max = esoTERM_pvp.get_ava_rank_points_max()
    end

    local function then_the_returned_character_ava_rank_points_max_was(points)
        assert.is.equal(points, results.ava_rank_points_max)
    end

    local function and_get_ava_rank_points_ub_was_called_once_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank_points_ub).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS MAX, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_max_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_get_ava_rank_points_lb_returns(tl.AVA_RANK_POINTS_LB_1)
            and_that_get_ava_rank_points_ub_returns(tl.AVA_RANK_POINTS_UB_1)

        when_get_ava_rank_points_max_is_called_with_cache()

        then_the_returned_character_ava_rank_points_max_was(
                                tl.AVA_RANK_POINTS_UB_1 - tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_points_lb_was_called_once_with_cache()
            and_get_ava_rank_points_ub_was_called_once_with_cache()
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

        when_get_ava_rank_points_max_is_called_with_cache()

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

    local function when_get_ava_rank_points_percent_is_called_with_cache()
        results.rank_points_percent = esoTERM_pvp.get_ava_rank_points_percent()
    end

    local function then_the_returned_ava_rank_points_percent_was(rank_points_percent)
        assert.is.equal(rank_points_percent, results.rank_points_percent)
    end

    local function and_get_ava_rank_points_was_called_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank_points).was.called_with()
    end

    local function and_get_ava_rank_points_max_was_called_with_cache()
        assert.spy(esoTERM_pvp.get_ava_rank_points_max).was.called_with()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS PERCENT, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_percent_is_not_set()
            and_that_get_ava_rank_points_returns(82)
            and_that_get_ava_rank_points_max_returns(500)

        when_get_ava_rank_points_percent_is_called_with_cache()

        then_the_returned_ava_rank_points_percent_was(16.4)
            and_get_ava_rank_points_was_called_with_cache()
            and_get_ava_rank_points_max_was_called_with_cache()
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

        when_get_ava_rank_points_percent_is_called_with_cache()

        then_the_returned_ava_rank_points_percent_was(tl.AVA_RANK_POINTS_PERCENT)
            and_get_ava_rank_points_max_was_not_called()
            and_get_ava_rank_points_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ap_gain_is_not_set()
        tl.CACHE.ap_gain = nil
    end

    local function when_get_ap_gain_is_called_with_cache()
        results.ap_gain = esoTERM_pvp.get_ap_gain()
    end

    local function then_the_returned_ap_gain_was(gain)
        assert.is.equal(gain, results.ap_gain)
    end
    -- }}}

    it("Query CHARACTER AVA-POINTS GAIN, when NOT CACHED.",
    function()
        given_that_cached_character_ap_gain_is_not_set()

        when_get_ap_gain_is_called_with_cache()

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

        when_get_ap_gain_is_called_with_cache()

        then_the_returned_ap_gain_was(tl.AVA_POINTS_GAIN)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is_not_set()
        tl.CACHE.ava_rank_points_lb = nil
    end

    local function and_that_eso_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_ava_rank_points_lb_is_called_with_cache()
        results.ava_rank_points_lb = esoTERM_pvp.get_ava_rank_points_lb()
    end

    local function then_the_returned_character_ava_rank_points_lb_was(point)
        assert.is.equal(point, results.ava_rank_points_lb)
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_lb_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_LB_1)

        when_get_ava_rank_points_lb_is_called_with_cache()

        then_the_returned_character_ava_rank_points_lb_was(tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_was_called_once_with_cache()
            and_eso_GetNumPointsNeededForAvARank_was_called_once_with(tl.AVA_RANK_1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is(point)
        tl.CACHE.ava_rank_points_lb = point
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_rank_points_lb_is(tl.AVA_RANK_POINTS_LB_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_LB_2)

        when_get_ava_rank_points_lb_is_called_with_cache()

        then_the_returned_character_ava_rank_points_lb_was(tl.AVA_RANK_POINTS_LB_1)
            and_get_ava_rank_was_not_called()
            and_eso_GetNumPointsNeededForAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is_not_set()
        tl.CACHE.ava_rank_points_ub = nil
    end

    local function and_that_eso_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_ava_rank_points_ub_is_called_with_cache()
        results.ava_rank_points_ub = esoTERM_pvp.get_ava_rank_points_ub()
    end

    local function then_the_returned_character_ava_rank_points_ub_was(point)
        assert.is.equal(point, results.ava_rank_points_ub)
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS, when NOT CACHED.",
    function()
        given_that_cached_character_ava_rank_points_ub_is_not_set()
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_UB_1)

        when_get_ava_rank_points_ub_is_called_with_cache()

        then_the_returned_character_ava_rank_points_ub_was(tl.AVA_RANK_POINTS_UB_1)
            and_get_ava_rank_was_called_once_with_cache()
            and_eso_GetNumPointsNeededForAvARank_was_called_once_with(tl.AVA_RANK_1 + 1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is(point)
        tl.CACHE.ava_rank_points_ub = point
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS, when CACHED.",
    function()
        given_that_cached_character_ava_rank_points_ub_is(tl.AVA_RANK_POINTS_UB_1)
            and_that_get_ava_rank_returns(tl.AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(tl.AVA_RANK_POINTS_UB_2)

        when_get_ava_rank_points_ub_is_called_with_cache()

        then_the_returned_character_ava_rank_points_ub_was(tl.AVA_RANK_POINTS_UB_1)
            and_get_ava_rank_was_not_called()
            and_eso_GetNumPointsNeededForAvARank_was_not_called()
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
