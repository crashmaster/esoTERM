-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_char_library")

local and_GetGameTimeMilliseconds_was_called = tl.and_GetGameTimeMilliseconds_was_called
local and_GetGameTimeMilliseconds_was_not_called = tl.and_GetGameTimeMilliseconds_was_not_called
local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_get_combat_exit_time_was_called = tl.and_get_combat_exit_time_was_called
local and_get_combat_exit_time_was_not_called = tl.and_get_combat_exit_time_was_not_called
local and_get_combat_start_time_was_called = tl.and_get_combat_start_time_was_called
local and_get_combat_start_time_was_not_called = tl.and_get_combat_start_time_was_not_called
local and_get_last_xp_gain_time_was_called = tl.and_get_last_xp_gain_time_was_called
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_module_is_inactive_was_saved = tl.and_module_is_inactive_was_saved
local and_register_for_event_was_called_with_expected_parameters = tl.and_register_for_event_was_called_with_expected_parameters
local and_register_for_event_was_not_called = tl.and_register_for_event_was_not_called
local and_register_module_was_called = tl.and_register_module_was_called
local and_register_module_was_called = tl.and_register_module_was_called
local and_that_GetGameTimeMilliseconds_is_stubbed = tl.and_that_GetGameTimeMilliseconds_is_stubbed
local and_that_GetGameTimeMilliseconds_returns = tl.and_that_GetGameTimeMilliseconds_returns
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_get_combat_exit_time_is_stubbed = tl.and_that_get_combat_exit_time_is_stubbed
local and_that_get_combat_exit_time_returns = tl.and_that_get_combat_exit_time_returns
local and_that_get_combat_start_time_is_stubbed = tl.and_that_get_combat_start_time_is_stubbed
local and_that_get_combat_start_time_returns = tl.and_that_get_combat_start_time_returns
local and_that_getter_functions_are_stubbed = tl.and_that_getter_functions_are_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_that_unregister_from_event_is_stubbed = tl.and_that_unregister_from_event_is_stubbed
local and_unregister_from_all_events_was_called = tl.and_unregister_from_all_events_was_called
local and_unregister_from_event_was_not_called = tl.and_unregister_from_event_was_not_called
local and_zo_savedvars_new_was_called = tl.and_zo_savedvars_new_was_called
local and_zo_savedvars_new_was_called = tl.and_zo_savedvars_new_was_called
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_cached_last_xp_gain_time_is_not_set = tl.given_that_cached_last_xp_gain_time_is_not_set
local given_that_get_last_xp_gain_time_returns = tl.given_that_get_last_xp_gain_time_returns
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local then_cached_last_xp_gain_time_became = tl.then_cached_last_xp_gain_time_became
local then_get_combat_exit_time_returned = tl.then_get_combat_exit_time_returned
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_char_module_has_the_expected_name = tl.verify_that_esoTERM_char_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_for_the_module_is_called = tl.when_deactivate_for_the_module_is_called
local when_get_combat_exit_time_is_called = tl.when_get_combat_exit_time_is_called
local when_initialize_is_called = tl.when_initialize_is_called
local when_initialize_is_called = tl.when_initialize_is_called
local when_on_vp_gain_is_called_with = tl.when_on_vp_gain_is_called_with
local when_on_xp_gain_is_called_with = tl.when_on_xp_gain_is_called_with
-- }}}

describe("Test the esoTERM_char module.", function()
    it("Module is called: esoTERM-character.",
    function()
        verify_that_esoTERM_char_module_has_the_expected_name()
    end)
end)

describe("Test the esoTERM_char module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        given_that_module_configured_as_inactive()
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_not_called()
            and_zo_savedvars_new_was_called()
            and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_register_module_is_stubbed()
            and_that_activate_is_stubbed()

        when_initialize_is_called()

        then_activate_was_called()
            and_zo_savedvars_new_was_called()
            and_register_module_was_called()
    end)
end)

describe("Test esoTERM_char module activate.", function()
    after_each(function()
        expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)
    -- TODO: clear chache after tests?

    it("Update cache and subscribe for events on activate.",
    function()
        given_that_module_is_inactive()
            and_that_cache_is_empty()
            and_that_expected_register_for_event_calls_are_set_up()
            and_that_register_for_event_is_stubbed()
            and_that_getter_functions_are_stubbed()

        when_activate_is_called()

        and_module_became_active()
            and_cache_is_no_longer_empty()
            and_register_for_event_was_called_with_expected_parameters()
            and_getter_function_stubs_were_called()
            and_cached_values_became_initialized()
            and_module_is_active_was_saved()
    end)
end)

