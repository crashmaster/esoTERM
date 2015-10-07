-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_char_library")

local and_cache_is_no_longer_empty = tl.and_cache_is_no_longer_empty
local and_cached_values_became_initialized = tl.and_cached_values_became_initialized
local and_getter_function_stubs_were_called = tl.and_getter_function_stubs_were_called
local and_module_became_active = tl.and_module_became_active
local and_module_is_active_was_saved = tl.and_module_is_active_was_saved
local and_module_is_inactive_was_saved = tl.and_module_is_inactive_was_saved
local and_register_for_event_was_called_with_expected_parameters = tl.and_register_for_event_was_called_with_expected_parameters
local and_register_module_was_called = tl.and_register_module_was_called
local and_register_module_was_called = tl.and_register_module_was_called
local and_that_cache_is_empty = tl.and_that_cache_is_empty
local and_that_esoTERM_char_activate_is_stubbed = tl.and_that_esoTERM_char_activate_is_stubbed
local and_that_esoTERM_char_activate_is_stubbed = tl.and_that_esoTERM_char_activate_is_stubbed
local and_that_expected_register_for_event_calls_are_set_up = tl.and_that_expected_register_for_event_calls_are_set_up
local and_that_getter_functions_are_stubbed = tl.and_that_getter_functions_are_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called = tl.and_unregister_from_all_events_was_called
local and_zo_savedvars_new_was_called = tl.and_zo_savedvars_new_was_called
local and_zo_savedvars_new_was_called = tl.and_zo_savedvars_new_was_called
local expected_register_for_event_calls_are_cleared = tl.expected_register_for_event_calls_are_cleared
local given_that_module_configured_as_active = tl.given_that_module_configured_as_active
local given_that_module_configured_as_inactive = tl.given_that_module_configured_as_inactive
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_esoTERM_char_activate_was_called = tl.then_esoTERM_char_activate_was_called
local then_esoTERM_char_activate_was_not_called = tl.then_esoTERM_char_activate_was_not_called
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_esoTERM_char_module_has_the_expected_name = tl.verify_that_esoTERM_char_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_for_the_module_is_called = tl.when_deactivate_for_the_module_is_called
local when_initialize_is_called = tl.when_initialize_is_called
local when_initialize_is_called = tl.when_initialize_is_called
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
            and_that_esoTERM_char_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_char_activate_was_not_called()
            and_zo_savedvars_new_was_called()
            and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        given_that_module_configured_as_active()
            and_that_register_module_is_stubbed()
            and_that_esoTERM_char_activate_is_stubbed()

        when_initialize_is_called()

        then_esoTERM_char_activate_was_called()
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

    local function and_that_eso_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function when_get_name_is_called_with_cache()
        results.name = esoTERM_char.get_name()
    end

    local function then_the_returned_character_name_was(name)
        assert.is.equal(name, results.name)
    end

    local function and_eso_GetUnitName_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitName).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER NAME, when NOT CACHED.",
    function()
        given_that_cached_character_name_is_not_set()
            and_that_eso_GetUnitName_returns(tl.NAME_1)

        when_get_name_is_called_with_cache()

        then_the_returned_character_name_was(tl.NAME_1)
            and_eso_GetUnitName_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        tl.CACHE.name = name
    end

    local function and_that_eso_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function and_eso_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Query CHARACTER NAME, when CACHED.",
    function()
        given_that_cached_character_name_is(tl.NAME_1)
            and_that_eso_GetUnitName_returns(NAME_2)

        when_get_name_is_called_with_cache()

        then_the_returned_character_name_was(tl.NAME_1)
            and_eso_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_gender_is_not_set()
        tl.CACHE.gender = nil
    end

    local function and_that_eso_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function when_get_gender_is_called_with_cache()
        results.gender = esoTERM_char.get_gender()
    end

    local function then_the_returned_character_gender_was(gender)
        assert.is.equal(gender, results.gender)
    end

    local function and_eso_GetUnitGender_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitGender).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER GENDER, when NOT CACHED.",
    function()
        given_that_cached_character_gender_is_not_set()
            and_that_eso_GetUnitGender_returns(tl.GENDER_1)

        when_get_gender_is_called_with_cache()

        then_the_returned_character_gender_was(tl.GENDER_1)
            and_eso_GetUnitGender_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_gender_is(gender)
        tl.CACHE.gender = gender
    end

    local function and_that_eso_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function and_eso_GetUnitGender_was_not_called()
        assert.spy(GLOBAL.GetUnitGender).was_not.called()
    end
    -- }}}

    it("Query CHARACTER GENDER, when CACHED.",
    function()
        given_that_cached_character_gender_is(tl.GENDER_1)
            and_that_eso_GetUnitGender_returns(GENDER_2)

        when_get_gender_is_called_with_cache()

        then_the_returned_character_gender_was(tl.GENDER_1)
            and_eso_GetUnitGender_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_class_is_not_set()
        tl.CACHE.class = nil
    end

    local function and_that_eso_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function when_get_class_is_called_with_cache()
        results.class = esoTERM_char.get_class()
    end

    local function then_the_returned_character_class_was(class)
        assert.is.equal(class, results.class)
    end

    local function and_eso_GetUnitClass_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitClass).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER CLASS, when NOT CACHED.",
    function()
        given_that_cached_character_class_is_not_set()
            and_that_eso_GetUnitClass_returns(tl.CLASS_1)

        when_get_class_is_called_with_cache()

        then_the_returned_character_class_was(tl.CLASS_1)
            and_eso_GetUnitClass_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_class_is(class)
        tl.CACHE.class = class
    end

    local function and_that_eso_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function and_eso_GetUnitClass_was_not_called()
        assert.spy(GLOBAL.GetUnitClass).was_not.called()
    end
    -- }}}

    it("Query CHARACTER CLASS, when CACHED.",
    function()
        given_that_cached_character_class_is(tl.CLASS_1)
            and_that_eso_GetUnitClass_returns(CLASS_2)

        when_get_class_is_called_with_cache()

        then_the_returned_character_class_was(tl.CLASS_1)
            and_eso_GetUnitClass_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_combat_state_is_not_set()
        tl.CACHE.combat_state = nil
    end

    local function and_that_IsUnitInCombat_returns(combat_state)
        ut_helper.stub_function(GLOBAL, "IsUnitInCombat", combat_state)
    end

    local function when_get_combat_state_is_called_with_cache()
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

        when_get_combat_state_is_called_with_cache()

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

        when_get_combat_state_is_called_with_cache()

        then_the_returned_character_combat_state_was(tl.COMBAT_STATE_1)
            and_IsUnitInCombat_was_not_called()
    end)

    -- {{{
    local function given_that_cached_combat_start_time_is_not_set()
        tl.CACHE.combat_start_time = nil
    end

    local function when_get_combat_start_time_is_called_with_cache()
        results.combat_start_time = esoTERM_char.get_combat_start_time()
    end

    local function then_the_returned_combat_start_time_was(start_time)
        assert.is.equal(start_time, results.combat_start_time)
    end
    -- }}}

    it("Query COMBAT TIME START, when NOT CACHED.",
    function()
        given_that_cached_combat_start_time_is_not_set()

        when_get_combat_start_time_is_called_with_cache()

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

        when_get_combat_start_time_is_called_with_cache()

        then_the_returned_combat_start_time_was(tl.COMBAT_START_TIME)
    end)

    -- {{{
    local function given_that_cached_combat_lenght_is_not_set()
        tl.CACHE.combat_lenght = nil
    end

    local function when_get_combat_lenght_is_called_with_cache()
        results.combat_lenght = esoTERM_char.get_combat_lenght()
    end

    local function then_the_returned_combat_lenght_was(lenght)
        assert.is.equal(lenght, results.combat_lenght)
    end
    -- }}}

    it("Query COMBAT TIME LENGHT, when NOT CACHED.",
    function()
        given_that_cached_combat_lenght_is_not_set()

        when_get_combat_lenght_is_called_with_cache()

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

        when_get_combat_lenght_is_called_with_cache()

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

        when_get_combat_lenght_is_called_with_cache()

        then_the_returned_combat_lenght_was(tl.COMBAT_LENGHT)
    end)

    -- {{{
    local function given_that_cached_combat_damage_is_not_set()
        tl.CACHE.combat_damage = nil
    end

    local function when_get_combat_damage_is_called_with_cache()
        results.combat_damage = esoTERM_char.get_combat_damage()
    end

    local function then_the_returned_combat_damage_was(start_time)
        assert.is.equal(start_time, results.combat_damage)
    end
    -- }}}

    it("Query COMBAT DAMAGE, when NOT CACHED.",
    function()
        given_that_cached_combat_damage_is_not_set()

        when_get_combat_damage_is_called_with_cache()

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

        when_get_combat_damage_is_called_with_cache()

        then_the_returned_combat_damage_was(tl.COMBAT_DAMAGE)
    end)
