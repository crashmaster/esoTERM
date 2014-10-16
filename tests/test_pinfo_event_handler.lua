local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G


describe("Test event handler initialization.", function()
    local addon_name = "pinfo"
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

    local function and_pinfo_event_handler_on_experience_update_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "on_experience_update", nil)
    end

    local function and_expected_register_event_parameters_are_set_up()
        expected_register_params.experience_points_update = {
            addon_name = addon_name,
            event = 2,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.veteran_points_update = {
            addon_name = addon_name,
            event = 3,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.level_update = {
            addon_name = addon_name,
            event = 4,
            callback = pinfo_event_handler.on_level_update
        }
        expected_register_params.veteran_rank_update = {
            addon_name = addon_name,
            event = 5,
            callback = pinfo_event_handler.on_level_update
        }
        expected_register_params.ava_xp_update = {
            addon_name = addon_name,
            event = 6,
            callback = pinfo_event_handler.on_ava_points_update
        }
        expected_register_params.loot_received_update = {
            addon_name = addon_name,
            event = 7,
            callback = pinfo_event_handler.on_loot_received
        }
        expected_register_params.combat_state_update = {
            addon_name = addon_name,
            event = 8,
            callback = pinfo_event_handler.on_combat_state_update
        }
    end

    local function when_initialize_is_called()
        pinfo_event_handler.initialize()
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

    it("Register for events",
    function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_pinfo_event_handler_on_experience_update_is_stubbed()
            and_expected_register_event_parameters_are_set_up()

        when_initialize_is_called()

        then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"
    local UNIT = "player"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_pinfo_output_xp_to_chat_tab_is_stubbed()
        ut_helper.stub_function(pinfo_output, "xp_to_chat_tab", nil)
    end

    local function and_pinfo_output_xp_to_chat_tab_was_called_once()
        assert.spy(pinfo_output.xp_to_chat_tab).was.called_with()
    end

    local function and_pinfo_output_xp_to_chat_tab_was_not_called()
        assert.spy(pinfo_output.xp_to_chat_tab).was_not.called()
    end

    local function given_that_pinfo_output_ap_to_chat_tab_is_stubbed()
        ut_helper.stub_function(pinfo_output, "ap_to_chat_tab", nil)
    end

    local function and_pinfo_output_ap_to_chat_tab_was_called_once()
        assert.spy(pinfo_output.ap_to_chat_tab).was.called_with()
    end

    local function and_pinfo_output_ap_to_chat_tab_was_not_called()
        assert.spy(pinfo_output.ap_to_chat_tab).was_not.called()
    end
    -- }}}

    describe("The on experience update event handler.", function()
        local cache = pinfo.CACHE

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
            cache.level_xp = OLD_XP
            cache.level_xp_max = OLD_XP_MAX
            cache.level_xp_percent = OLD_XP_PCT
            cache.xp_gain = OLD_XP_GAIN
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

        it("Happy flow.", function()
            given_that_pinfo_output_xp_to_chat_tab_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated()
                and_pinfo_output_xp_to_chat_tab_was_called_once()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
            assert.is.equal(NEW_XP_LVL_UP, cache.level_xp)
            assert.is.equal(OLD_XP_MAX, cache.level_xp_max)
            assert.is.equal(100, cache.level_xp_percent)
            assert.is.equal(NEW_XP_LVL_UP - OLD_XP, cache.xp_gain)
        end
        -- }}}

        it("If xp > level xp maximum, then 100%.", function()
            given_that_pinfo_output_xp_to_chat_tab_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP_LVL_UP, OLD_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_updated_to_lvl_up()
                and_pinfo_output_xp_to_chat_tab_was_called_once()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_XP, cache.level_xp)
            assert.is.equal(OLD_XP_MAX, cache.level_xp_max)
            assert.is.equal(OLD_XP_PCT, cache.level_xp_percent)
        end
        -- }}}

        it("If unit is incorrect.", function()
            given_that_pinfo_output_xp_to_chat_tab_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, "foo", NEW_XP, NEW_XP_MAX, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_pinfo_output_xp_to_chat_tab_was_not_called()
        end)

        -- {{{
        local function then_the_xp_properties_in_character_info_where_partly_updated()
            assert.is.equal(NEW_XP, cache.level_xp)
            assert.is.equal(NEW_XP_MAX, cache.level_xp_max)
            assert.is.equal(NEW_XP_PCT, cache.level_xp_percent)
            assert.is.equal(OLD_XP_GAIN, cache.xp_gain)
        end
        -- }}}
        it("If reason is incorrect (level up drift handling).", function()
            given_that_pinfo_output_xp_to_chat_tab_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, -1)

            then_the_xp_properties_in_character_info_where_partly_updated()
                and_pinfo_output_xp_to_chat_tab_was_called_once()
        end)

        it("If total maximum xp reached.", function()
            given_that_pinfo_output_xp_to_chat_tab_is_stubbed()

            when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, 0, REASON)

            then_the_xp_properties_in_character_info_where_not_updated()
                and_pinfo_output_xp_to_chat_tab_was_not_called()
        end)
    end)

    describe("The on level update event handler.", function()
        local cache = pinfo.CACHE

        local OLD_LEVEL = 1
        local NEW_LEVEL = 2

        before_each(function()
            cache.level = OLD_LEVEL
        end)

        -- {{{
        local function when_on_level_update_is_called_with(event, unit, level)
            pinfo_event_handler.on_level_update(event, unit, level)
        end

        local function then_the_level_property_in_character_info_was_updated()
            assert.is.equal(NEW_LEVEL, cache.level)
        end
        -- }}}

        it("Happy flow.", function()
            when_on_level_update_is_called_with(EVENT, UNIT, NEW_LEVEL)

            then_the_level_property_in_character_info_was_updated()
        end)

        -- {{{
        local function then_the_level_property_in_character_info_was_not_updated()
            assert.is.equal(OLD_LEVEL, cache.level)
        end
        -- }}}

        it("If unit incorrect.", function()
            when_on_level_update_is_called_with(EVENT, "foo", NEW_LEVEL)

            then_the_level_property_in_character_info_was_not_updated()
        end)
    end)

    describe("The on AvA points update event handler.", function()
        local cache = pinfo.CACHE

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
            cache.ava_rank = OLD_RANK
            cache.ava_rank_points = OLD_POINTS
            cache.ava_rank_points_max = OLD_POINTS_MAX
            cache.ava_rank_points_percent = OLD_POINTS_PCT
            cache.ap_gain = OLD_GAIN
        end)

        -- {{{
        local function and_that_get_ava_rank_returns(rank)
            ut_helper.stub_function(pinfo_char, "get_ava_rank", rank)
        end

        local function and_get_ava_rank_was_called_once_witch_cache()
            assert.spy(pinfo_char.get_ava_rank).was.called_with(cache)
        end

        local function and_that_get_ava_rank_points_max_returns(points)
            ut_helper.stub_function(pinfo_char, "get_ava_rank_points_max", points)
        end

        local function and_get_ava_rank_points_max_was_called_once_witch_cache()
            assert.spy(pinfo_char.get_ava_rank_points_max).was.called_with(cache)
        end

        local function when_on_ava_points_update_is_called_with(event, point, sound, diff)
            pinfo_event_handler.on_ava_points_update(event, point, sound, diff)
        end

        local function then_the_ava_properties_in_character_info_where_updated_no_rank_up()
            assert.is.equal(OLD_RANK, cache.ava_rank)
            assert.is.equal(NEW_POINTS, cache.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT, cache.ava_rank_points_percent)
            assert.is.equal(NEW_GAIN, cache.ap_gain)
        end

        local function then_the_ava_properties_in_character_info_where_not_updated()
            assert.is.equal(OLD_RANK, cache.ava_rank)
            assert.is.equal(OLD_POINTS, cache.ava_rank_points)
            assert.is.equal(OLD_POINTS_PCT, cache.ava_rank_points_percent)
            assert.is.equal(OLD_GAIN, cache.ap_gain)
        end

        local function then_the_ava_properties_in_character_info_where_updated_rank_up()
            assert.is.equal(NEW_RANK, cache.ava_rank)
            assert.is.equal(NEW_POINTS_RANK_UP, cache.ava_rank_points)
            assert.is.equal(NEW_POINTS_PCT_RANK_UP, cache.ava_rank_points_percent)
            assert.is.equal(GAIN_RANK_UP, cache.ap_gain)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_pinfo_output_ap_to_chat_tab_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, NEW_GAIN)

            then_the_ava_properties_in_character_info_where_updated_no_rank_up()
                and_pinfo_output_ap_to_chat_tab_was_called_once()
        end)

        it("Zero gain.", function()
            given_that_pinfo_output_ap_to_chat_tab_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_ZERO)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_pinfo_output_ap_to_chat_tab_was_not_called()
        end)

        it("Negative gain.", function()
            given_that_pinfo_output_ap_to_chat_tab_is_stubbed()

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_NEGATIVE)

            then_the_ava_properties_in_character_info_where_not_updated()
                and_pinfo_output_ap_to_chat_tab_was_not_called()
        end)

        it("Gain enough AP to rank up.", function()
            given_that_pinfo_output_ap_to_chat_tab_is_stubbed()
                and_that_get_ava_rank_returns(NEW_RANK)
                and_that_get_ava_rank_points_max_returns(NEW_POINTS_MAX)

            when_on_ava_points_update_is_called_with(EVENT, POINT, SOUND, GAIN_RANK_UP)

            then_the_ava_properties_in_character_info_where_updated_rank_up()
                and_get_ava_rank_was_called_once_witch_cache()
                and_get_ava_rank_points_max_was_called_once_witch_cache()
                and_pinfo_output_ap_to_chat_tab_was_called_once()
        end)
    end)

    describe("The on loot received event handler.", function()
        local BY = "by"
        local ITEM = "item"
        local QUANTITY = 1
        local SOUND = "sound"
        local LOOT_TYPE = "loot_type"

        -- {{{
        local function given_that_pinfo_output_loot_to_chat_tab_is_stubbed()
            ut_helper.stub_function(pinfo_output, "loot_to_chat_tab", nil)
        end

        local function when_on_loot_received_is_called_with(event, by, item, quantity, sound, loot_type, self)
            pinfo_event_handler.on_loot_received(event, by, item, quantity, sound, loot_type, self)
        end

        local function then_pinfo_output_loot_to_chat_tab_was_called_with(item, quantity)
            assert.spy(pinfo_output.loot_to_chat_tab).was.called_with(item, quantity)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_pinfo_output_loot_to_chat_tab_is_stubbed()

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, true)

            then_pinfo_output_loot_to_chat_tab_was_called_with(ITEM, QUANTITY)
        end)

        -- {{{
        local function then_pinfo_output_loot_to_chat_tab_was_not_called()
            assert.spy(pinfo_output.loot_to_chat_tab).was_not.called()
        end
        -- }}}

        it("If not self.", function()
            given_that_pinfo_output_loot_to_chat_tab_is_stubbed()

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, false)

            then_pinfo_output_loot_to_chat_tab_was_not_called()
        end)
    end)

    describe("The on combat-state-change event handler.", function()
        local cache = pinfo.CACHE

        local OUTER_COMBAT = false
        local IN_COMBAT = true
        local ENTER_TIME = 10
        local EXIT_TIME = 50
        local DAMAGE = 80

        after_each(function()
            cache.combat_state = nil
            cache.combat_start_time = -1
            cache.combat_lenght = 0
            cache.combat_damage = -1
        end)

        -- {{{
        local function given_that_get_combat_state_returns(combat_state)
            ut_helper.stub_function(pinfo_char, "get_combat_state", combat_state)
        end

        local function and_that_pinfo_output_combat_state_to_chat_tab_is_stubbed()
            ut_helper.stub_function(pinfo_output, "combat_state_to_chat_tab", nil)
        end

        local function and_that_eso_GetGameTimeMilliseconds_returns(time)
            ut_helper.stub_function(GLOBAL, "GetGameTimeMilliseconds", time)
        end

        local function and_eso_GetGameTimeMilliseconds_was_called()
            assert.spy(GLOBAL.GetGameTimeMilliseconds).was.called()
        end

        local function and_that_event_manager_RegisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
        end

        local function and_event_manager_RegisterForEvent_was_called()
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER,
                pinfo.ADDON_NAME,
                EVENT_COMBAT_EVENT,
                pinfo_event_handler.on_combat_event_update
            )
        end

        local function when_on_combat_state_update_is_called_with(event, combat_state)
            pinfo_event_handler.on_combat_state_update(event, combat_state)
        end

        local function and_pinfo_output_combat_state_to_chat_tab_was_called()
            assert.spy(pinfo_output.combat_state_to_chat_tab).was.called()
        end

        local function then_the_and_cached_combat_state_became(comat_state)
            assert.is.equal(comat_state, cache.combat_state)
        end

        local function and_cached_combat_start_time_became(start_time)
            assert.is.equal(start_time, cache.combat_start_time)
        end

        local function and_cached_combat_damage_became(damage)
            assert.is.equal(damage, cache.combat_damage)
        end
        -- }}}

        it("From out of combat to in combat.", function()
            given_that_get_combat_state_returns(OUTER_COMBAT)
                and_that_eso_GetGameTimeMilliseconds_returns(ENTER_TIME)
                and_that_event_manager_RegisterForEvent_is_stubbed()
                and_that_pinfo_output_combat_state_to_chat_tab_is_stubbed()

            when_on_combat_state_update_is_called_with(EVENT, IN_COMBAT)

            then_the_and_cached_combat_state_became(IN_COMBAT)
                and_eso_GetGameTimeMilliseconds_was_called()
                and_cached_combat_start_time_became(ENTER_TIME)
                and_cached_combat_damage_became(0)
                and_event_manager_RegisterForEvent_was_called()
                and_pinfo_output_combat_state_to_chat_tab_was_called()
        end)

        -- {{{
        local function and_that_get_combat_start_time_returns(time)
            ut_helper.stub_function(pinfo_char, "get_combat_start_time", time)
        end

        local function and_get_combat_start_time_was_called_once_with_cache()
            assert.spy(pinfo_char.get_combat_start_time).was.called_with(cache)
        end

        local function and_that_event_manager_UnregisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
        end

        local function and_that_cached_combat_start_time_is(time)
            cache.combat_start_time = time
        end

        local function and_that_cached_combat_damage_is(damage)
            cache.combat_damage = damage
        end

        local function and_event_manager_UnregisterForEvent_was_called()
            assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
                EVENT_MANAGER,
                pinfo.ADDON_NAME,
                EVENT_COMBAT_EVENT
            )
        end

        local function and_cached_combat_lenght_became(lenght)
            assert.is.equal(lenght, cache.combat_lenght)
        end
        -- }}}

        it("From in combat to out of combat", function()
            given_that_get_combat_state_returns(IN_COMBAT)
                and_that_get_combat_start_time_returns(ENTER_TIME)
                and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME)
                and_that_event_manager_UnregisterForEvent_is_stubbed()
                and_that_cached_combat_start_time_is(ENTER_TIME)
                and_that_cached_combat_damage_is(DAMAGE)
                and_that_pinfo_output_combat_state_to_chat_tab_is_stubbed()

            when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

            then_the_and_cached_combat_state_became(OUTER_COMBAT)
                and_get_combat_start_time_was_called_once_with_cache()
                and_cached_combat_lenght_became(EXIT_TIME - ENTER_TIME)
                and_event_manager_UnregisterForEvent_was_called()
                and_cached_combat_start_time_became(0)
                and_cached_combat_damage_became(0)
                and_pinfo_output_combat_state_to_chat_tab_was_called()
        end)

        it("Combat length when combat start time is invalid", function()
            given_that_get_combat_state_returns(IN_COMBAT)
                and_that_get_combat_start_time_returns(0)
                and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME)
                and_that_event_manager_UnregisterForEvent_is_stubbed()
                and_that_pinfo_output_combat_state_to_chat_tab_is_stubbed()

            when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

            then_the_and_cached_combat_state_became(OUTER_COMBAT)
                and_get_combat_start_time_was_called_once_with_cache()
                and_cached_combat_lenght_became(-1)
                and_event_manager_UnregisterForEvent_was_called()
                and_cached_combat_start_time_became(0)
                and_cached_combat_damage_became(0)
                and_pinfo_output_combat_state_to_chat_tab_was_called()
        end)

        -- {{{
        local function then_pinfo_output_combat_state_to_chat_tab_was_not_called()
            assert.spy(pinfo_output.combat_state_to_chat_tab).was_not.called()
        end

        local function and_eso_GetGameTimeMilliseconds_was_not_called()
            assert.spy(GLOBAL.GetGameTimeMilliseconds).was_not.called()
        end
        -- }}}

        it("No combat-state-change, when already having that state", function()
            given_that_get_combat_state_returns(OUTER_COMBAT)
                and_that_pinfo_output_combat_state_to_chat_tab_is_stubbed()
                and_that_eso_GetGameTimeMilliseconds_returns(nil)

            when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

            then_pinfo_output_combat_state_to_chat_tab_was_not_called()
                and_eso_GetGameTimeMilliseconds_was_not_called()
        end)
    end)

    describe("The on combat event handler.", function()
        local NAME = "Hank"
        local ABILITY = "Orbital Strike"
        local ABILITY_HIT = 56789

        local EVENT_ID = 1
        local RESULT = 2
        local EVENT_NOT_OK = 3
        local ABILITY_NAME = 4
        local ABILITY_GRAPHIC = 5
        local ACTION_SLOT_TYPE = 6
        local SOURCE_NAME = 7
        local SOURCE_TYPE = 8
        local TARGET_NAME = 9
        local TARGET_TYPE = 10
        local HIT_VALUE = 11
        local POWER_TYPE = 12
        local DAMAGE_TYPE = 13
        local LOG = 14

        local parameter_values = {}

        -- {{{
        local function reset_event_parameters()
            parameter_values = {
                0,                              --  1 -> event_id
                ACTION_RESULT_DAMAGE,           --  2 -> result
                false,                          --  3 -> event_not_ok
                ABILITY,                        --  4 -> ability_name
                0,                              --  5 -> ability_graphic
                ACTION_SLOT_TYPE_LIGHT_ATTACK,  --  6 -> action_slot_type
                "source",                       --  7 -> source_name
                COMBAT_UNIT_TYPE_PLAYER,        --  8 -> source_type
                "target",                       --  9 -> target_name
                COMBAT_UNIT_TYPE_PLAYER,        -- 10 -> target_type
                ABILITY_HIT,                    -- 11 -> hit_value
                POWERTYPE_MAGICKA,              -- 12 -> power_type
                DAMAGE_TYPE_FIRE,               -- 13 -> damage_type
                false                           -- 14 -> log
            }
        end
        -- }}}

        before_each(function()
            reset_event_parameters()
        end)

        -- {{{
        local function given_that_parameter_value_is(parameter, value)
            parameter_values[parameter] = value
        end

        local function and_that_pinfo_char_get_name_returns(name)
            ut_helper.stub_function(pinfo_char, "get_name", name)
        end

        local function then_pinfo_char_get_name_was_called()
            assert.spy(pinfo_char.get_name).was.called()
        end

        local function then_pinfo_char_get_name_was_not_called()
            assert.spy(pinfo_char.get_name).was_not.called()
        end

        local function and_that_pinfo_output_stdout_is_stubbed()
            ut_helper.stub_function(pinfo_output, "stdout", nil)
        end

        local function and_pinfo_output_stdout_was_called_with(message)
            assert.spy(pinfo_output.stdout).was.called_with(message)
        end

        local function and_pinfo_output_stdout_was_not_called()
            assert.spy(pinfo_output.stdout).was_not.called()
        end

        local function when_on_combat_event_update_is_called()
            pinfo_event_handler.on_combat_event_update(unpack(parameter_values))
        end
        -- }}}

        it("Discard event if invalid or not damage related.",
        function()
            local test_parameters = {
                [RESULT] = 1234567890,
                [EVENT_NOT_OK] = true,
                [SOURCE_NAME] = "",
                [SOURCE_TYPE] = 1234567890,
                [TARGET_NAME] = "",
                [TARGET_TYPE] = 1234567890,
                [HIT_VALUE] = 0,
                [POWER_TYPE] = 0,
                [DAMAGE_TYPE] = 0
            }
            for parameter, value in pairs(test_parameters) do
                given_that_parameter_value_is(parameter, value)
                    and_that_pinfo_char_get_name_returns(NAME)
                    and_that_pinfo_output_stdout_is_stubbed()

                when_on_combat_event_update_is_called()

                then_pinfo_char_get_name_was_not_called()
                    and_pinfo_output_stdout_was_not_called()

                reset_event_parameters()
            end
        end)

        it("Print damage related message.",
        function()
            given_that_parameter_value_is(HIT_VALUE, ABILITY_HIT)
                and_that_pinfo_char_get_name_returns(NAME)
                and_that_pinfo_output_stdout_is_stubbed()

            when_on_combat_event_update_is_called()

            then_pinfo_char_get_name_was_called()
                and_pinfo_output_stdout_was_called_with(
                    string.format("%s deals damage with %s for: %d",
                                  NAME, ABILITY, ABILITY_HIT)
                )
        end)
    end)
end)

-- vim:fdm=marker
