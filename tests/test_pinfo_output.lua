local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G
local PLAYER = "player"

describe("Test output initialization", function()
    local expected_register_params = {}
    local expected_new_params = {}

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

    local function and_pinfo_output_on_player_activated_is_stubbed()
        ut_helper.stub_function(pinfo_output, "on_player_activated", nil)
    end

    local function and_expected_register_event_parameter_is_set_up()
        expected_register_params.experience_points_update = {
            addon_name = pinfo.ADDON_NAME,
            event = EVENT_PLAYER_ACTIVATED,
            callback = pinfo_output.on_player_activated
        }
    end

    local function when_initialize_is_called()
        pinfo_output.initialize()
    end

    local function than_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_params)
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

    it("Register for player activated event",
    function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_pinfo_output_on_player_activated_is_stubbed()
            and_expected_register_event_parameter_is_set_up()

        when_initialize_is_called()

        than_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
    end)

    -- {{{
    local function given_that_ZO_SavedVars_New_is_stubbed()
        ut_helper.stub_function(ZO_SavedVars, "New", nil)
    end

    local function and_expected_saved_vars_new_is_set_up()
        expected_new_params.chat_saved_settings = {
            table_name = "pinfo_saved_variables",
            version = 1,
            namespace = nil,
            default = {chat_tab_number = 1}
        }
    end

    local function than_ZO_SavedVars_New_was_called_with(expected_params)
        assert.spy(ZO_SavedVars.New).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(ZO_SavedVars.New).was.called_with(
                ZO_SavedVars,
                expected_params[param].table_name,
                expected_params[param].version,
                expected_params[param].namespace,
                expected_params[param].default
            )
        end
    end
    -- }}}

    it("Saved variables loaded",
    function()
        given_that_ZO_SavedVars_New_is_stubbed()
            and_expected_saved_vars_new_is_set_up()

        when_initialize_is_called()

        than_ZO_SavedVars_New_was_called_with(expected_new_params)
    end)
end)

describe("Test output", function()
    local cache = pinfo.CACHE

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function get_character_name_returns(name)
        ut_helper.stub_function(pinfo_char, "get_character_name", name)
    end

    local function get_character_level_returns(level)
        ut_helper.stub_function(pinfo_char, "get_character_level", level)
    end

    local function get_character_class_returns(class)
        ut_helper.stub_function(pinfo_char, "get_character_class", class)
    end

    local function get_character_level_xp_percent_returns(percent)
        ut_helper.stub_function(pinfo_char, "get_character_level_xp_percent", percent)
    end

    local function get_character_xp_gain_returns(gain)
        ut_helper.stub_function(pinfo_char, "get_character_xp_gain", gain)
    end

    local function get_character_name_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_name).was.called_with(cache)
    end

    local function get_character_level_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_level).was.called_with(cache)
    end

    local function get_character_class_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_class).was.called_with(cache)
    end

    local function get_character_level_xp_percent_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_level_xp_percent).was.called_with(cache)
    end

    local function get_character_xp_gain_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_xp_gain).was.called_with(cache)
    end
    -- }}}

    it("Experience point update put into message buffer",
    function()
        get_character_name_returns("boo")
        get_character_level_returns(33)
        get_character_class_returns("a")
        get_character_level_xp_percent_returns(12.34)
        get_character_xp_gain_returns(100)

        pinfo_output.xp_to_chat_tab()
        str = string.format("+%s+ +%d+ +%s+ +%.2f%%+ (+%d XP)",
                            "boo",
                            33,
                            "a",
                            12.34,
                            100)
        assert.is.equal(str, pinfo_output.xp_message_buffer[1])

        get_character_name_was_called_once_with_cache()
        get_character_level_was_called_once_with_cache()
        get_character_class_was_called_once_with_cache()
        get_character_level_xp_percent_was_called_once_with_cache()
        get_character_xp_gain_was_called_once_with_cache()
    end)

    -- {{{
    local function get_character_ava_rank_name_returns(name)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_name", name)
    end

    local function get_character_ava_rank_points_percent_returns(percent)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_percent", percent)
    end

    local function get_character_ava_points_returns(gain)
        ut_helper.stub_function(pinfo_char, "get_character_ava_points_gain", gain)
    end

    local function get_character_ava_rank_name_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_name).was.called_with(cache)
    end

    local function get_character_ava_rank_points_percent_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_points_percent).was.called_with(cache)
    end

    local function get_character_ava_points_gain_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_points_gain).was.called_with(cache)
    end
    -- }}}

    it("Alliance point update put into message buffer",
    function()
        get_character_ava_rank_name_returns("baa")
        get_character_name_returns("boo")
        get_character_class_returns("a")
        get_character_ava_rank_points_percent_returns(12.34)
        get_character_ava_points_returns(200)

        pinfo_output.ap_to_chat_tab()
        str = string.format("+%s+ +%s+ +%s+ +%.2f%%+ (+%d AP)",
                            "baa",
                            "boo",
                            "a",
                            12.34,
                            200)
        assert.is.equal(str, pinfo_output.ap_message_buffer[1])

        get_character_ava_rank_name_was_called_once_with_cache()
        get_character_name_was_called_once_with_cache()
        get_character_class_was_called_once_with_cache()
        get_character_ava_rank_points_percent_was_called_once_with_cache()
        get_character_ava_points_gain_was_called_once_with_cache()
    end)
end)

-- vim:fdm=marker
