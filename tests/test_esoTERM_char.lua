local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

local PLAYER = "player"

local A_BOOL = true
local B_BOOL = false
local A_INTEGER = 1111
local B_INTEGER = 2222
local A_STRING = "aAaAa"
local B_STRING = "bBbBb"

local GENDER_1 = A_STRING
local GENDER_2 = B_STRING
local CLASS_1 = A_STRING
local CLASS_2 = B_STRING
local NAME_1 = A_STRING
local NAME_2 = B_STRING
local COMBAT_STATE_1 = A_BOOL
local COMBAT_STATE_2 = B_BOOL
local COMBAT_START_TIME = A_INTEGER
local COMBAT_LENGHT = A_INTEGER
local COMBAT_DAMAGE = A_INTEGER

local CACHE = esoTERM_char.cache
local EVENT_REGISTER = esoTERM_char.event_register

describe("Test cache initialization.", function()
    local results = {}
    local return_values_of_the_getter_stubs = {
        get_gender = GENDER_1,
        get_class = CLASS_1,
        get_name = NAME_1,
        get_combat_state = COMBAT_STATE_1,
        get_combat_start_time = COMBAT_START_TIME,
        get_combat_lenght = COMBAT_LENGHT,
        get_combat_damage = COMBAT_DAMAGE
    }
    local expected_cached_values = {
        gender = GENDER_1,
        class = CLASS_1,
        name = NAME_1,
        combat_state = COMBAT_STATE_1,
        combat_start_time = COMBAT_START_TIME,
        combat_lenght = COMBAT_LENGHT,
        combat_damage = COMBAT_DAMAGE
    }

    local function setup_getter_stubs()
        for getter, return_value in pairs(return_values_of_the_getter_stubs) do
            ut_helper.stub_function(esoTERM_char, getter, return_value)
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

    local function when_initialize_is_called_with_cache()
        esoTERM_char.initialize()
    end

    local function then_cache_is_no_longer_empty()
        assert.is_not.equal(0, ut_helper.table_size(CACHE))
    end

    local function and_cached_values_became_initialized()
        for cache_attribute, expected_value in pairs(expected_cached_values) do
            assert.is.equal(expected_value, CACHE[cache_attribute])
        end
    end

    local function and_getter_stubs_were_called_with(param)
        for getter, _ in pairs(return_values_of_the_getter_stubs) do
            assert.spy(esoTERM_char[getter]).was.called_with(param)
        end
    end
    -- }}}

    it("Cached character info is updated.",
    function()
        given_that_cache_is_empty()

        when_initialize_is_called_with_cache()

        then_cache_is_no_longer_empty()
            and_cached_values_became_initialized()
            and_getter_stubs_were_called_with(CACHE)
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
        expected_register_params.combat_state_update = {
            addon_name = addon_name,
            event = EVENT_PLAYER_COMBAT_STATE,
            callback = esoTERM_char.on_combat_state_update
        }
        expected_register_params.death_state_update = {
            addon_name = addon_name,
            event = EVENT_UNIT_DEATH_STATE_CHANGED,
            callback = esoTERM_char.on_unit_death_state_change
        }
    end

    local function when_initialize_is_called()
        esoTERM_char.initialize()
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
        CACHE.name = nil
    end

    local function and_that_eso_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function when_get_name_is_called_with_cache()
        results.name = esoTERM_char.get_name(CACHE)
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
            and_that_eso_GetUnitName_returns(NAME_1)

        when_get_name_is_called_with_cache()

        then_the_returned_character_name_was(NAME_1)
            and_eso_GetUnitName_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        CACHE.name = name
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
        given_that_cached_character_name_is(NAME_1)
            and_that_eso_GetUnitName_returns(NAME_2)

        when_get_name_is_called_with_cache()

        then_the_returned_character_name_was(NAME_1)
            and_eso_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_gender_is_not_set()
        CACHE.gender = nil
    end

    local function and_that_eso_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function when_get_gender_is_called_with_cache()
        results.gender = esoTERM_char.get_gender(CACHE)
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
            and_that_eso_GetUnitGender_returns(GENDER_1)

        when_get_gender_is_called_with_cache()

        then_the_returned_character_gender_was(GENDER_1)
            and_eso_GetUnitGender_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_gender_is(gender)
        CACHE.gender = gender
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
        given_that_cached_character_gender_is(GENDER_1)
            and_that_eso_GetUnitGender_returns(GENDER_2)

        when_get_gender_is_called_with_cache()

        then_the_returned_character_gender_was(GENDER_1)
            and_eso_GetUnitGender_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_class_is_not_set()
        CACHE.class = nil
    end

    local function and_that_eso_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function when_get_class_is_called_with_cache()
        results.class = esoTERM_char.get_class(CACHE)
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
            and_that_eso_GetUnitClass_returns(CLASS_1)

        when_get_class_is_called_with_cache()

        then_the_returned_character_class_was(CLASS_1)
            and_eso_GetUnitClass_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_class_is(class)
        CACHE.class = class
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
        given_that_cached_character_class_is(CLASS_1)
            and_that_eso_GetUnitClass_returns(CLASS_2)

        when_get_class_is_called_with_cache()

        then_the_returned_character_class_was(CLASS_1)
            and_eso_GetUnitClass_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_combat_state_is_not_set()
        CACHE.combat_state = nil
    end

    local function and_that_IsUnitInCombat_returns(combat_state)
        ut_helper.stub_function(GLOBAL, "IsUnitInCombat", combat_state)
    end

    local function when_get_combat_state_is_called_with_cache()
        results.combat_state = esoTERM_char.get_combat_state(CACHE)
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
            and_that_IsUnitInCombat_returns(COMBAT_STATE_1)

        when_get_combat_state_is_called_with_cache()

        then_the_returned_character_combat_state_was(COMBAT_STATE_1)
            and_IsUnitInCombat_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_combat_state_is(combat_state)
        CACHE.combat_state = combat_state
    end

    local function and_that_IsUnitInCombat_returns(combat_state)
        ut_helper.stub_function(GLOBAL, "IsUnitInCombat", combat_state)
    end

    local function and_IsUnitInCombat_was_not_called()
        assert.spy(GLOBAL.IsUnitInCombat).was_not.called()
    end
    -- }}}

    it("Query CHARACTER IN-COMBAT-NESS, when CACHED.",
    function()
        given_that_cached_character_combat_state_is(COMBAT_STATE_1)
            and_that_IsUnitInCombat_returns(COMBAT_STATE_2)

        when_get_combat_state_is_called_with_cache()

        then_the_returned_character_combat_state_was(COMBAT_STATE_1)
            and_IsUnitInCombat_was_not_called()
    end)

    -- {{{
    local function given_that_cached_combat_start_time_is_not_set()
        CACHE.combat_start_time = nil
    end

    local function when_get_combat_start_time_is_called_with_cache()
        results.combat_start_time = esoTERM_char.get_combat_start_time(CACHE)
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
        CACHE.combat_start_time = start_time
    end
    -- }}}

    it("Query COMBAT TIME START, when CACHED.",
    function()
        given_that_cached_combat_start_time_is(COMBAT_START_TIME)

        when_get_combat_start_time_is_called_with_cache()

        then_the_returned_combat_start_time_was(COMBAT_START_TIME)
    end)

    -- {{{
    local function given_that_cached_combat_lenght_is_not_set()
        CACHE.combat_lenght = nil
    end

    local function when_get_combat_lenght_is_called_with_cache()
        results.combat_lenght = esoTERM_char.get_combat_lenght(CACHE)
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
        CACHE.combat_lenght = lenght
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
        CACHE.combat_lenght = lenght
    end
    -- }}}

    it("Query COMBAT TIME LENGHT, when CACHED.",
    function()
        given_that_cached_combat_lenght_is(COMBAT_LENGHT)

        when_get_combat_lenght_is_called_with_cache()

        then_the_returned_combat_lenght_was(COMBAT_LENGHT)
    end)

    -- {{{
    local function given_that_cached_combat_damage_is_not_set()
        CACHE.combat_damage = nil
    end

    local function when_get_combat_damage_is_called_with_cache()
        results.combat_damage = esoTERM_char.get_combat_damage(CACHE)
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
        CACHE.combat_damage = start_time
    end
    -- }}}

    it("Query COMBAT DAMAGE, when CACHED.",
    function()
        given_that_cached_combat_damage_is(COMBAT_DAMAGE)

        when_get_combat_damage_is_called_with_cache()

        then_the_returned_combat_damage_was(COMBAT_DAMAGE)
    end)
