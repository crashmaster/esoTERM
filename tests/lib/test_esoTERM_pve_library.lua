local test_library = require("tests/lib/test_library")
local esoTERM_pve = require("esoTERM_pve")

test_esoTERM_pve_library = {}

test_esoTERM_pve_library.CACHE = esoTERM_pve.cache
test_esoTERM_pve_library.EVENT_REGISTER = esoTERM_pve.event_register

test_esoTERM_pve_library.VETERANNESS_1 = test_library.A_BOOL
test_esoTERM_pve_library.VETERANNESS_2 = test_library.B_BOOL

test_esoTERM_pve_library.LEVEL_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_1 = test_library.C_INTEGER
test_esoTERM_pve_library.LEVEL_XP_2 = test_library.D_INTEGER
test_esoTERM_pve_library.LEVEL_VP_1 = test_library.E_INTEGER
test_esoTERM_pve_library.LEVEL_VP_2 = test_library.F_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_1 = test_library.G_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_2 = test_library.H_INTEGER
test_esoTERM_pve_library.LEVEL_VP_MAX_1 = test_library.I_INTEGER
test_esoTERM_pve_library.LEVEL_VP_MAX_2 = test_library.J_INTEGER
test_esoTERM_pve_library.LEVEL_XP_PERCENT = test_library.K_INTEGER
test_esoTERM_pve_library.LEVEL_XP_GAIN = test_library.L_INTEGER

local MODULE_NAME = "pve"

-- Module Name {{{
function test_esoTERM_pve_library.verify_that_module_has_the_expected_name(module)
    assert.is.equal(MODULE_NAME, module.module_name)
end
-- }}}

-- Initialization {{{
function test_esoTERM_pve_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_pve)
end

function test_esoTERM_pve_library.given_that_module_configured_as_inactive()
    test_library.configure_module_as_inactive(MODULE_NAME)
end

function test_esoTERM_pve_library.given_that_module_configured_as_active()
    test_library.configure_module_as_active(MODULE_NAME)
end

function test_esoTERM_pve_library.and_ZO_SavedVars_new_was_called()
    test_library.ZO_SavedVars_new_was_called_with_module(MODULE_NAME)
end

function test_esoTERM_pve_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_pve_library.and_register_module_was_called_with(...)
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, ...)
end

function test_esoTERM_pve_library.and_that_esoTERM_pve_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_pve, "activate")
end

function test_esoTERM_pve_library.then_esoTERM_pve_activate_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_pve.activate)
end

function test_esoTERM_pve_library.then_esoTERM_pve_activate_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_pve.activate)
end
-- }}}

-- Activate {{{
function test_esoTERM_pve_library.cache_is_cleared()
    for k, v in pairs(test_esoTERM_pve_library.CACHE) do
        test_esoTERM_pve_library.CACHE[k] = nil
    end
end

function test_esoTERM_pve_library.expected_register_for_event_calls_are_cleared()
    ut_helper.clear_table(test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN)
    ut_helper.clear_table(test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN)
end

function test_esoTERM_pve_library.when_activate_is_called()
    esoTERM_pve.activate()
end

function test_esoTERM_pve_library.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_pve)
end

function test_esoTERM_pve_library.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_pve)
end

function test_esoTERM_pve_library.and_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_pve_library.CACHE))
end

test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN = {}
test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN = {}

function test_esoTERM_pve_library.and_that_expected_register_for_event_calls_for_non_veteran_unit_are_set_up()
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN.experience_points_update = {
        module = esoTERM_pve,
        event = EVENT_EXPERIENCE_UPDATE,
        callback = esoTERM_pve.on_experience_update
    }
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN.level_update = {
        module = esoTERM_pve,
        event = EVENT_LEVEL_UPDATE,
        callback = esoTERM_pve.on_level_update
    }
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_NON_VETERAN.veteran_rank_update = {
        module = esoTERM_pve,
        event = EVENT_VETERAN_RANK_UPDATE,
        callback = esoTERM_pve.on_level_update
    }
end

function test_esoTERM_pve_library.and_that_expected_register_for_event_calls_for_veteran_unit_are_set_up()
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN.experience_points_update = {
        module = esoTERM_pve,
        event = EVENT_VETERAN_POINTS_UPDATE,
        callback = esoTERM_pve.on_experience_update
    }
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS_VETERAN.veteran_rank_update = {
        module = esoTERM_pve,
        event = EVENT_VETERAN_RANK_UPDATE,
        callback = esoTERM_pve.on_level_update
    }
end

function test_esoTERM_pve_library.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON = {
    get_level = test_esoTERM_pve_library.LEVEL_1,
    get_level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    get_level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    get_level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    get_xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN = {
    is_veteran = test_esoTERM_pve_library.VETERANNESS_2,
}

for k, v in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON) do
    test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN[k] = v
end

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN = {
    is_veteran = test_esoTERM_pve_library.VETERANNESS_1,
}

for k, v in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON) do
    test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN[k] = v
end

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON = {
    level = test_esoTERM_pve_library.LEVEL_1,
    level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN = {
    veteran = test_esoTERM_pve_library.VETERANNESS_2,
}

for k, v in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON) do
    test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN[k] = v