describe("Test esoTERM_char module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_for_the_module_is_called()

        then_module_became_inactive()
            and_unregister_from_all_events_was_called()
            and_module_is_inactive_was_saved()
    end)
end)

describe("Test Character related data getters.", function()
    local results = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        results = nil
    end)

    -- {{{
    local function given_that_cached_character_name_is_not_set()
        tl.CACHE.name = nil
    end

    local function and_that_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function when_get_name_is_called()
        results.name = esoTERM_char.get_name()
    end

    local function then_the_returned_character_name_was(name)
        assert.is.equal(name, results.name)
    end

    local function and_GetUnitName_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitName).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER NAME, when NOT CACHED.",
    function()
        given_that_cached_character_name_is_not_set()
            and_that_GetUnitName_returns(tl.NAME_1)

        when_get_name_is_called()

        then_the_returned_character_name_was(tl.NAME_1)
            and_GetUnitName_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        tl.CACHE.name = name
    end

    local function and_that_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function and_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Query CHARACTER NAME, when CACHED.",
    function()
        given_that_cached_character_name_is(tl.NAME_1)
            and_that_GetUnitName_returns(NAME_2)

        when_get_name_is_called()

        then_the_returned_character_name_was(tl.NAME_1)
            and_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_gender_is_not_set()
        tl.CACHE.gender = nil
    end

    local function and_that_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function when_get_gender_is_called()
        results.gender = esoTERM_char.get_gender()
    end

    local function then_the_returned_character_gender_was(gender)
        assert.is.equal(gender, results.gender)
    end

    local function and_GetUnitGender_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitGender).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER GENDER, when NOT CACHED.",
    function()
        given_that_cached_character_gender_is_not_set()
            and_that_GetUnitGender_returns(tl.GENDER_1)

        when_get_gender_is_called()

        then_the_returned_character_gender_was(tl.GENDER_1)
            and_GetUnitGender_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_gender_is(gender)
        tl.CACHE.gender = gender
    end

    local function and_that_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function and_GetUnitGender_was_not_called()
        assert.spy(GLOBAL.GetUnitGender).was_not.called()
    end
    -- }}}

    it("Query CHARACTER GENDER, when CACHED.",
    function()
        given_that_cached_character_gender_is(tl.GENDER_1)
            and_that_GetUnitGender_returns(GENDER_2)

        when_get_gender_is_called()

        then_the_returned_character_gender_was(tl.GENDER_1)
            and_GetUnitGender_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_class_is_not_set()
        tl.CACHE.class = nil
    end

    local function and_that_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function when_get_class_is_called()
        results.class = esoTERM_char.get_class()
    end

    local function then_the_returned_character_class_was(class)
        assert.is.equal(class, results.class)
    end

    local function and_GetUnitClass_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitClass).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER CLASS, when NOT CACHED.",
    function()
        given_that_cached_character_class_is_not_set()
            and_that_GetUnitClass_returns(tl.CLASS_1)

        when_get_class_is_called()

        then_the_returned_character_class_was(tl.CLASS_1)
            and_GetUnitClass_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_class_is(class)
        tl.CACHE.class = class
    end

    local function and_that_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function and_GetUnitClass_was_not_called()
        assert.spy(GLOBAL.GetUnitClass).was_not.called()
    end
    -- }}}

    it("Query CHARACTER CLASS, when CACHED.",
    function()
        given_that_cached_character_class_is(tl.CLASS_1)
            and_that_GetUnitClass_returns(CLASS_2)

        when_get_class_is_called()

        then_the_returned_character_class_was(tl.CLASS_1)
            and_GetUnitClass_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_combat_state_is_not_set()
        tl.CACHE.combat_state = nil
    end

    local function and_that_IsUnitInCombat_returns(combat_state)
        ut_helper.stub_function(GLOBAL, "IsUnitInCombat", combat_state)
    end

    local function when_get_combat_state_is_called()
        results.combat_state = esoTERM_char.get_combat_state()
    end

    local function then_the_returned_character_combat_state_was(combat_state)
        assert.is.equal(combat_state, results.combat_state)
    end

    local function and_IsUnitInCombat_was_called_once_with_player()
        assert.spy(GLOBAL.IsUnitInCombat).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER IN-COMBAT-NESS, when NOT CACHED.",
    function()
        given_that_cached_character_combat_state_is_not_set()
            and_that_IsUnitInCombat_returns(tl.COMBAT_STATE_1)

        when_get_combat_state_is_called()

        then_the_returned_character_combat_state_was(tl.COMBAT_STATE_1)
            and_IsUnitInCombat_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_combat_state_is(combat_state)
        tl.CACHE.combat_state = combat_state
    end

    local function and_IsUnitInCombat_was_not_called()
        assert.spy(GLOBAL.IsUnitInCombat).was_not.called()
    end
    -- }}}

    it("Query CHARACTER IN-COMBAT-NESS, when CACHED.",
    function()
        given_that_cached_character_combat_state_is(tl.COMBAT_STATE_1)
            and_that_IsUnitInCombat_returns(COMBAT_STATE_2)

        when_get_combat_state_is_called()

        then_the_returned_character_combat_state_was(tl.COMBAT_STATE_1)
            and_IsUnitInCombat_was_not_called()
    end)

    -- {{{
    local function given_that_cached_combat_start_time_is_not_set()
        tl.CACHE.combat_start_time = nil
    end

    local function when_get_combat_start_time_is_called()
        results.combat_start_time = esoTERM_char.get_combat_start_time()
    end

    local function then_the_returned_combat_start_time_was(start_time)
        assert.is.equal(start_time, results.combat_start_time)
    end
    -- }}}

    it("Query COMBAT TIME START, when NOT CACHED.",
    function()
        given_that_cached_combat_start_time_is_not_set()

        when_get_combat_start_time_is_called()

        then_the_returned_combat_start_time_was(0)
    end)

    -- {{{
    local function given_that_cached_combat_start_time_is(start_time)
        tl.CACHE.combat_start_time = start_time
    end
    -- }}}

    it("Query COMBAT TIME START, when CACHED.",
    function()
        given_that_cached_combat_start_time_is(tl.COMBAT_START_TIME)

        when_get_combat_start_time_is_called()

        then_the_returned_combat_start_time_was(tl.COMBAT_START_TIME)
    end)

    -- {{{
    local function given_that_cached_combat_lenght_is_not_set()
        tl.CACHE.combat_lenght = nil
    end

    local function when_get_combat_lenght_is_called()
        results.combat_lenght = esoTERM_char.get_combat_lenght()
    end

    local function then_the_returned_combat_lenght_was(lenght)
        assert.is.equal(lenght, results.combat_lenght)
    end
    -- }}}

    it("Query COMBAT TIME LENGHT, when NOT CACHED.",
    function()
        given_that_cached_combat_lenght_is_not_set()

        when_get_combat_lenght_is_called()

        then_the_returned_combat_lenght_was(0)
    end)

    -- {{{
    local function given_that_cached_combat_lenght_is(lenght)
        tl.CACHE.combat_lenght = lenght
    end
    -- }}}

    it("Query COMBAT TIME LENGHT, when NOT POSITIVE.",
    function()
        given_that_cached_combat_lenght_is(-1)

        when_get_combat_lenght_is_called()

        then_the_returned_combat_lenght_was(0)
    end)

    -- {{{
    local function given_that_cached_combat_lenght_is(lenght)
        tl.CACHE.combat_lenght = lenght
    end
    -- }}}

    it("Query COMBAT TIME LENGHT, when CACHED.",
    function()
        given_that_cached_combat_lenght_is(tl.COMBAT_LENGHT)

        when_get_combat_lenght_is_called()

        then_the_returned_combat_lenght_was(tl.COMBAT_LENGHT)
    end)

    -- {{{
    local function given_that_cached_combat_damage_is_not_set()
        tl.CACHE.combat_damage = nil
    end

    local function when_get_combat_damage_is_called()
        results.combat_damage = esoTERM_char.get_combat_damage()
    end

    local function then_the_returned_combat_damage_was(start_time)
        assert.is.equal(start_time, results.combat_damage)
    end
    -- }}}

    it("Query COMBAT DAMAGE, when NOT CACHED.",
    function()
        given_that_cached_combat_damage_is_not_set()

        when_get_combat_damage_is_called()

        then_the_returned_combat_damage_was(0)
    end)

    -- {{{
    local function given_that_cached_combat_damage_is(start_time)
        tl.CACHE.combat_damage = start_time
    end
    -- }}}

    it("Query COMBAT DAMAGE, when CACHED.",
    function()
        given_that_cached_combat_damage_is(tl.COMBAT_DAMAGE)

        when_get_combat_damage_is_called()

        then_the_returned_combat_damage_was(tl.COMBAT_DAMAGE)
    end)

    -- {{{
    local function given_that_cached_last_xp_gain_time_is_not_set()
        tl.CACHE.last_xp_gain_time = nil
    end

    local function when_get_last_xp_gain_time_is_called()
        results.last_xp_gain_time = esoTERM_char.get_last_xp_gain_time()
    end

    local function then_the_returned_last_xp_gain_time_was(start_time)
        assert.is.equal(start_time, results.last_xp_gain_time)
    end
    -- }}}

    it("Query LAST XP GAIN TIME, when NOT CACHED.",
    function()
        given_that_cached_last_xp_gain_time_is_not_set()

        when_get_last_xp_gain_time_is_called()

        then_the_returned_last_xp_gain_time_was(0)
    end)

    -- {{{
    local function given_that_cached_last_xp_gain_time_is(time)
        tl.CACHE.last_xp_gain_time = time
    end
    -- }}}

    it("Query LAST XP GAIN TIME, when CACHED.",
    function()
        given_that_cached_last_xp_gain_time_is(tl.LAST_XP_GAIN_TIME)

        when_get_last_xp_gain_time_is_called()

        then_the_returned_last_xp_gain_time_was(tl.LAST_XP_GAIN_TIME)
    end)
