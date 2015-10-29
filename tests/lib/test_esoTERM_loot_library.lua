local test_library = require("tests/lib/test_library")
local esoTERM_loot = require("esoTERM_loot")

test_esoTERM_loot_library = {}

test_esoTERM_loot_library.CACHE = esoTERM_loot.cache
test_esoTERM_loot_library.EVENT_REGISTER = esoTERM_loot.event_register

test_esoTERM_loot_library.LOOTED_ITEM = test_library.A_STRING
test_esoTERM_loot_library.LOOT_QUANTITY = test_library.B_INTEGER

local MODULE_NAME = "loot"

-- Module Name {{{
function test_esoTERM_loot_library.verify_that_esoTERM_loot_module_has_the_expected_name()
    assert.is.equal(MODULE_NAME, esoTERM_loot.module_name)
end
-- }}}

-- Initialization {{{
function test_esoTERM_loot_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_loot)
end

function test_esoTERM_loot_library.given_that_module_configured_as_inactive()
    test_library.configure_module_as_inactive(MODULE_NAME)
end

function test_esoTERM_loot_library.given_that_module_configured_as_active()
    test_library.configure_module_as_active(MODULE_NAME)
end

function test_esoTERM_loot_library.and_ZO_SavedVars_new_was_called()
    test_library.ZO_SavedVars_new_was_called_with_module(MODULE_NAME)
end

function test_esoTERM_loot_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_loot_library.and_register_module_was_called_with(...)
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, ...)
end

function test_esoTERM_loot_library.and_that_esoTERM_loot_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_loot, "activate")
end

function test_esoTERM_loot_library.then_esoTERM_loot_activate_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_loot.activate)
end

function test_esoTERM_loot_library.then_esoTERM_loot_activate_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_loot.activate)
end
-- }}}

-- Activate {{{
test_esoTERM_loot_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function test_esoTERM_loot_library.when_activate_is_called()
    esoTERM_loot.activate()
end

function test_esoTERM_loot_library.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_loot)
end

test_esoTERM_loot_library.EXPECTED_CACHED_VALUES = {
    loot_quantity = test_esoTERM_loot_library.LOOT_QUANTITY,
    looted_item = test_esoTERM_loot_library.LOOTED_ITEM,
}

function test_esoTERM_loot_library.expected_register_for_event_calls_are_cleared()
    test_esoTERM_loot_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}
end

function test_esoTERM_loot_library.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_loot)
end

function test_esoTERM_loot_library.and_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_loot_library.CACHE))
end

function test_esoTERM_loot_library.and_that_expected_register_for_event_calls_are_set_up()
    test_esoTERM_loot_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.loot_received_update = {
        module = esoTERM_loot,
        event = EVENT_LOOT_RECEIVED,
        callback = esoTERM_loot.on_loot_received
    }
    test_esoTERM_loot_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.money_received_update = {
        module = esoTERM_loot,
        event = EVENT_MONEY_UPDATE,
        callback = esoTERM_loot.on_money_received
    }
end

function test_esoTERM_loot_library.and_that_register_for_event_is_stubbed()
    ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
end

function test_esoTERM_loot_library.and_register_for_event_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

test_esoTERM_loot_library.RETURN_VALUES_OF_THE_GETTER_STUBS = {
    get_loot_quantity = test_esoTERM_loot_library.LOOT_QUANTITY,
    get_looted_item = test_esoTERM_loot_library.LOOTED_ITEM,
}

function test_esoTERM_loot_library.and_that_getter_functions_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_loot_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        test_library.stub_function_with_return_value(esoTERM_loot, getter, return_value)
    end
end

function test_esoTERM_loot_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_loot_library.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        assert.spy(esoTERM_loot[getter]).was.called_with()
    end
end

function test_esoTERM_loot_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_loot_library.CACHE))
end

function test_esoTERM_loot_library.and_cached_values_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_loot_library.EXPECTED_CACHED_VALUES) do
        assert.is.equal(expected_value, test_esoTERM_loot_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_loot_library.and_module_is_active_was_saved()
    assert.is.equal(esoTERM_loot.settings[MODULE_NAME], true)
end
-- }}}

-- Deactivate {{{
function test_esoTERM_loot_library.when_deactivate_is_called()
    esoTERM_loot.deactivate()
end

function test_esoTERM_loot_library.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_loot)
end

function test_esoTERM_loot_library.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_loot)
end

function test_esoTERM_loot_library.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function test_esoTERM_loot_library.and_unregister_from_all_events_was_called_with(...)
    assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(esoTERM_loot)
end

function test_esoTERM_loot_library.and_module_is_inactive_was_saved()
    assert.is.equal(esoTERM_loot.settings[MODULE_NAME], false)
end
-- }}}

return test_esoTERM_loot_library
