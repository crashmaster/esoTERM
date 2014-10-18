local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

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
    -- }}}

    it("Register for player activated event",
    function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_pinfo_output_on_player_activated_is_stubbed()
            and_expected_register_event_parameter_is_set_up()

        when_initialize_is_called()

        then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
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

    local function then_ZO_SavedVars_New_was_called_with(expected_params)
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

        then_ZO_SavedVars_New_was_called_with(expected_new_params)
    end)
end)

describe("Test print functions", function()
    it("Sysout...",
    function()
    end)
end)

describe("Test output messages", function()
    local NAME = "Hank"
    local LEVEL_XP_PERCENT = 12.34
    local XP_GAIN = 1000
    local LEVEL_AP_PERCENT = 43.21
    local AP_GAIN = 2000
    local cache = pinfo.CACHE
    local ITEM = "Mighty Sword"
    local QUANTITY = 1
    local IN_COMBAT = true
    local OUT_OF_COMBAT = false
    local COMBAT_LENGHT = 34563
    local DAMAGE = 103689

    before_each(function()
        pinfo_output.initialize()
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_get_name_returns(name)
        ut_helper.stub_function(pinfo_char, "get_name", name)
    end

    local function and_get_name_was_called_once_with_cache()
        assert.spy(pinfo_char.get_name).was.called_with(cache)
    end

    local function and_get_level_xp_percent_returns(percent)
        ut_helper.stub_function(pinfo_char, "get_level_xp_percent", percent)
    end

    local function and_get_level_xp_percent_was_called_once_with_cache()
        assert.spy(pinfo_char.get_level_xp_percent).was.called_with(cache)
    end

    local function and_get_xp_gain_returns(gain)
        ut_helper.stub_function(pinfo_char, "get_xp_gain", gain)
    end

    local function and_get_xp_gain_was_called_once_with_cache()
        assert.spy(pinfo_char.get_xp_gain).was.called_with(cache)
    end

    local function when_xp_to_chat_tab_is_called()
        pinfo_output.xp_to_chat_tab()
    end

    local function then_xp_message_buffer_contains_the_expected_entry()
        local str = string.format("%s gained %d XP (%.2f%%)",
                                  NAME,
                                  XP_GAIN,
                                  LEVEL_XP_PERCENT)
        assert.is.equal(str, pinfo_output.message_buffers.xp_messages[1])
    end
    -- }}}

    it("Experience point update message entry is put into message buffer",
    function()
        given_that_get_name_returns(NAME)
            and_get_level_xp_percent_returns(LEVEL_XP_PERCENT)
            and_get_xp_gain_returns(XP_GAIN)

        when_xp_to_chat_tab_is_called()

        then_xp_message_buffer_contains_the_expected_entry()
            and_get_name_was_called_once_with_cache()
            and_get_xp_gain_was_called_once_with_cache()
            and_get_level_xp_percent_was_called_once_with_cache()
    end)

    -- {{{
    local function and_get_ava_rank_points_percent_returns(percent)
        ut_helper.stub_function(pinfo_char, "get_ava_rank_points_percent", percent)
    end

    local function and_get_ava_rank_points_percent_was_called_once_with_cache()
        assert.spy(pinfo_char.get_ava_rank_points_percent).was.called_with(cache)
    end

    local function and_get_ava_points_returns(gain)
        ut_helper.stub_function(pinfo_char, "get_ap_gain", gain)
    end

    local function and_get_ap_gain_was_called_once_with_cache()
        assert.spy(pinfo_char.get_ap_gain).was.called_with(cache)
    end

    local function when_ap_to_chat_tab_is_called()
        pinfo_output.ap_to_chat_tab()
    end

    local function then_ap_message_buffer_contains_the_expected_entry()
        local str = string.format("%s gained %d AP (%.2f%%)",
                                  NAME,
                                  AP_GAIN,
                                  LEVEL_AP_PERCENT)
        assert.is.equal(str, pinfo_output.message_buffers.ap_messages[1])
    end
    -- }}}

    it("Alliance point update message entry is put into message buffer",
    function()
        given_that_get_name_returns(NAME)
            and_get_ava_points_returns(AP_GAIN)
            and_get_ava_rank_points_percent_returns(LEVEL_AP_PERCENT)

        when_ap_to_chat_tab_is_called()

        then_ap_message_buffer_contains_the_expected_entry()
            and_get_name_was_called_once_with_cache()
            and_get_ap_gain_was_called_once_with_cache()
            and_get_ava_rank_points_percent_was_called_once_with_cache()
    end)

    -- {{{
    local function and_zo_strformat_returns(item)
        ut_helper.stub_function(GLOBAL, "zo_strformat", "[" .. item .. "]")
    end

    local function and_zo_strformat_was_called_once_with(format, item)
        assert.spy(GLOBAL.zo_strformat).was.called_with(format, item)
    end

    local function when_loot_to_chat_tab_is_called()
        pinfo_output.loot_to_chat_tab(ITEM, QUANTITY)
    end

    local function then_loot_message_buffer_contains_the_expected_entry()
        local str = string.format("%s received %d [%s]", NAME, QUANTITY, ITEM)
        assert.is.equal(str, pinfo_output.message_buffers.loot_messages[1])
    end
    -- }}}

    it("Loot received update message entry is put into message buffer",
    function()
        given_that_get_name_returns(NAME)
            and_zo_strformat_returns(ITEM)

        when_loot_to_chat_tab_is_called()

        then_loot_message_buffer_contains_the_expected_entry()
            and_get_name_was_called_once_with_cache()
            and_zo_strformat_was_called_once_with(SI_TOOLTIP_ITEM_NAME, ITEM)
    end)

    -- {{{
    local function and_get_combat_state_returns(state)
        ut_helper.stub_function(pinfo_char, "get_combat_state", state)
    end

    local function and_get_combat_state_was_called_once_with_cache()
        assert.spy(pinfo_char.get_combat_state).was.called_with(cache)
    end

    local function when_combat_state_to_chat_tab_is_called()
        pinfo_output.combat_state_to_chat_tab()
    end

    local function then_combat_state_message_buffer_is(str)
        assert.is.equal(str, pinfo_output.message_buffers.combat_state_messages[1])
    end
    -- }}}

    it("Combat enter update message entry is put into message buffer",
    function()
        given_that_get_name_returns(NAME)
            and_get_combat_state_returns(IN_COMBAT)

        when_combat_state_to_chat_tab_is_called()

        then_combat_state_message_buffer_is(NAME .. " entered combat")
            and_get_name_was_called_once_with_cache()
            and_get_combat_state_was_called_once_with_cache()
    end)

    -- {{{
    local function and_get_combat_length_returns(length)
        ut_helper.stub_function(pinfo_char, "get_combat_lenght", length)
    end

    local function and_get_combat_length_was_called_once_with_cache()
        assert.spy(pinfo_char.get_combat_lenght).was.called_with(cache)
    end

    local function and_get_combat_damage_returns(damage)
        ut_helper.stub_function(pinfo_char, "get_combat_damage", damage)
    end

    local function and_get_combat_damage_was_called_once_with_cache()
        assert.spy(pinfo_char.get_combat_damage).was.called_with(cache)
    end
    -- }}}

    it("Combat exit update message entry is put into message buffer",
    function()
        given_that_get_name_returns(NAME)
            and_get_combat_state_returns(OUT_OF_COMBAT)
            and_get_combat_length_returns(COMBAT_LENGHT)
            and_get_combat_damage_returns(DAMAGE)

        when_combat_state_to_chat_tab_is_called()

        then_combat_state_message_buffer_is("Hank left combat (lasted: 34.56s, dps: 3000.00)")
            and_get_name_was_called_once_with_cache()
            and_get_combat_state_was_called_once_with_cache()
            and_get_combat_length_was_called_once_with_cache()
            and_get_combat_damage_was_called_once_with_cache()
    end)

    it("Lowest denominator is 1 sec when counting dps",
    function()
        given_that_get_name_returns(NAME)
            and_get_combat_state_returns(OUT_OF_COMBAT)
            and_get_combat_length_returns(567)
            and_get_combat_damage_returns(DAMAGE)

        when_combat_state_to_chat_tab_is_called()

        then_combat_state_message_buffer_is("Hank left combat (lasted: 0.57s, dps: 103689.00)")
            and_get_name_was_called_once_with_cache()
            and_get_combat_state_was_called_once_with_cache()
            and_get_combat_length_was_called_once_with_cache()
            and_get_combat_damage_was_called_once_with_cache()
    end)
end)

-- vim:fdm=marker
