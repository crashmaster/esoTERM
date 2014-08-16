local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")


describe("Test event handler initialization", function()
    local expected_register_params = nil

    setup(function()
        expected_register_params = {}
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_event_manager_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_pinfo_event_handler_on_experience_update_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "on_experience_update", nil)
    end

    local function and_expected_register_event_parameters_is_set_up()
        expected_register_params.experience_points_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_EXPERIENCE_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.veteran_points_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_VETERAN_POINTS_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.level_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_LEVEL_UPDATE,
            callback = pinfo_event_handler.on_level_update
        }
        expected_register_params.veteran_rank_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_VETERAN_RANK_UPDATE,
            callback = pinfo_event_handler.on_level_update
        }
        expected_register_params.ava_xp_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_ALLIANCE_POINT_UPDATE,
            callback = pinfo_event_handler.on_ava_points_update
        }
    end

    local function when_initialize_is_called_with()
        pinfo_event_handler.initialize()
    end

    local function than_event_manager_RegisterForEvent_was_called_with(expected_params)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER,
                expected_params[param].addon_name,
                expected_params[param].event,
                expected_params[param].callback
            )
        end
    end
    -- }}}

    it("Register for events",
    function()
        given_that_event_manager_RegisterForEvent_is_stubbed()
            and_pinfo_event_handler_on_experience_update_is_stubbed()
            and_expected_register_event_parameters_is_set_up()

        when_initialize_is_called_with()

        than_event_manager_RegisterForEvent_was_called_with(expected_register_params)
    end)
end)