end

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN = {
    veteran = test_esoTERM_pve_library.VETERANNESS_1,
}

for k, v in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON) do
    test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN[k] = v
end

function test_esoTERM_pve_library.and_that_getter_functions_for_non_veteran_unit_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN) do
        test_library.stub_function_with_return_value(esoTERM_pve, getter, return_value)
    end
end

function test_esoTERM_pve_library.and_that_getter_functions_for_veteran_unit_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN) do
        test_library.stub_function_with_return_value(esoTERM_pve, getter, return_value)
    end
end

function test_esoTERM_pve_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_pve_library.CACHE))
end

function test_esoTERM_pve_library.and_register_for_event_was_called_for_non_veteran_unit_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

function test_esoTERM_pve_library.and_register_for_event_was_called_for_veteran_unit_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

function test_esoTERM_pve_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN) do
        assert.spy(esoTERM_pve[getter]).was.called_with()
    end
end

function test_esoTERM_pve_library.and_cached_values_for_non_veteran_unit_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN) do
        assert.is.equal(expected_value, test_esoTERM_pve_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_pve_library.and_cached_values_for_veteran_unit_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN) do
        assert.is.equal(expected_value, test_esoTERM_pve_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_pve_library.and_active_state_of_the_module_was_saved()
    assert.is.equal(esoTERM_pve.settings[MODULE_NAME], true)
end

function test_esoTERM_pve_library.and_character_is_veteran()
    ut_helper.stub_function(esoTERM_pve, "is_veteran", true)
end

function test_esoTERM_pve_library.and_character_is_not_veteran()
    ut_helper.stub_function(esoTERM_pve, "is_veteran", false)
end

function test_esoTERM_pve_library.and_is_veteran_was_called()
    assert.spy(esoTERM_pve.is_veteran).was.called()
end

function test_esoTERM_pve_library.and_is_veteran_was_not_called()
    assert.spy(esoTERM_pve.is_veteran).was_not.called()
end
-- }}}

-- Deactivate {{{
function test_esoTERM_pve_library.when_deactivate_is_called()
    esoTERM_pve.deactivate()
end

function test_esoTERM_pve_library.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_pve)
end

function test_esoTERM_pve_library.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_pve)
end

function test_esoTERM_pve_library.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function test_esoTERM_pve_library.and_unregister_from_all_events_was_called_with(...)
    assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(esoTERM_pve)
end

function test_esoTERM_pve_library.and_inactive_state_of_the_module_was_saved()
    assert.is.equal(esoTERM_pve.settings[MODULE_NAME], false)
end
-- }}}

-- GetUnitXP {{{
function test_esoTERM_pve_library.and_that_GetUnitXP_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitXP", xp)
end

function test_esoTERM_pve_library.and_GetUnitXP_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitXP).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitXP_was_not_called()
    assert.spy(GLOBAL.GetUnitXP).was_not.called()
end
-- }}}

--  GetUnitVeteranPoints {{{
function test_esoTERM_pve_library.and_that_GetUnitVeteranPoints_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitVeteranPoints", xp)
end

function test_esoTERM_pve_library.and_GetUnitVeteranPoints_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitVeteranPoints).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitVeteranPoints_was_not_called()
    assert.spy(GLOBAL.GetUnitVeteranPoints).was_not.called()
end
--  }}}

-- GetUnitXPMax {{{
function test_esoTERM_pve_library.and_that_GetUnitXPMax_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitXPMax", xp)
end

function test_esoTERM_pve_library.and_GetUnitXPMax_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitXPMax).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitXPMax_was_not_called()
    assert.spy(GLOBAL.GetUnitXPMax).was_not.called()
end
-- }}}

-- GetUnitVeteranPointsMax {{{
function test_esoTERM_pve_library.and_that_GetUnitVeteranPointsMax_returns(xp)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitVeteranPointsMax", xp)
end

function test_esoTERM_pve_library.and_GetUnitVeteranPointsMax_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitVeteranPointsMax).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitVeteranPointsMax_was_not_called()
    assert.spy(GLOBAL.GetUnitVeteranPointsMax).was_not.called()
end
-- }}}

-- GetUnitLevel {{{
function test_esoTERM_pve_library.and_that_GetUnitLevel_returns(level)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitLevel", level)
end

function test_esoTERM_pve_library.and_GetUnitLevel_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitLevel).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitLevel_was_not_called()
    assert.spy(GLOBAL.GetUnitLevel).was_not.called()
end
-- }}}

-- GetUnitVeteranRank {{{
function test_esoTERM_pve_library.and_that_GetUnitVeteranRank_returns(level)
    test_library.stub_function_with_return_value(GLOBAL, "GetUnitVeteranRank", level)
end

function test_esoTERM_pve_library.and_GetUnitVeteranRank_was_called_once_with_player()
    assert.spy(GLOBAL.GetUnitVeteranRank).was.called_with(PLAYER)
end

function test_esoTERM_pve_library.and_GetUnitVeteranRank_was_not_called()
    assert.spy(GLOBAL.GetUnitVeteranRank).was_not.called()
end
-- }}}

return test_esoTERM_pve_library