end)

describe("The on combat-state-change event handler.", function()
    local OUTER_COMBAT = false
    local IN_COMBAT = true
    local DEAD = true
    local ALIVE = false
    local ENTER_TIME = 10
    local EXIT_TIME = 1510
    local EXIT_TIME_ONE_HIT = 210
    local DAMAGE = 8000

    after_each(function()
        CACHE.combat_state = nil
        CACHE.combat_start_time = -1
        CACHE.combat_lenght = 0
        CACHE.combat_damage = -1
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

    local function and_that_event_manager_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_combat_event_handler_was_registered()
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
            EVENT_MANAGER,
            esoTERM.ADDON_NAME,
            EVENT_COMBAT_EVENT,
            esoTERM_char.on_combat_event_update
        )
        local active_event = EVENT_REGISTER[EVENT_COMBAT_EVENT]
        assert.is.equal(true, active_event == true)
    end

    local function when_on_combat_state_update_is_called_with(event, combat_state)
        esoTERM_char.on_combat_state_update(event, combat_state)
    end

    local function and_esoTERM_output_stdout_was_called_with(message)
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function then_the_and_cached_combat_state_became(comat_state)
        assert.is.equal(comat_state, CACHE.combat_state)
    end

    local function and_cached_combat_start_time_became(start_time)
        assert.is.equal(start_time, CACHE.combat_start_time)
    end

    local function and_cached_combat_damage_became(damage)
        assert.is.equal(damage, CACHE.combat_damage)
    end

    local function get_enter_combat_message()
        return "Entered combat"
    end
    -- }}}

    it("Character entered combat.", function()
        given_that_get_combat_state_returns(OUTER_COMBAT)
            and_that_eso_GetGameTimeMilliseconds_returns(ENTER_TIME)
            and_that_event_manager_RegisterForEvent_is_stubbed()
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
    local function when_on_unit_death_state_change_is_called_with(event, is_dead)
        esoTERM_char.on_unit_death_state_change(event, PLAYER, is_dead)
    end
    -- }}}

    it("Character resurrected.", function()
        given_that_get_combat_state_returns(OUTER_COMBAT)
            and_that_eso_GetGameTimeMilliseconds_returns(ENTER_TIME)
            and_that_event_manager_RegisterForEvent_is_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_unit_death_state_change_is_called_with(EVENT, ALIVE)

        then_the_and_cached_combat_state_became(IN_COMBAT)
            and_eso_GetGameTimeMilliseconds_was_called()
            and_cached_combat_start_time_became(ENTER_TIME)
            and_cached_combat_damage_became(0)
            and_combat_event_handler_was_registered()
            and_esoTERM_output_stdout_was_called_with(get_enter_combat_message())
    end)

    -- {{{
    local function and_that_event_manager_UnregisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
    end

    local function and_that_cached_combat_start_time_is(time)
        CACHE.combat_start_time = time
    end

    local function and_that_cached_combat_damage_is(damage)
        CACHE.combat_damage = damage
    end

    local function and_that_get_combat_start_time_returns(time)
        ut_helper.stub_function(esoTERM_char, "get_combat_start_time", time)
    end

    local function and_get_combat_start_time_was_called_once_with_cache()
        assert.spy(esoTERM_char.get_combat_start_time).was.called_with(CACHE)
    end

    local function and_cached_combat_lenght_became(lenght)
        assert.is.equal(lenght, CACHE.combat_lenght)
    end

    local function and_combat_event_handler_was_unregistered()
        assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
            EVENT_MANAGER,
            esoTERM.ADDON_NAME,
            EVENT_COMBAT_EVENT)
        local inactive_event = EVENT_REGISTER[EVENT_COMBAT_EVENT]
        assert.is.equal(true, inactive_event == false)
    end

    local function get_exit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, dps: %.2f)",
            (EXIT_TIME - ENTER_TIME) / 1000,
            DAMAGE * 1000 / (EXIT_TIME - ENTER_TIME))
    end
    -- }}}

    it("Character left combat.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME)
            and_that_event_manager_UnregisterForEvent_is_stubbed()
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

        then_the_and_cached_combat_state_became(OUTER_COMBAT)
            and_get_combat_start_time_was_called_once_with_cache()
            and_eso_GetGameTimeMilliseconds_was_called()
            and_cached_combat_lenght_became(EXIT_TIME - ENTER_TIME)
            and_combat_event_handler_was_unregistered()
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_combat_message())
    end)

    it("Character dies.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME)
            and_that_event_manager_UnregisterForEvent_is_stubbed()
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_unit_death_state_change_is_called_with(EVENT, DEAD)

        then_the_and_cached_combat_state_became(OUTER_COMBAT)
            and_get_combat_start_time_was_called_once_with_cache()
            and_eso_GetGameTimeMilliseconds_was_called()
            and_cached_combat_lenght_became(EXIT_TIME - ENTER_TIME)
            and_combat_event_handler_was_unregistered()
            and_cached_combat_start_time_became(0)
            and_cached_combat_damage_became(0)
            and_esoTERM_output_stdout_was_called_with(get_exit_combat_message())
    end)

    -- {{{
    local function get_exit_one_hit_combat_message()
        return string.format(
            "Left combat (lasted: %.2fs, dps: %.2f)",
            (EXIT_TIME_ONE_HIT - ENTER_TIME) / 1000, DAMAGE)
    end
    -- }}}

    it("Onehit the enemy.", function()
        given_that_get_combat_state_returns(IN_COMBAT)
            and_that_get_combat_start_time_returns(ENTER_TIME)
            and_that_eso_GetGameTimeMilliseconds_returns(EXIT_TIME_ONE_HIT)
            and_that_event_manager_UnregisterForEvent_is_stubbed()
            and_that_cached_combat_start_time_is(ENTER_TIME)
            and_that_cached_combat_damage_is(DAMAGE)
            and_that_esoTERM_output_stdout_is_stubbed()

        when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

        then_the_and_cached_combat_state_became(OUTER_COMBAT)
            and_get_combat_start_time_was_called_once_with_cache()
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
        given_that_get_combat_state_returns(OUTER_COMBAT)
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_eso_GetGameTimeMilliseconds_returns(nil)

        when_on_combat_state_update_is_called_with(EVENT, OUTER_COMBAT)

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