describe("Test event handlers", function()
    local EVENT = nil
    local UNIT = "player"

    -- {{{
    local function given_that_pinfo_output_xp_to_debug_is_stubbed()
        ut_helper.stub_function(pinfo_output, "xp_to_debug", nil)
    end

    local function and_pinfo_output_xp_to_debug_was_called_once()
        assert.spy(pinfo_output.xp_to_debug).was.called_with()
    end

    local function and_pinfo_output_xp_to_debug_was_not_called()
        assert.spy(pinfo_output.xp_to_debug).was_not.called()
    end

    local function given_that_pinfo_output_ap_to_debug_is_stubbed()
        ut_helper.stub_function(pinfo_output, "ap_to_debug", nil)
    end

    local function and_pinfo_output_ap_to_debug_was_called_once()
        assert.spy(pinfo_output.ap_to_debug).was.called_with()
    end

    local function and_pinfo_output_ap_to_debug_was_not_called()
        assert.spy(pinfo_output.ap_to_debug).was_not.called()
    end
    -- }}}

    describe("Test the on experience update event handler", function()
        local cache = pinfo.CHARACTER_INFO

        local REASON = 0
        local OLD_XP = 100
        local OLD_XP_MAX = 1000
        local OLD_XP_PCT = OLD_XP * 100 / OLD_XP_MAX
        local OLD_XP_GAIN = 0
        local NEW_XP = 200
        local NEW_XP_MAX = 2000
        local NEW_XP_PCT = NEW_XP * 100 / NEW_XP_MAX

        before_each(function()
            cache.level_xp = OLD_XP
            cache.level_xp_max = OLD_XP_MAX
            cache.level_xp_percent = OLD_XP_PCT
            cache.xp_gain = OLD_XP_GAIN
        end)

        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        -- {{{
        local function when_on_experience_update_is_called_with(event, unit, xp, xp_max, reason)
            pinfo_event_handler.on_experience_update(event, unit, xp, xp_max, reason)
        end

        local function then_the_xp_properties_in_character_info_where_updated()
            assert.is.equal(NEW_XP, cache.level_xp)
            assert.is.equal(NEW_XP_MAX, cache.level_xp_max)
            assert.is.equal(NEW_XP_PCT, cache.level_xp_percent)
            assert.is.equal(NEW_XP - OLD_XP, cache.xp_gain)
        end
        -- }}}

        it("On experience update, happy flow",
        function()
            given_that_pinfo_output_xp_to_debug_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated()
                and_pinfo_output_xp_to_debug_was_called_once()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_XP, cache.level_xp)
            assert.is.equal(OLD_XP_MAX, cache.level_xp_max)
            assert.is.equal(OLD_XP_PCT, cache.level_xp_percent)
        end
        -- }}}

        it("On experience update, incorrect unit",
        function()
            given_that_pinfo_output_xp_to_debug_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, "foo", NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_pinfo_output_xp_to_debug_was_not_called()
        end)

        it("On experience update, incorrect reason",
        function()
            given_that_pinfo_output_xp_to_debug_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, -1)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_pinfo_output_xp_to_debug_was_not_called()
        end)

        it("On experience update, total maximum xp reached",
        function()
            given_that_pinfo_output_xp_to_debug_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, 0, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_pinfo_output_xp_to_debug_was_not_called()
        end)
    end)

    describe("Test the on level update event handler", function()
        local cache = pinfo.CHARACTER_INFO

        local OLD_LEVEL = 1
        local NEW_LEVEL = 2

        before_each(function()
            cache.level = OLD_LEVEL
        end)

        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        -- {{{
        local function when_on_level_update_is_called_with(event, unit, level)
            pinfo_event_handler.on_level_update(event, unit, level)
        end

        local function then_the_level_property_in_character_info_was_updated()
            assert.is.equal(NEW_LEVEL, cache.level)
        end
        -- }}}

        it("On level update, happy flow",
        function()
            when_on_level_update_is_called_with(EVENT, UNIT, NEW_LEVEL)

            then_the_level_property_in_character_info_was_updated()
        end)

        -- {{{
        local function then_the_level_property_in_character_info_was_not_updated()
            assert.is.equal(OLD_LEVEL, cache.level)
        end
        -- }}}

        it("On level update, incorrect unit",
        function()
            when_on_level_update_is_called_with(EVENT, "foo", NEW_LEVEL)

            then_the_level_property_in_character_info_was_not_updated()
        end)
    end)

    describe("Test the on AvA points update event handler", function()
        local cache = pinfo.CHARACTER_INFO

        local POINT = nil
        local SOUND = nil
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
            cache.ava_rank = OLD_RANK
            cache.ava_rank_points = OLD_POINTS
            cache.ava_rank_points_max = OLD_POINTS_MAX
            cache.ava_rank_points_percent = OLD_POINTS_PCT
            cache.ava_points_gain = OLD_GAIN
        end)

        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        -- {{{
        local function and_that_get_character_ava_rank_returns(rank)
            ut_helper.stub_function(pinfo_char, "get_character_ava_rank", rank)
        end

        local function and_get_character_ava_rank_was_called_once_witch_cache()
            assert.spy(pinfo_char.get_character_ava_rank).was.called_with(cache)
        end

        local function and_that_get_character_ava_rank_points_max_returns(points)
            ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_max", points)
        end

        local function and_get_character_ava_rank_points_max_was_called_once_witch_cache()
            assert.spy(pinfo_char.get_character_ava_rank_points_max).was.called_with(cache)
        end

        local function when_on_ava_points_update_is_called_with(event, point, sound, diff)
            pinfo_event_handler.on_ava_points_update(event, point, sound, diff)
        end

        local function then_the_ava_properties_in_character_info_where_updated_no_rank_up()
            assert.is.equal(OLD_RANK, cache.ava_rank)
            assert.is.equal(NEW_POINTS, cache.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT, cache.ava_rank_points_percent)
            assert.is.equal(NEW_GAIN, cache.ava_points_gain)
        end

        local function then_the_ava_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_RANK, cache.ava_rank)
            assert.is.equal(OLD_POINTS, cache.ava_rank_points)
            assert.is.equal(OLD_POINTS_PCT, cache.ava_rank_points_percent)
            assert.is.equal(OLD_GAIN, cache.ava_points_gain)
        end

        local function then_the_ava_properties_in_character_info_where_updated_rank_up()
            assert.is.equal(NEW_RANK, cache.ava_rank)
            assert.is.equal(NEW_POINTS_RANK_UP, cache.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT_RANK_UP, cache.ava_rank_points_percent)
            assert.is.equal(GAIN_RANK_UP, cache.ava_points_gain)
        end
        -- }}}

        it("On AvA points update, happy flow",
        function()
            given_that_pinfo_output_ap_to_debug_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, NEW_GAIN)

            then_the_ava_properties_in_character_info_where_updated_no_rank_up()
                and_pinfo_output_ap_to_debug_was_called_once()
        end)

        it("On AvA points update, zero gain",
        function()
            given_that_pinfo_output_ap_to_debug_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_ZERO)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_pinfo_output_ap_to_debug_was_not_called()
        end)

        it("On AvA points update, negative gain",
        function()
            given_that_pinfo_output_ap_to_debug_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_NEGATIVE)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_pinfo_output_ap_to_debug_was_not_called()
        end)

        it("On AvA points update, gain enough to rank up",
        function()
            given_that_pinfo_output_ap_to_debug_is_stubbed()
                and_that_get_character_ava_rank_returns(NEW_RANK)
                and_that_get_character_ava_rank_points_max_returns(NEW_POINTS_MAX)

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_RANK_UP)

            then_the_ava_properties_in_character_info_where_updated_rank_up()
                and_get_character_ava_rank_was_called_once_witch_cache()
                and_get_character_ava_rank_points_max_was_called_once_witch_cache()
                and_pinfo_output_ap_to_debug_was_called_once()
        end)
    end)
end)

-- vim:fdm=marker
