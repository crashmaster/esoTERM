local test_library = require("tests/lib/test_library")
local esoTERM_loot = require("esoTERM_loot")

test_esoTERM_loot_library = {}

test_esoTERM_loot_library.CACHE = esoTERM_loot.cache
test_esoTERM_loot_library.EVENT_REGISTER = esoTERM_loot.event_register

test_esoTERM_loot_library.LOOTED_ITEM = test_library.A_STRING
test_esoTERM_loot_library.LOOT_QUANTITY = test_library.B_INTEGER

local MODULE_NAME = "loot"

-- setup_test_functions {{{
function test_esoTERM_loot_library.setup_test_functions(...)
    test_library.setup_test_library_functions(test_esoTERM_loot_library, ...)
end
-- }}}

-- Initialization {{{
function test_esoTERM_loot_library.given_that_module_is_set_active_in_the_config_file(...)
    test_library.set_module_to_active_in_config_file(...)
end
-- }}}

-- Activate {{{
test_esoTERM_loot_library.EXPECTED_CACHED_VALUES = {
    loot_quantity = test_esoTERM_loot_library.LOOT_QUANTITY,
    looted_item = test_esoTERM_loot_library.LOOTED_ITEM,
}

function test_esoTERM_loot_library.and_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_esoTERM_loot_library.CACHE))
end

function test_esoTERM_loot_library.get_expected_register_for_event_call_parameters()
    return {
        {
            module = esoTERM_loot,
            event = EVENT_LOOT_RECEIVED,
            callback = esoTERM_loot.on_loot_received
        },
        {
            module = esoTERM_loot,
            event = EVENT_MONEY_UPDATE,
            callback = esoTERM_loot.on_money_received
        },
    }
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

function test_esoTERM_loot_library.and_inactive_state_of_the_module_was_saved()
    assert.is.equal(esoTERM_loot.settings[MODULE_NAME], false)
end
-- }}}

return test_esoTERM_loot_library
