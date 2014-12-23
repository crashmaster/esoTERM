local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

local PLAYER = "player"

local A_BOOL = true
local B_BOOL = false
local A_INTEGER = 1111
local B_INTEGER = 2222

local VETERANNESS_1 = A_BOOL
local VETERANNESS_2 = B_BOOL
local LEVEL_1 = A_INTEGER
local LEVEL_2 = B_INTEGER
local LEVEL_XP_1 = A_INTEGER
local LEVEL_XP_2 = B_INTEGER
local LEVEL_XP_MAX_1 = A_INTEGER
local LEVEL_XP_MAX_2 = B_INTEGER
local LEVEL_XP_PERCENT = A_INTEGER
local LEVEL_XP_GAIN = A_INTEGER

local CACHE = esoTERM_pve.cache
local EVENT_REGISTER = esoTERM_pve.event_register

describe("Test cache initialization.", function()
    local results = {}

    local return_values_of_the_getter_stubs = {
        is_veteran = VETERANNESS_1,
        get_level = LEVEL_1,
        get_level_xp = LEVEL_XP_1,
        get_level_xp_max = LEVEL_XP_MAX_1,
        get_level_xp_percent = LEVEL_XP_PERCENT,
        get_xp_gain = LEVEL_XP_GAIN,
    }

    local expected_cached_values = {
        veteran = VETERANNESS_1,
        level = LEVEL_1,
        level_xp = LEVEL_XP_1,
        level_xp_max = LEVEL_XP_MAX_1,
        level_xp_percent = LEVEL_XP_PERCENT,
        xp_gain = LEVEL_XP_GAIN,
    }

    local function setup_getter_stubs()
        for getter, return_value in pairs(return_values_of_the_getter_stubs) do
            ut_helper.stub_function(esoTERM_pve, getter, return_value)
        end
    end

    setup(function()
        setup_getter_stubs()
    end)

    teardown(function()
        results = nil
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cache_is_empty()
        assert.is.equal(0, ut_helper.table_size(CACHE))
    end

    local function when_initialize_is_called()
        esoTERM_pve.initialize()
    end

    local function then_cache_is_no_longer_empty()
        assert.is_not.equal(0, ut_helper.table_size(CACHE))
    end

    local function and_cached_values_became_initialized()
        for cache_attribute, expected_value in pairs(expected_cached_values) do
            assert.is.equal(expected_value, CACHE[cache_attribute])
        end
    end

    local function and_getter_stubs_were_called_with_cache()
        for getter, _ in pairs(return_values_of_the_getter_stubs) do
            assert.spy(esoTERM_pve[getter]).was.called_with(CACHE)
        end
    end
    -- }}}

    it("PvE related data is initialized at startup.",
    function()
        given_that_cache_is_empty()

        when_initialize_is_called()

        then_cache_is_no_longer_empty()
            and_cached_values_became_initialized()
            and_getter_stubs_were_called_with_cache()
    end)
end)

