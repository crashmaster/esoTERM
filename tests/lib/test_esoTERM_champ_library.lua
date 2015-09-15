local test_library = require("tests/lib/test_library")
local esoTERM_champ = require("esoTERM_champ")

test_esoTERM_champ_library = {}

test_esoTERM_champ_library.CACHE = esoTERM_champ.cache

test_esoTERM_champ_library.CHAMPION_XP_1 = test_library.A_INTEGER
test_esoTERM_champ_library.CHAMPION_XP_MAX_1 = test_library.A_INTEGER

local MODULE_NAME = "champion"

-- Module Name {{{
function test_esoTERM_champ_library.verify_that_esoTERM_champ_module_has_the_expected_name()
    assert.is.equal(MODULE_NAME, esoTERM_champ.module_name)
end
-- }}}

-- Initialization {{{
function test_esoTERM_champ_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_champ)
end

function test_esoTERM_champ_library.given_that_module_configured_as_inactive()
    test_library.configure_module_as_inactive(MODULE_NAME)
end

function test_esoTERM_champ_library.given_that_module_configured_as_active()
    test_library.configure_module_as_active(MODULE_NAME)
end

function test_esoTERM_champ_library.and_zo_savedvars_new_was_called()
    test_library.zo_savedvars_new_was_called_with_module(MODULE_NAME)
end

function test_esoTERM_champ_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_champ_library.and_register_module_was_called()
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, esoTERM_champ)
end

function test_esoTERM_champ_library.and_that_esoTERM_champ_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_champ, "activate")
end

function test_esoTERM_champ_library.then_esoTERM_champ_activate_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_champ.activate)
end

function test_esoTERM_champ_library.then_esoTERM_champ_activate_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_champ.activate)
end
-- }}}

test_esoTERM_champ_library.RETURN_VALUES_OF_THE_GETTER_STUBS = {
    get_champion_xp = test_esoTERM_champ_library.CHAMPION_XP_1,
    get_champion_xp_max = test_esoTERM_champ_library.CHAMPION_XP_MAX_1,
}

test_esoTERM_champ_library.EXPECTED_CACHED_VALUES = {
    champion_xp = test_esoTERM_champ_library.CHAMPION_XP_1,
    champion_xp_max = test_esoTERM_champ_library.CHAMPION_XP_MAX_1,
}

-- esoTERM_champ module activeness {{{
test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function test_esoTERM_champ_library.expected_register_for_event_calls_are_cleared()
    test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}
end

function test_esoTERM_champ_library.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_champ)
end

function test_esoTERM_champ_library.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_champ)
end

function test_esoTERM_champ_library.and_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_champ_library.CACHE))
end

function test_esoTERM_champ_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_champ_library.CACHE))
end

function test_esoTERM_champ_library.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

function test_esoTERM_champ_library.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function test_esoTERM_champ_library.and_that_expected_register_for_event_calls_are_set_up()
    test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.champion_xp_gained = {
        module = esoTERM_champ,
        event = EVENT_EXPERIENCE_UPDATE,
        callback = esoTERM_champ.on_experience_update
    }
    test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.champion_point_gained = {
        module = esoTERM_champ,
        event = EVENT_CHAMPION_POINT_GAINED,
        callback = esoTERM_champ.on_champion_point_gain
    }
end

local function character_is_not_eligible_for_champion_xp()
    test_library.stub_function_with_no_return_value(GLOBAL, "GetChampionXPInRank")
    test_library.stub_function_with_no_return_value(GLOBAL, "GetPlayerChampionPointsEarned")
end