end)

describe("The on combat-state-change event handler.", function()
    local EVENT = 1234
    local OUT_OF_COMBAT = false
    local IN_COMBAT = true
    local DEAD = true
    local ALIVE = false
    local EXIT_COMBAT_CALL_DELAY = 500
    local ENTER_TIME = 10
    local EXIT_TIME = 3010
    local EXIT_TIME_ONE_HIT = 210
    local DAMAGE = 9000
    local COMBAT_EXIT_TIME

    after_each(function()
        tl.CACHE.combat_state = nil
        tl.CACHE.combat_start_time = -1
        tl.CACHE.combat_lenght = 0
        tl.CACHE.combat_damage = -1
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cached_last_reported_combat_state_is(state)
        tl.CACHE.last_reported_combat_state = state
    end

    local function when_on_combat_state_update_is_called_with(...)
        esoTERM_char.on_combat_state_update(...)
    end

    local function then_cached_last_reported_combat_state_became(state)
        assert.is.equal(state, tl.CACHE.last_reported_combat_state)
    end
    -- }}}

    it("Call enter combat handler on in-combat event.", function()
        given_that_cached_last_reported_combat_state_is(nil)
            tl.and_that_enter_combat_is_stubbed()
            tl.and_that_zo_callLater_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, IN_COMBAT)

        then_cached_last_reported_combat_state_became(IN_COMBAT)
            tl.and_enter_combat_was_called()
            tl.and_zo_callLater_was_not_called()
    end)

    it("Call exit combat handler on out-of-combat event.", function()
        given_that_cached_last_reported_combat_state_is(nil)
            tl.and_that_enter_combat_is_stubbed()
            tl.and_that_zo_callLater_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_cached_last_reported_combat_state_became(OUT_OF_COMBAT)
            tl.and_enter_combat_was_not_called()
            tl.and_zo_callLater_was_called_with(esoTERM_char.exit_combat, 500)
    end)

    -- {{{
    local function given_that_cached_combat_state_is(state)
        tl.CACHE.combat_state = state
    end

    local function and_that_event_manager_register_for_event_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
    end

    local function and_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function when_enter_combat_is_called()
        esoTERM_char.enter_combat()
    end

    local function then_cached_combat_state_became(combat_state)
        assert.is.equal(combat_state, tl.CACHE.combat_state)
    end

    local function and_cached_combat_start_time_became(start_time)
        assert.is.equal(start_time, tl.CACHE.combat_start_time)
    end

    local function and_cached_combat_damage_became(damage)
        assert.is.equal(damage, tl.CACHE.combat_damage)
    end

    local function and_combat_event_handler_was_registered()
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            esoTERM_char,
            EVENT_COMBAT_EVENT,
            esoTERM_char.on_combat_event_update)
    end

    local function and_esoTERM_output_stdout_was_called_with(message)
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end
    -- }}}

    it("Enter combat handler.", function()
        given_that_cached_combat_state_is(OUT_OF_COMBAT)
            and_that_GetGameTimeMilliseconds_returns(ENTER_TIME)
            and_that_event_manager_register_for_event_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_enter_combat_is_called()

        then_cached_combat_state_became(IN_COMBAT)
            and_GetGameTimeMilliseconds_was_called()
            and_cached_combat_start_time_became(ENTER_TIME)
            and_cached_combat_damage_became(0)
            and_combat_event_handler_was_registered()
            and_esoTERM_output_stdout_was_called_with("Entered combat")
    end)

    -- {{{
    local function and_esoTERM_output_stdout_was_not_called()
        assert.spy(esoTERM_output.stdout).was_not.called()
    end
    -- }}}

    it("Enter combat handler returns when already in combat.", function()
        given_that_cached_combat_state_is(IN_COMBAT)
            and_that_GetGameTimeMilliseconds_returns(ENTER_TIME)
            and_that_event_manager_register_for_event_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_enter_combat_is_called()

        then_cached_combat_state_became(IN_COMBAT)
            and_GetGameTimeMilliseconds_was_not_called()
            and_register_for_event_was_not_called()
            and_esoTERM_output_stdout_was_not_called()
    end)

    -- {{{
    local function and_that_cached_combat_damage_is(damage)
        tl.CACHE.combat_damage = damage
    end

    local function when_exit_combat_is_called()
        esoTERM_char.exit_combat()
    end

    local function and_cached_combat_lenght_became(lenght)
        assert.is.equal(lenght, tl.CACHE.combat_lenght)
    end

    local function and_unregister_from_event_was_called_with(...)
        assert.spy(esoTERM_common.unregister_from_event).was.called_with(...)
    end

    local function get_exit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, damage: %d, dps: %.2f)",
            (EXIT_TIME - ENTER_TIME) / 1000,
            DAMAGE,
            DAMAGE * 1000 / (EXIT_TIME - ENTER_TIME))
    end
    -- }}}

    it("Exit combat handler.", function()
        given_that_cached_last_reported_combat_state_is(OUT_OF_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_get_combat_exit_time_returns(EXIT_TIME)
            and_that_unregister_from_event_is_stubbed()
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_exit_combat_is_called()

        then_cached_combat_state_became(OUT_OF_COMBAT)
            and_get_combat_start_time_was_called()
            and_get_combat_exit_time_was_called()
            and_cached_combat_lenght_became(EXIT_TIME - ENTER_TIME)
            and_unregister_from_event_was_called_with(esoTERM_char, EVENT_COMBAT_EVENT)
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_combat_message())
    end)

    -- {{{
    local function and_that_cached_combat_state_is(state)
        tl.CACHE.combat_state = state
    end

    local function and_that_cached_combat_start_time_is(time)
        tl.CACHE.combat_start_time = time
    end
    -- }}}

    it("Exit combat handler returns when still in combat.", function()
        given_that_cached_last_reported_combat_state_is(IN_COMBAT)
            and_that_cached_combat_state_is(IN_COMBAT)
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_get_combat_start_time_is_stubbed()
            and_that_get_combat_exit_time_is_stubbed()
            and_that_unregister_from_event_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_exit_combat_is_called()

        then_cached_combat_state_became(IN_COMBAT)
            and_cached_combat_start_time_became(ENTER_TIME)
            and_cached_combat_damage_became(DAMAGE)
            and_get_combat_start_time_was_not_called()
            and_get_combat_exit_time_was_not_called()
            and_unregister_from_event_was_not_called()
            and_esoTERM_output_stdout_was_not_called()
    end)

    it("Exit combat handler returns when already left combat.", function()
        given_that_cached_last_reported_combat_state_is(OUT_OF_COMBAT)
            and_that_cached_combat_state_is(OUT_OF_COMBAT)
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_get_combat_start_time_is_stubbed()
            and_that_get_combat_exit_time_is_stubbed()
            and_that_unregister_from_event_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_exit_combat_is_called()

        then_cached_combat_state_became(OUT_OF_COMBAT)
            and_cached_combat_start_time_became(ENTER_TIME)
            and_cached_combat_damage_became(DAMAGE)
            and_get_combat_start_time_was_not_called()
            and_get_combat_exit_time_was_not_called()
            and_unregister_from_event_was_not_called()
            and_esoTERM_output_stdout_was_not_called()
    end)

    -- {{{
    local function given_that_get_combat_state_returns(combat_state)
        ut_helper.stub_function(esoTERM_char, "get_combat_state", combat_state)
    end

    local function get_exit_one_hit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, damage: %d, dps: %.2f)",
            (EXIT_TIME_ONE_HIT - ENTER_TIME) / 1000,
            DAMAGE,
            DAMAGE)
    end
    -- }}}

    it("Onehit the enemy.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_get_combat_exit_time_returns(EXIT_TIME_ONE_HIT)
            and_that_unregister_from_event_is_stubbed()
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_cached_combat_state_became(OUT_OF_COMBAT)
            and_get_combat_start_time_was_called()
            and_cached_combat_lenght_became(EXIT_TIME_ONE_HIT - ENTER_TIME)
            and_unregister_from_event_was_called_with(esoTERM_char, EVENT_COMBAT_EVENT)
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_one_hit_combat_message())
    end)

    -- {{{
    local function given_that_on_combat_state_update_is_stubbed()
        ut_helper.stub_function(esoTERM_char, "on_combat_state_update", nil)
    end

    local function when_on_unit_death_state_change_is_called_with(...)
        esoTERM_char.on_unit_death_state_change(...)
    end

    local function then_on_combat_state_update_was_called_with(combat_state)
        assert.spy(esoTERM_char.on_combat_state_update).was.called_with(nil, combat_state)
    end
    -- }}}

    it("Character dies.", function()
        given_that_on_combat_state_update_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_unit_death_state_change_is_called_with(EVENT, PLAYER, DEAD)

        then_on_combat_state_update_was_called_with(OUT_OF_COMBAT)
            and_esoTERM_output_stdout_was_called_with("Died, you are pathetic!")
    end)

    -- {{{
    local function and_that_IsUnitInCombat_returns(combat_state)
        ut_helper.stub_function(GLOBAL, "IsUnitInCombat", combat_state)
    end

    local function and_IsUnitInCombat_was_called_once()
        assert.spy(GLOBAL.IsUnitInCombat).was.called_with(PLAYER)
    end

    local function and_cached_combat_state_became(combat_state)
        assert.is.equal(combat_state, tl.CACHE.combat_state)
    end
    -- }}}

    it("Character resurrected out of fight.", function()
        given_that_on_combat_state_update_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_IsUnitInCombat_returns(OUT_OF_COMBAT)

        when_on_unit_death_state_change_is_called_with(EVENT, PLAYER, ALIVE)

        then_on_combat_state_update_was_called_with(OUT_OF_COMBAT)
            and_esoTERM_output_stdout_was_called_with("Resurrected, watch out next time!")
            and_IsUnitInCombat_was_called_once()
            and_cached_combat_state_became(OUT_OF_COMBAT)
    end)

    it("Character resurrected in fight.", function()
        given_that_on_combat_state_update_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_IsUnitInCombat_returns(IN_COMBAT)

        when_on_unit_death_state_change_is_called_with(EVENT, PLAYER, ALIVE)

        then_on_combat_state_update_was_called_with(IN_COMBAT)
            and_esoTERM_output_stdout_was_called_with("Resurrected, watch out next time!")
            and_IsUnitInCombat_was_called_once()
            and_cached_combat_state_became(IN_COMBAT)
    end)

    it("Combat exit time is the laxt xp/vp gain time if there was xp/vp gain during combat.", function()
        given_that_get_last_xp_gain_time_returns(tl.LAST_XP_GAIN_TIME)
            and_that_GetGameTimeMilliseconds_is_stubbed()

        when_get_combat_exit_time_is_called()

        then_get_combat_exit_time_returned(tl.LAST_XP_GAIN_TIME)
            and_get_last_xp_gain_time_was_called()
            and_GetGameTimeMilliseconds_was_not_called()
    end)

    it("Combat exit time is the current game time if there was no xp/vp gain during combat.", function()
        given_that_get_last_xp_gain_time_returns(0)
            and_that_GetGameTimeMilliseconds_returns(EXIT_TIME)

        when_get_combat_exit_time_is_called()

        then_get_combat_exit_time_returned(EXIT_TIME - EXIT_COMBAT_CALL_DELAY)
            and_get_last_xp_gain_time_was_called()
            and_GetGameTimeMilliseconds_was_called()
    end)
