local test_library = require("tests/lib/test_library")
local esoTERM_pve = require("esoTERM_pve")

test_esoTERM_pve_library = {}

test_esoTERM_pve_library.CACHE = esoTERM_pve.cache
test_esoTERM_pve_library.EVENT_REGISTER = esoTERM_pve.event_register

test_esoTERM_pve_library.VETERANNESS_1 = test_library.A_BOOL
test_esoTERM_pve_library.VETERANNESS_2 = test_library.B_BOOL
test_esoTERM_pve_library.LEVEL_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_PERCENT = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_GAIN = test_library.A_INTEGER

local MODULE_NAME = "pve"

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

function test_esoTERM_pve_library.and_zo_savedvars_new_was_called()
    test_library.zo_savedvars_new_was_called_with_module(MODULE_NAME)
end

function test_esoTERM_pve_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_pve_library.and_register_module_was_called()
    test_library.stub_function_called_with(esoTERM_common.register_module, esoTERM.module_register, esoTERM_pve)
end

function test_esoTERM_pve_library.and_that_esoTERM_pve_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_pve, "activate")
end

function test_esoTERM_pve_library.then_esoTERM_pve_activate_was_called()
    assert.spy(esoTERM_pve.activate).was.called()
end

function test_esoTERM_pve_library.then_esoTERM_pve_activate_was_not_called()
    assert.spy(esoTERM_pve.activate).was_not.called()
end
-- }}}

-- Activate {{{
function test_esoTERM_pve_library.expected_register_for_event_calls_are_cleared()
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}
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

test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function test_esoTERM_pve_library.and_that_expected_register_for_event_calls_are_set_up()
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.experience_points_update = {
        module = esoTERM_pve,
        event = EVENT_EXPERIENCE_UPDATE,
        callback = esoTERM_pve.on_experience_update
    }
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.level_update = {
        module = esoTERM_pve,
        event = EVENT_LEVEL_UPDATE,
        callback = esoTERM_pve.on_level_update
    }
    test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.veteran_rank_update = {
        module = esoTERM_pve,
        event = EVENT_VETERAN_RANK_UPDATE,
        callback = esoTERM_pve.on_level_update
    }
end

function test_esoTERM_pve_library.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS = {
    is_veteran = test_esoTERM_pve_library.VETERANNESS_1,
    get_level = test_esoTERM_pve_library.LEVEL_1,
    get_level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    get_level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    get_level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    get_xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES = {
    veteran = test_esoTERM_pve_library.VETERANNESS_1,
    level = test_esoTERM_pve_library.LEVEL_1,
    level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

function test_esoTERM_pve_library.and_that_getter_functions_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        test_library.stub_function_with_return_value(esoTERM_pve, getter, return_value)
    end
end

function test_esoTERM_pve_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_pve_library.CACHE))
end

function test_esoTERM_pve_library.and_register_for_event_was_called_with_expected_parameters()
    assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS))
    for param in pairs(test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS) do
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].module,
            test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].event,
            test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
        assert.is_not.equal(nil, test_esoTERM_pve_library.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
    end
end

function test_esoTERM_pve_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        assert.spy(esoTERM_pve[getter]).was.called_with()
    end
end

function test_esoTERM_pve_library.and_cached_values_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES) do
        assert.is.equal(expected_value, test_esoTERM_pve_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_pve_library.and_module_is_active_was_saved()
    assert.is.equal(esoTERM_pve.settings[MODULE_NAME], true)
end
-- }}}

-- Deactivate {{{
function test_esoTERM_pve_library.when_deactivate_for_the_module_is_called()
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

function test_esoTERM_pve_library.and_unregister_from_all_events_was_called()
    assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(esoTERM_pve)
end

function test_esoTERM_pve_library.and_module_is_inactive_was_saved()
    assert.is.equal(esoTERM_pve.settings[MODULE_NAME], false)
end
-- }}}

return test_esoTERM_pve_library
