local test_library = require("tests/lib/test_library")
local esoTERM_char = require("esoTERM_char")

test_esoTERM_char_library = {}

test_esoTERM_char_library.CACHE = esoTERM_char.cache

test_esoTERM_char_library.GENDER_1 = test_library.A_STRING
test_esoTERM_char_library.GENDER_2 = test_library.B_STRING
test_esoTERM_char_library.CLASS_1 = test_library.C_STRING
test_esoTERM_char_library.CLASS_2 = test_library.D_STRING
test_esoTERM_char_library.NAME_1 = test_library.E_STRING
test_esoTERM_char_library.NAME_2 = test_library.F_STRING

test_esoTERM_char_library.COMBAT_STATE_1 = test_library.A_BOOL
test_esoTERM_char_library.COMBAT_STATE_2 = test_library.B_BOOL

test_esoTERM_char_library.COMBAT_START_TIME = test_library.A_INTEGER
test_esoTERM_char_library.COMBAT_LENGHT = test_library.B_INTEGER
test_esoTERM_char_library.COMBAT_DAMAGE = test_library.C_INTEGER
test_esoTERM_char_library.LAST_XP_GAIN_TIME = test_library.D_INTEGER

test_esoTERM_char_library.GET_COMBAT_EXIT_TIME_RESULT = nil

local MODULE_NAME = "character"

-- Module Name {{{
function test_esoTERM_char_library.verify_that_module_has_the_expected_name(module, expected_name)
    assert.is.equal(expected_name, module.module_name)
end
-- }}}

-- Initialization {{{
function test_esoTERM_char_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_char)
end

function test_esoTERM_char_library.given_that_module_is_set_inactive_in_the_config_file(...)
    test_library.set_module_to_inactive_in_config_file(...)
end

function test_esoTERM_char_library.given_that_module_is_set_active_in_the_config_file(...)
    test_library.set_module_to_active_in_config_file(...)
end

function test_esoTERM_char_library.and_ZO_SavedVars_new_was_called_with(...)
    test_library.ZO_SavedVars_new_was_called_with_module(...)
end

function test_esoTERM_char_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_char_library.and_register_module_was_called_with(...)
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, ...)
end

function test_esoTERM_char_library.and_that_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_char, "activate")
end

function test_esoTERM_char_library.then_activate_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_char.activate)
end

function test_esoTERM_char_library.then_activate_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_char.activate)
end
-- }}}

test_esoTERM_char_library.RETURN_VALUES_OF_THE_GETTER_STUBS = {
    get_gender = test_esoTERM_char_library.GENDER_1,
    get_class = test_esoTERM_char_library.CLASS_1,
    get_name = test_esoTERM_char_library.NAME_1,
    get_combat_state = test_esoTERM_char_library.COMBAT_STATE_1,
    get_combat_start_time = test_esoTERM_char_library.COMBAT_START_TIME,
    get_combat_lenght = test_esoTERM_char_library.COMBAT_LENGHT,
    get_combat_damage = test_esoTERM_char_library.COMBAT_DAMAGE,
    get_last_xp_gain_time = test_esoTERM_char_library.LAST_XP_GAIN_TIME,
}

test_esoTERM_char_library.EXPECTED_CACHED_VALUES = {
    gender = test_esoTERM_char_library.GENDER_1,
    class = test_esoTERM_char_library.CLASS_1,
    name = test_esoTERM_char_library.NAME_1,
    combat_state = test_esoTERM_char_library.COMBAT_STATE_1,
    combat_start_time = test_esoTERM_char_library.COMBAT_START_TIME,
    combat_lenght = test_esoTERM_char_library.COMBAT_LENGHT,
    combat_damage = test_esoTERM_char_library.COMBAT_DAMAGE,
    last_xp_gain_time = test_esoTERM_char_library.LAST_XP_GAIN_TIME,
}

-- register_for_event {{{
function test_esoTERM_char_library.get_expected_register_for_event_call_parameters()
    return {
        {
            module = esoTERM_char,
            event = EVENT_PLAYER_COMBAT_STATE,
            callback = esoTERM_char.on_combat_state_update
        },
        {
            module = esoTERM_char,
            event = EVENT_UNIT_DEATH_STATE_CHANGED,
            callback = esoTERM_char.on_unit_death_state_change
        },
        {
            module = esoTERM_char,
            event = EVENT_EXPERIENCE_GAIN,
            callback = esoTERM_char.on_xp_gain
        },
        {
            module = esoTERM_char,
            event = EVENT_VETERAN_POINTS_GAIN,
            callback = esoTERM_char.on_vp_gain
        },
    }
end

function test_esoTERM_char_library.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

function test_esoTERM_char_library.and_register_for_event_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

function test_esoTERM_char_library.and_register_for_event_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_common.register_for_event)
end
-- }}}

-- getter {{{
function test_esoTERM_char_library.and_that_getter_functions_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_char_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        test_library.stub_function_with_return_value(esoTERM_char, getter, return_value)
    end
end

function test_esoTERM_char_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_char_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        test_library.stub_function_called_without_arguments(esoTERM_char[getter])
    end
end
-- }}}

-- unregister_from_all_events {{{
function test_esoTERM_char_library.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function test_esoTERM_char_library.and_unregister_from_all_events_was_called_with(...)
    test_library.stub_function_called_with_arguments(esoTERM_common.unregister_from_all_events, esoTERM_char)
end
-- }}}

-- cache {{{
function test_esoTERM_char_library.given_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_char_library.CACHE))
end

function test_esoTERM_char_library.then_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_char_library.CACHE))
end

function test_esoTERM_char_library.and_cached_values_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_char_library.EXPECTED_CACHED_VALUES) do
        assert.is.equal(expected_value, test_esoTERM_char_library.CACHE[cache_attribute])
    end