end)

describe("The on combat-state-change event handler.", function()
    local OUT_OF_COMBAT = false
    local IN_COMBAT = true
    local DEAD = true
    local ALIVE = false
    local EXIT_COMBAT_CALL_DELAY = 500
    local ENTER_TIME = 10
    local EXIT_TIME = 3010 + EXIT_COMBAT_CALL_DELAY
    local EXIT_TIME_ONE_HIT = 210 + EXIT_COMBAT_CALL_DELAY
    local DAMAGE = 9000

    after_each(function()
        tl.CACHE.last_reported_combat_state = nil
        tl.CACHE.combat_state = nil
        tl.CACHE.combat_start_time = -1
        tl.CACHE.combat_lenght = 0
        tl.CACHE.combat_damage = -1
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_get_combat_state_returns(combat_state)
        ut_helper.stub_function(esoTERM_char, "get_combat_state", combat_state)
    end

    local function and_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function and_that_eso_GetGameTimeMilliseconds_returns(time)
        ut_helper.stub_function(GLOBAL, "GetGameTimeMilliseconds", time)
    end

    local function and_eso_GetGameTimeMilliseconds_was_called()
        assert.spy(GLOBAL.GetGameTimeMilliseconds).was.called()
    end

    local function and_that_event_manager_register_for_event_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
    end

    local function and_combat_event_handler_was_registered()
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            esoTERM_char,
            EVENT_COMBAT_EVENT,
            esoTERM_char.on_combat_event_update)
    end

    local function when_on_combat_state_update_is_called_with(event, combat_state)
        esoTERM_char.on_combat_state_update(event, combat_state)
    end

    local function and_esoTERM_output_stdout_was_called_with(message)
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function then_the_and_cached_combat_state_became(combat_state)
        assert.is.equal(combat_state, tl.CACHE.combat_state)
    end

    local function and_cached_combat_start_time_became(start_time)
        assert.is.equal(start_time, tl.CACHE.combat_start_time)
    end

    local function and_cached_combat_damage_became(damage)
        assert.is.equal(damage, tl.CACHE.combat_damage)
    end

    local function get_enter_combat_message()
        return "Entered combat"
    end
    -- }}}

    it("Character entered combat.", function()
        given_that_get_combat_state_returns(OUT_OF_COMBAT)
            and_that_eso_GetGameTimeMilliseconds_returns(ENTER_TIME)
            and_that_event_manager_register_for_event_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, IN_COMBAT)

        then_the_and_cached_combat_state_became(IN_COMBAT)
            and_eso_GetGameTimeMilliseconds_was_called()
            and_cached_combat_start_time_became(ENTER_TIME)
            and_cached_combat_damage_became(0)
            and_combat_event_handler_was_registered()
            and_esoTERM_output_stdout_was_called_with(get_enter_combat_message())
    end)

    -- {{{
    local function given_that_cached_last_reported_combat_state_is_nil()
        if tl.CACHE.last_reported_combat_state ~= nil then
            assert.is_true(false)
        else
            assert.is_true(true)
        end
    end

    local function then_cached_last_reported_combat_state_became(state)
        assert.is.equal(state, tl.CACHE.last_reported_combat_state)
    end
    -- }}}

    it("Character enters combat.", function()
        given_that_cached_last_reported_combat_state_is_nil()
            tl.and_that_esoTERM_char_enter_combat_is_stubbed()
            tl.and_that_eso_zo_callLater_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, IN_COMBAT)

        then_cached_last_reported_combat_state_became(IN_COMBAT)
            tl.and_esoTERM_char_enter_combat_was_called()
            tl.and_eso_zo_callLater_was_not_called()
    end)

    it("Character enters combat.", function()
        given_that_cached_last_reported_combat_state_is_nil()
            tl.and_that_esoTERM_char_enter_combat_is_stubbed()
            tl.and_that_eso_zo_callLater_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_cached_last_reported_combat_state_became(OUT_OF_COMBAT)
            tl.and_esoTERM_char_enter_combat_was_not_called()
            tl.and_eso_zo_callLater_was_called_with(esoTERM_char.exit_combat, 500)
    end)

    -- {{{
    local function and_that_event_manager_unregister_from_event_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "unregister_from_event", nil)
    end

    local function and_that_cached_combat_start_time_is(time)
        tl.CACHE.combat_start_time = time
    end

    local function and_that_cached_combat_damage_is(damage)
        tl.CACHE.combat_damage = damage
    end

    local function and_that_get_combat_start_time_returns(time)
        ut_helper.stub_function(esoTERM_char, "get_combat_start_time", time)
    end

    local function and_get_combat_start_time_was_called()
        assert.spy(esoTERM_char.get_combat_start_time).was.called_with()
    end

    local function and_cached_combat_lenght_became(lenght)
        assert.is.equal(lenght, tl.CACHE.combat_lenght)
    end

    local function and_combat_event_handler_was_unregistered()
        assert.spy(esoTERM_common.unregister_from_event).was.called_with(
            esoTERM_char, EVENT_COMBAT_EVENT)
    end

    local function get_exit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, damage: %d, dps: %.2f)",
            (EXIT_TIME - ENTER_TIME - EXIT_COMBAT_CALL_DELAY) / 1000,
            DAMAGE,
            DAMAGE * 1000 / (EXIT_TIME - ENTER_TIME - EXIT_COMBAT_CALL_DELAY))
    end
    -- }}}

    it("Character left combat.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME)
            and_that_event_manager_unregister_from_event_is_stubbed()
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_the_and_cached_combat_state_became(OUT_OF_COMBAT)
            and_get_combat_start_time_was_called()
            and_eso_GetGameTimeMilliseconds_was_called()
            and_cached_combat_lenght_became(EXIT_TIME - ENTER_TIME)
            and_combat_event_handler_was_unregistered()
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_combat_message())
    end)

    -- {{{
    local function given_that_on_combat_state_update_is_stubbed()
        ut_helper.stub_function(esoTERM_char, "on_combat_state_update", nil)
    end

    local function when_on_unit_death_state_change_is_called_with(event, is_dead)
        esoTERM_char.on_unit_death_state_change(event, PLAYER, is_dead)
    end

    local function then_on_combat_state_update_was_called_with(combat_state)
        assert.spy(esoTERM_char.on_combat_state_update).was.called_with(nil, combat_state)
    end
    -- }}}

    it("Character dies.", function()
        given_that_on_combat_state_update_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_unit_death_state_change_is_called_with(EVENT, DEAD)

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

        when_on_unit_death_state_change_is_called_with(EVENT, ALIVE)

        then_on_combat_state_update_was_called_with(OUT_OF_COMBAT)
            and_esoTERM_output_stdout_was_called_with("Resurrected, watch out next time!")
            and_IsUnitInCombat_was_called_once()
            and_cached_combat_state_became(OUT_OF_COMBAT)
    end)

    it("Character resurrected in fight.", function()
        given_that_on_combat_state_update_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_IsUnitInCombat_returns(IN_COMBAT)

        when_on_unit_death_state_change_is_called_with(EVENT, ALIVE)

        then_on_combat_state_update_was_called_with(IN_COMBAT)
            and_esoTERM_output_stdout_was_called_with("Resurrected, watch out next time!")
            and_IsUnitInCombat_was_called_once()
            and_cached_combat_state_became(IN_COMBAT)
    end)

    -- {{{
    local function get_exit_one_hit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, damage: %d, dps: %.2f)",
            (EXIT_TIME_ONE_HIT - ENTER_TIME - EXIT_COMBAT_CALL_DELAY) / 1000,
            DAMAGE,
            DAMAGE)
    end
    -- }}}

    it("Onehit the enemy.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME_ONE_HIT)
            and_that_event_manager_unregister_from_event_is_stubbed()
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_the_and_cached_combat_state_became(OUT_OF_COMBAT)
            and_get_combat_start_time_was_called()
            and_cached_combat_lenght_became(EXIT_TIME_ONE_HIT - ENTER_TIME)
            and_combat_event_handler_was_unregistered()
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_one_hit_combat_message())
    end)

    -- {{{
    local function then_esoTERM_output_stdout_was_not_called()
        assert.spy(esoTERM_output.stdout).was_not.called()
    end

    local function and_eso_GetGameTimeMilliseconds_was_not_called()
        assert.spy(GLOBAL.GetGameTimeMilliseconds).was_not.called()
    end
    -- }}}

    it("No combat-state-change, when already having that state", function()
        given_that_get_combat_state_returns(OUT_OF_COMBAT)
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_eso_GetGameTimeMilliseconds_returns(nil)

        when_on_combat_state_update_is_called_with(EVENT, OUT_OF_COMBAT)

        then_esoTERM_output_stdout_was_not_called()
            and_eso_GetGameTimeMilliseconds_was_not_called()
    end)
end)

describe("The on combat event handler.", function()
    local DUMP_FORMAT = "EVENT -> r:%d+e:%s+an:%s+ag:%d+at:%d+s:%s+st:%d+t:%s+tt:%d+h:%d+p:%d+d:%d)"
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

-- vim:fdm=marker