end)

describe("The on combat event handler.", function()
    local DUMP_FORMAT = "EVENT -> r:%d+e:%s+an:%s+ag:%d+at:%d+s:%s+st:%d+t:%s+tt:%d+h:%d+p:%d+d:%d)"
    local NAME = "Hank"
    local ABILITY = "Orbital Strike"
    local ABILITY_HIT = 56789

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

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_parameter_value_is(parameter, value)
        parameter_values[parameter] = value
    end

    local function and_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function then_esoTERM_output_stdout_was_called_with(message)
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function then_esoTERM_output_stdout_was_not_called()
        assert.spy(esoTERM_output.stdout).was_not.called()
    end

    local function when_on_combat_event_update_is_called()
        esoTERM_char.on_combat_event_update(unpack(parameter_values))
    end
    -- }}}

    it("Discard event if invalid or not damage related.", function()
        local test_parameters = {
            [RESULT] = 1234567890,
            [RESULT] = ACTION_RESULT_HEAL,
            [RESULT] = ACTION_RESULT_CRITICAL_HEAL,
            [RESULT] = ACTION_RESULT_HOT_TICK,
            [RESULT] = ACTION_RESULT_HOT_TICK_CRITICAL,
            [EVENT_NOT_OK] = true,
            [SOURCE_NAME] = "",
            [TARGET_NAME] = "",
            [HIT_VALUE] = 0,
            [POWER_TYPE] = POWERTYPE_INVALID,
        }
        for parameter, value in pairs(test_parameters) do
            given_that_parameter_value_is(parameter, value)
                and_that_esoTERM_output_stdout_is_stubbed()

            when_on_combat_event_update_is_called()

            then_esoTERM_output_stdout_was_not_called()

            reset_event_parameters()
        end
    end)

    -- {{{
    local function get_damage_message()
        return string.format("Dealt damage with %s for: %d", ABILITY, ABILITY_HIT)
    end
    -- }}}

    it("Print message for damage done by player.", function()
        given_that_parameter_value_is(HIT_VALUE, ABILITY_HIT)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_event_update_is_called()

        then_esoTERM_output_stdout_was_called_with(get_damage_message())
    end)

    it("Print message for damage done by pet.", function()
        given_that_parameter_value_is(SOURCE_TYPE, COMBAT_UNIT_TYPE_PLAYER_PET)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_event_update_is_called()

        then_esoTERM_output_stdout_was_called_with(get_damage_message())
    end)