end
-- }}}

-- deactivate {{{
function test_esoTERM_char_library.when_deactivate_is_called()
    esoTERM_char.deactivate()
end
-- }}}

-- esoTERM_char module activeness {{{
function test_esoTERM_char_library.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_char)
end

function test_esoTERM_char_library.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_char)
end

function test_esoTERM_char_library.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_char)
end

function test_esoTERM_char_library.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_char)
end

function test_esoTERM_char_library.and_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_char_library.CACHE))
end

function test_esoTERM_char_library.when_activate_is_called()
    esoTERM_char.activate()
end

function test_esoTERM_char_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_char_library.CACHE))
end

function test_esoTERM_char_library.and_active_state_of_the_module_was_saved()
    assert.is.equal(esoTERM_char.settings[MODULE_NAME], true)
end

function test_esoTERM_char_library.and_inactive_state_of_the_module_was_saved()
    assert.is.equal(esoTERM_char.settings[MODULE_NAME], false)
end
-- }}}

-- enter_combat {{{
function test_esoTERM_char_library.and_that_enter_combat_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_char, "enter_combat")
end

function test_esoTERM_char_library.and_enter_combat_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_char.enter_combat)
end

function test_esoTERM_char_library.and_enter_combat_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_char.enter_combat)
end
-- }}}

-- zo_callLater {{{
function test_esoTERM_char_library.and_that_zo_callLater_is_stubbed()
    test_library.stub_function_with_no_return_value(GLOBAL, "zo_callLater")
end

function test_esoTERM_char_library.and_zo_callLater_was_called_with(...)
    test_library.stub_function_called_with_arguments(GLOBAL.zo_callLater, ...)
end

function test_esoTERM_char_library.and_zo_callLater_was_not_called()
    test_library.stub_function_was_not_called(GLOBAL.zo_callLater)
end
-- }}}

-- GetGameTimeMilliseconds {{{
function test_esoTERM_char_library.and_that_GetGameTimeMilliseconds_returns(...)
    test_library.stub_function_with_return_value(GLOBAL, "GetGameTimeMilliseconds", ...)
end

function test_esoTERM_char_library.and_that_GetGameTimeMilliseconds_is_stubbed()
    test_esoTERM_char_library.and_that_GetGameTimeMilliseconds_returns(nil)
end

function test_esoTERM_char_library.and_GetGameTimeMilliseconds_was_called()
    test_library.stub_function_called_without_arguments(GLOBAL.GetGameTimeMilliseconds)
end

function test_esoTERM_char_library.and_GetGameTimeMilliseconds_was_not_called()
    test_library.stub_function_was_not_called(GLOBAL.GetGameTimeMilliseconds)
end
-- }}}

-- get_combat_start_time {{{
function test_esoTERM_char_library.and_that_get_combat_start_time_returns(...)
    test_library.stub_function_with_return_value(esoTERM_char, "get_combat_start_time", ...)
end

function test_esoTERM_char_library.and_that_get_combat_start_time_is_stubbed()
    test_esoTERM_char_library.and_that_get_combat_start_time_returns(nil)
end

function test_esoTERM_char_library.and_get_combat_start_time_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_char.get_combat_start_time)
end

function test_esoTERM_char_library.and_get_combat_start_time_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_char.get_combat_start_time)
end
-- }}}

-- unregister_from_event {{{
function test_esoTERM_char_library.and_that_unregister_from_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_event")
end

function test_esoTERM_char_library.and_unregister_from_event_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_common.unregister_from_event)
end
-- }}}

-- on_xp_gain {{{
function test_esoTERM_char_library.when_on_xp_gain_is_called_with(...)
    esoTERM_char.on_xp_gain(...)
end
-- }}}

-- on_vp_gain {{{
function test_esoTERM_char_library.when_on_vp_gain_is_called_with(...)
    esoTERM_char.on_vp_gain(...)
end
-- }}}

-- cached_last_xp_gain_time {{{
function test_esoTERM_char_library.given_that_cached_last_xp_gain_time_is_not_set()
    test_esoTERM_char_library.CACHE.last_xp_gain_time = nil
end

function test_esoTERM_char_library.then_cached_last_xp_gain_time_became(time)
    assert.is.equal(time, test_esoTERM_char_library.CACHE.last_xp_gain_time)
end
-- }}}

-- get_last_xp_gain_time {{{
function test_esoTERM_char_library.given_that_get_last_xp_gain_time_returns(...)
    test_library.stub_function_with_return_value(esoTERM_char, "get_last_xp_gain_time", ...)
end

function test_esoTERM_char_library.and_get_last_xp_gain_time_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_char.get_last_xp_gain_time)
end
-- }}}

-- {{{
function test_esoTERM_char_library.when_get_combat_exit_time_is_called()
    test_esoTERM_char_library.GET_COMBAT_EXIT_TIME_RESULT = esoTERM_char.get_combat_exit_time()
end

function test_esoTERM_char_library.then_get_combat_exit_time_returned(...)
    assert.is.equal(..., test_esoTERM_char_library.GET_COMBAT_EXIT_TIME_RESULT)
end

function test_esoTERM_char_library.and_that_get_combat_exit_time_returns(...)
    test_library.stub_function_with_return_value(esoTERM_char, "get_combat_exit_time", ...)
end

function test_esoTERM_char_library.and_that_get_combat_exit_time_is_stubbed()
    test_esoTERM_char_library.and_that_get_combat_exit_time_returns(nil)
end

function test_esoTERM_char_library.and_get_combat_exit_time_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_char.get_combat_exit_time)
end

function test_esoTERM_char_library.and_get_combat_exit_time_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_char.get_combat_exit_time)
end
-- }}}

return test_esoTERM_char_library