describe("Test event handler initialization.", function()
    local addon_name = "esoTERM"
    local expected_register_params = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_expected_register_event_parameters_are_set_up()
        expected_register_params.experience_points_update = {
            addon_name = addon_name,
            event = EVENT_EXPERIENCE_UPDATE,
            callback = esoTERM_pve.on_experience_update
        }
        expected_register_params.level_update = {
            addon_name = addon_name,
            event = EVENT_LEVEL_UPDATE,
            callback = esoTERM_pve.on_level_update
        }
        expected_register_params.veteran_rank_update = {
            addon_name = addon_name,
            event = EVENT_VETERAN_RANK_UPDATE,
            callback = esoTERM_pve.on_level_update
        }
    end

    local function when_initialize_is_called()
        esoTERM_pve.initialize()
    end

    local function then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_params)
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

    local function and_event_handlers_are_active(active_event_handlers)
        for handler in pairs(active_event_handlers) do
            local active_event = EVENT_REGISTER[active_event_handlers[handler].event]
            assert.is.equal(true, active_event == true)
        end
    end
    -- }}}

    it("Register for events", function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_expected_register_event_parameters_are_set_up()

        when_initialize_is_called()

        then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
            and_event_handlers_are_active(expected_register_params)
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
        CACHE.veteran = nil
    end

    local function and_that_IsUnitVeteran_returns(veteranness)
        ut_helper.stub_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function when_is_veteran_is_called_with_cache()
        results.veteran = esoTERM_pve.is_veteran(CACHE)
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
            and_that_IsUnitVeteran_returns(VETERANNESS_1)

        when_is_veteran_is_called_with_cache()

        then_the_returned_character_veteranness_was(VETERANNESS_1)
            and_IsUnitVeteran_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is(veteranness)
        CACHE.veteran = veteranness
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
        given_that_cached_character_veteranness_is(VETERANNESS_1)
            and_that_IsUnitVeteran_returns(VETERANNESS_2)

        when_is_veteran_is_called_with_cache()

        then_the_returned_character_veteranness_was(VETERANNESS_1)
            and_IsUnitVeteran_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_is_not_set()
        CACHE.level = nil
    end

    local function and_that_eso_GetUnitLevel_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitLevel", level)
    end

    local function and_character_is_not_veteran()
        ut_helper.stub_function(esoTERM_pve, "is_veteran", false)
    end

    local function when_get_level_is_called_with_cache()
        results.level = esoTERM_pve.get_level(CACHE)
    end

    local function then_the_returned_level_was(level)
        assert.is.equal(level, results.level)
    end

    local function and_eso_GetUnitLevel_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitLevel).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_character_level_is_not_set()
            and_that_eso_GetUnitLevel_returns(LEVEL_1)
            and_character_is_not_veteran()

        when_get_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_eso_GetUnitLevel_was_called_once_with_player()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranRank_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranRank", level)
    end

    local function and_character_is_veteran()
        ut_helper.stub_function(esoTERM_pve, "is_veteran", true)
    end

    local function and_eso_GetUnitVeteranRank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranRank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL, when NOT CACHED.",
    function()
        given_that_cached_character_level_is_not_set()
            and_that_eso_GetUnitVeteranRank_returns(LEVEL_1)
            and_character_is_veteran()

        when_get_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_eso_GetUnitVeteranRank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_is(level)
        CACHE.level = level
    end

    local function and_that_eso_GetUnitLevel_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitLevel", level)
    end

    local function and_is_veteran_was_not_called()
        assert.spy(esoTERM_pve.is_veteran).was_not.called()
    end

    local function and_eso_GetUnitLevel_was_not_called()
        assert.spy(GLOBAL.GetUnitLevel).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_character_level_is(LEVEL_1)
            and_that_eso_GetUnitLevel_returns(LEVEL_2)
            and_character_is_not_veteran()

        when_get_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_is_veteran_was_not_called()
            and_eso_GetUnitLevel_was_not_called()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranRank_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranRank", level)
    end

    local function and_eso_GetUnitVeteranRank_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranRank).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL, when CACHED.",
    function()
        given_that_cached_character_level_is(LEVEL_1)
            and_that_eso_GetUnitVeteranRank_returns(LEVEL_2)
            and_character_is_veteran()

        when_get_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_is_veteran_was_not_called()
            and_eso_GetUnitVeteranRank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is_not_set()
        CACHE.level_xp = nil
    end

    local function and_that_eso_GetUnitXP_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXP", xp)
    end

    local function when_get_level_xp_is_called_with_cache()
        results.level_xp = esoTERM_pve.get_level_xp(CACHE)
    end

    local function then_the_returned_level_xp_was(xp)
        assert.is.equal(xp, results.level_xp)
    end

    local function and_eso_GetUnitXP_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXP).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_is_not_set()
            and_that_eso_GetUnitXP_returns(LEVEL_XP_1)
            and_character_is_not_veteran()

        when_get_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_eso_GetUnitXP_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is(xp)
        CACHE.level_xp = xp
    end

    local function and_that_eso_GetUnitXP_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXP", xp)
    end

    local function and_eso_GetUnitXP_was_not_called()
        assert.spy(GLOBAL.GetUnitXP).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP, when CACHED.",
    function()
        given_that_cached_character_level_xp_is(LEVEL_XP_1)
            and_that_eso_GetUnitXP_returns(LEVEL_XP_2)
            and_character_is_not_veteran()

        when_get_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_is_veteran_was_not_called()
            and_eso_GetUnitXP_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is_not_set()
        CACHE.level_xp_max = nil
    end

    local function and_that_eso_GetUnitXPMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXPMax", xp)
    end

    local function when_get_level_xp_max_is_called_with_cache()
        results.level_xp_max = esoTERM_pve.get_level_xp_max(CACHE)
    end

    local function then_the_returned_level_xp_max_was(xp)
        assert.is.equal(xp, results.level_xp_max)
    end

    local function and_eso_GetUnitXPMax_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXPMax).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_max_is_not_set()
            and_that_eso_GetUnitXPMax_returns(LEVEL_XP_MAX_1)
            and_character_is_not_veteran()

        when_get_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_eso_GetUnitXPMax_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is(xp)
        CACHE.level_xp_max = xp
    end

    local function and_that_eso_GetUnitXPMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXPMax", xp)
    end

    local function and_eso_GetUnitXPMax_was_not_called()
        assert.spy(GLOBAL.GetUnitXPMax).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX, when CACHED.",
    function()
        given_that_cached_character_level_xp_max_is(LEVEL_XP_MAX_1)
            and_that_eso_GetUnitXPMax_returns(LEVEL_XP_MAX_2)
            and_character_is_not_veteran()

        when_get_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_is_veteran_was_not_called()
            and_eso_GetUnitXPMax_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is_not_set()
        CACHE.level_xp_percent = nil
    end

    local function and_that_get_level_xp_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp", xp)
    end

    local function and_that_get_level_xp_max_returns(xp)
        ut_helper.stub_function(esoTERM_pve, "get_level_xp_max", xp)
    end

    local function when_get_level_xp_percent_is_called_with_cache()
        results.level_xp_percent = esoTERM_pve.get_level_xp_percent(CACHE)
    end

    local function then_the_returned_level_xp_percent_was(level_xp_percent)
        assert.is.equal(level_xp_percent, results.level_xp_percent)
    end

    local function and_get_level_xp_was_called_with_cache()
        assert.spy(esoTERM_pve.get_level_xp).was.called_with(CACHE)
    end

    local function and_get_level_xp_max_was_called_with_cache()
        assert.spy(esoTERM_pve.get_level_xp_max).was.called_with(CACHE)
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_level_xp_returns(82)
            and_that_get_level_xp_max_returns(500)

        when_get_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(16.4)
            and_get_level_xp_was_called_with_cache()
            and_get_level_xp_max_was_called_with_cache()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED and LEVEL-XP MAX is 0.",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_level_xp_returns(100)
            and_that_get_level_xp_max_returns(0)

        when_get_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(0)
            and_get_level_xp_was_called_with_cache()
            and_get_level_xp_max_was_called_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is(percent)
        CACHE.level_xp_percent = percent
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
        given_that_cached_character_level_xp_percent_is(LEVEL_XP_PERCENT)
            and_that_get_level_xp_max_returns(LEVEL_XP_MAX_1)
            and_that_get_level_xp_returns(LEVEL_XP_1)

        when_get_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(LEVEL_XP_PERCENT)
            and_get_level_xp_max_was_not_called()
            and_get_level_xp_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is_not_set()
        CACHE.xp_gain = nil
    end

    local function when_get_xp_gain_is_called_with_cache()
        results.xp_gain = esoTERM_pve.get_xp_gain(CACHE)
    end

    local function then_the_returned_level_xp_gain_was(gain)
        assert.is.equal(gain, results.xp_gain)
    end
    -- }}}

    it("Query CHARACTER XP-GAIN, when NOT CACHED.",
    function()
        given_that_cached_character_level_xp_gain_is_not_set()

        when_get_xp_gain_is_called_with_cache()

        then_the_returned_level_xp_gain_was(0)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is(gain)
        CACHE.xp_gain = gain
    end
    -- }}}

    it("Query CHARACTER XP-GAIN, when CACHED.",
    function()
        given_that_cached_character_level_xp_gain_is(LEVEL_XP_GAIN)

        when_get_xp_gain_is_called_with_cache()

        then_the_returned_level_xp_gain_was(LEVEL_XP_GAIN)
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"
    local UNIT = "player"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function get_xp_message()
        return string.format("Gained %d XP (%.2f%%)",
                             CACHE.xp_gain,
                             CACHE.level_xp_percent)
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
            CACHE.level_xp = OLD_XP
            CACHE.level_xp_max = OLD_XP_MAX
            CACHE.level_xp_percent = OLD_XP_PCT
            CACHE.xp_gain = OLD_XP_GAIN
        end)

        -- {{{
        local function when_on_experience_update_is_called_with(event, unit, xp, xp_max, reason)
            esoTERM_pve.on_experience_update(event, unit, xp, xp_max, reason)
        end

        local function then_the_xp_properties_in_character_info_where_updated()
            assert.is.equal(NEW_XP, CACHE.level_xp)
            assert.is.equal(NEW_XP_MAX, CACHE.level_xp_max)
            assert.is.equal(NEW_XP_PCT, CACHE.level_xp_percent)
            assert.is.equal(NEW_XP - OLD_XP, CACHE.xp_gain)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
            assert.is.equal(NEW_XP_LVL_UP, CACHE.level_xp)
            assert.is.equal(OLD_XP_MAX, CACHE.level_xp_max)
            assert.is.equal(100, CACHE.level_xp_percent)
            assert.is.equal(NEW_XP_LVL_UP - OLD_XP, CACHE.xp_gain)
        end
        -- }}}

        it("If xp > level xp maximum, then 100%.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP_LVL_UP, OLD_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_XP, CACHE.level_xp)
            assert.is.equal(OLD_XP_MAX, CACHE.level_xp_max)
            assert.is.equal(OLD_XP_PCT, CACHE.level_xp_percent)
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
            assert.is.equal(NEW_XP, CACHE.level_xp)
            assert.is.equal(NEW_XP_MAX, CACHE.level_xp_max)
            assert.is.equal(NEW_XP_PCT, CACHE.level_xp_percent)
            assert.is.equal(OLD_XP_GAIN, CACHE.xp_gain)
        end
        -- }}}
        it("If reason is incorrect (level up drift handling).", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, -1)

            then_the_xp_properties_in_character_info_where_partly_updated()
                and_esoTERM_output_stdout_was_called_with_xp_message()
        end)

        it("If total maximum xp reached.", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, 0, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_esoTERM_output_stdout_was_not_called()
        end)
    end)

    describe("The on level update event handler.", function()
        local OLD_LEVEL = 1
        local NEW_LEVEL = 2

        before_each(function()
            CACHE.level = OLD_LEVEL
        end)

        -- {{{
        local function when_on_level_update_is_called_with(event, unit, level)
            esoTERM_pve.on_level_update(event, unit, level)
        end

        local function then_the_level_property_in_character_info_was_updated()
            assert.is.equal(NEW_LEVEL, CACHE.level)
        end
        -- }}}

        it("Happy flow.", function()
            when_on_level_update_is_called_with(EVENT, UNIT, NEW_LEVEL)

            then_the_level_property_in_character_info_was_updated()
        end)

        -- {{{
        local function then_the_level_property_in_character_info_was_not_updated()
            assert.is.equal(OLD_LEVEL, CACHE.level)
        end
        -- }}}

        it("If unit incorrect.", function()
            when_on_level_update_is_called_with(EVENT, "foo", NEW_LEVEL)

            then_the_level_property_in_character_info_was_not_updated()
        end)
    end)
end)

-- vim:fdm=marker
