local test_library = require("tests/lib/test_library")
local esoTERM_loot = require("esoTERM_loot")

test_esoTERM_loot_library = {}

test_esoTERM_loot_library.CACHE = esoTERM_loot.cache
test_esoTERM_loot_library.EVENT_REGISTER = esoTERM_loot.event_register

test_esoTERM_loot_library.LOOTED_ITEM = test_library.A_STRING
test_esoTERM_loot_library.LOOT_QUANTITY = test_library.A_INTEGER

local MODULE_NAME = "loot"

-- Initialization {{{
function test_esoTERM_loot_library.when_initialize_is_called()
    esoTERM_loot.initialize()
end

function test_esoTERM_loot_library.given_that_module_configured_as_inactive()
    local setting = {
        [MODULE_NAME] = false
    }
    test_library.stub_function_with_return_value(ZO_SavedVars, "New", setting)
end

function test_esoTERM_loot_library.given_that_module_configured_as_active()
    local setting = {
        [MODULE_NAME] = true
    }
    test_library.stub_function_with_return_value(ZO_SavedVars, "New", setting)
end

function test_esoTERM_loot_library.and_zo_savedvars_new_was_called()
    assert.spy(ZO_SavedVars.New).was.called_with(
        ZO_SavedVars,
        "esoTERM_settings",
        2,
        "active_modules",
        {[MODULE_NAME] = true}
    )
end

function test_esoTERM_loot_library.and_that_register_module_is_stubbed()
    ut_helper.stub_function(esoTERM_common, "register_module", nil)
end

function test_esoTERM_loot_library.and_register_module_was_called()
    assert.spy(esoTERM_common.register_module).was.called_with(
        esoTERM.module_register, esoTERM_loot)
end

function test_esoTERM_loot_library.and_that_esoTERM_loot_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_loot, "activate")
end

function test_esoTERM_loot_library.then_esoTERM_loot_activate_was_called()
    assert.spy(esoTERM_loot.activate).was.called()
end

function test_esoTERM_loot_library.then_esoTERM_loot_activate_was_not_called()
    assert.spy(esoTERM_loot.activate).was_not.called()
end
-- }}}

return test_esoTERM_loot_library