end)

describe("The on experience gain handlers.", function()
    local EVENT = 1234
    local REASON = 1
    local LEVEL = 2
    local PREVIOUS_EXPERIENCE = 3
    local CURRENT_EXPERIENCE = 4
    local RANK = 5
    local PREVIOUS_POINTS = 6
    local CURRENT_POINTS = 7

    it("Time of the last experience point gain for non-veteran character is stored.", function()
        given_that_cached_last_xp_gain_time_is_not_set()
            and_that_GetGameTimeMilliseconds_returns(tl.LAST_XP_GAIN_TIME)

        when_on_xp_gain_is_called_with(EVENT, REASON, LEVEL, PREVIOUS_EXPERIENCE, CURRENT_EXPERIENCE)

        then_cached_last_xp_gain_time_became(tl.LAST_XP_GAIN_TIME)
            and_GetGameTimeMilliseconds_was_called()
    end)

    it("Time of the last veteran point gain for veteran character is stored.", function()
        given_that_cached_last_xp_gain_time_is_not_set()
            and_that_GetGameTimeMilliseconds_returns(tl.LAST_XP_GAIN_TIME)

        when_on_vp_gain_is_called_with(EVENT, REASON, RANK, PREVIOUS_POINTS, CURRENT_POINTS)

        then_cached_last_xp_gain_time_became(tl.LAST_XP_GAIN_TIME)
            and_GetGameTimeMilliseconds_was_called()
    end)
end)

-- vim:fdm=marker