-- Initialization {{{
function test_esoTERM_champ_library.given_that_character_is_not_eligible_for_champion_xp()
    character_is_not_eligible_for_champion_xp()
end

local function character_is_eligible_for_champion_xp()
    test_library.stub_function_with_return_value(GLOBAL, "GetChampionXPInRank", 1)
    test_library.stub_function_with_return_value(GLOBAL, "GetPlayerChampionPointsEarned", 1)
end

function test_esoTERM_champ_library.given_that_character_is_eligible_for_champion_xp()
    character_is_eligible_for_champion_xp()
end

function test_esoTERM_champ_library.and_that_character_is_eligible_for_champion_xp()
    character_is_eligible_for_champion_xp()
end

function test_esoTERM_champ_library.and_zo_savedvars_new_is_stubbed()
    test_library.stub_function_with_no_return_value(ZO_SavedVars, "New")
end

function test_esoTERM_champ_library.and_zo_savedvars_new_was_not_called()
    assert.spy(ZO_SavedVars.New).was_not.called()
end

function test_esoTERM_champ_library.and_register_module_was_not_called()
    assert.spy(esoTERM_common.register_module).was_not.called()
end

function test_esoTERM_champ_library.then_GetPlayerChampionPointsEarned_was_called()
    assert.spy(GLOBAL.GetPlayerChampionPointsEarned).was.called()
end

function test_esoTERM_champ_library.and_GetChampionXPInRank_was_called()
    assert.spy(GLOBAL.GetChampionXPInRank).was.called()
end
-- }}}

function test_esoTERM_champ_library.and_that_character_is_not_eligible_for_champion_xp()
    character_is_not_eligible_for_champion_xp()
end

function test_esoTERM_champ_library.when_activate_is_called()
    esoTERM_champ.activate()
end

function test_esoTERM_champ_library.when_deactivate_for_the_module_is_called()
    esoTERM_champ.deactivate()
end

function test_esoTERM_champ_library.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_champ)
end

function test_esoTERM_champ_library.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_champ)
end

function test_esoTERM_champ_library.and_register_for_event_was_called_with_expected_parameters()
    assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS))
    for param in pairs(test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS) do
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].module,
            test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].event,
            test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
        assert.is_not.equal(nil, test_esoTERM_champ_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
    end
end

function test_esoTERM_champ_library.and_unregister_from_all_events_was_called()
    assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(esoTERM_champ)
end

function test_esoTERM_champ_library.and_that_getter_functions_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_champ_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        test_library.stub_function_with_return_value(esoTERM_champ, getter, return_value)
    end
end

function test_esoTERM_champ_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_champ_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        assert.spy(esoTERM_champ[getter]).was.called_with()
    end
end

function test_esoTERM_champ_library.and_cached_values_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_champ_library.EXPECTED_CACHED_VALUES) do
        assert.is.equal(expected_value, test_esoTERM_champ_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_champ_library.and_module_is_active_was_saved()
    assert.is.equal(esoTERM_champ.settings[MODULE_NAME], true)
end

function test_esoTERM_champ_library.and_module_is_inactive_was_saved()
    assert.is.equal(esoTERM_champ.settings[MODULE_NAME], false)
end
-- }}}

function test_esoTERM_champ_library.given_that_esoTERM_output_stdout_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_output, "stdout")
end

function test_esoTERM_champ_library.then_esoTERM_output_stdout_was_called_with(message)
    assert.spy(esoTERM_output.stdout).was.called_with(message)
end

function test_esoTERM_champ_library.then_esoTERM_output_stdout_was_not_called()
    assert.spy(esoTERM_output.stdout).was_not.called()
end

function test_esoTERM_champ_library.then_esoTERM_output_stdout_was_called_with2(message1, message2)
    assert.spy(esoTERM_output.stdout).was.called_with(message1)
    assert.spy(esoTERM_output.stdout).was.called_with(message2)
end

function test_esoTERM_champ_library.and_that_GetPlayerChampionXP_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetPlayerChampionXP", xp)
end

function test_esoTERM_champ_library.and_that_GetChampionXPInRank_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetChampionXPInRank", xp)
end

function test_esoTERM_champ_library.and_that_champion_xp_before_was(xp)
    test_esoTERM_champ_library.CACHE.champion_xp = xp
end

local function set_champion_xp_max(xp)
    test_esoTERM_champ_library.CACHE.champion_xp_max = xp
end

function test_esoTERM_champ_library.and_that_champion_xp_max_is(xp)
    set_champion_xp_max(xp)
end

function test_esoTERM_champ_library.and_that_champion_xp_max_before_was(xp)
    set_champion_xp_max(xp)
end

function test_esoTERM_champ_library.and_champion_xp_max_became(xp)
    assert.is.equal(xp, test_esoTERM_champ_library.CACHE.champion_xp_max)
end

function test_esoTERM_champ_library.when_on_experience_update_is_called()
    esoTERM_champ.on_experience_update()
end

return test_esoTERM_champ_library

-- vim:fdm=marker
