local assert = require("luassert")
local ut_helper = require("tests/ut_helper")
local ZO_Symbols = require("tests/fake_zo_symbols")
local esoTERM_init = require("esoTERM_init")

test_esoTERM_library = {}

function test_esoTERM_library.given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
    ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
end

function test_esoTERM_library.then_esoTERM_registered_for_addon_loaded_event()
    assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
        EVENT_MANAGER,
        esoTERM.ADDON_NAME,
        EVENT_ADD_ON_LOADED,
        esoTERM.on_addon_loaded)
end

function test_esoTERM_library.given_that_initialize_is_stubbed()
    ut_helper.stub_function(esoTERM_init, "initialize", nil)
end

function test_esoTERM_library.then_initialize_was_called()
    assert.spy(esoTERM_init.initialize).was.called_with(esoTERM.ADDON_NAME)
end

return test_esoTERM_library
