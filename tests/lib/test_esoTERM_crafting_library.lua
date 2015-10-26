local test_library = require("tests/lib/test_library")
local esoTERM_crafting = require("esoTERM_crafting")

test_esoTERM_crafting_library = {}

local MODULE_NAME = "crafting"

-- Module Name {{{
function test_esoTERM_crafting_library.verify_that_esoTERM_crafting_module_has_the_expected_name()
    assert.is.equal(MODULE_NAME, esoTERM_crafting.module_name)
end
-- }}}

-- initialize {{{
function test_esoTERM_crafting_library.when_initialize_is_called()
    test_library.initialize_module(esoTERM_crafting)
end
-- }}}

-- ZO_SavedVars {{{
function test_esoTERM_crafting_library.given_that_module_configured_as_inactive()
    test_library.configure_module_as_inactive(MODULE_NAME)
end

function test_esoTERM_crafting_library.given_that_module_configured_as_active()
    test_library.configure_module_as_active(MODULE_NAME)
end

function test_esoTERM_crafting_library.and_ZO_SavedVars_new_was_called()
    test_library.ZO_SavedVars_new_was_called_with_module(MODULE_NAME)
end
-- }}}

-- register_module {{{
function test_esoTERM_crafting_library.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function test_esoTERM_crafting_library.and_register_module_was_called()
    test_library.stub_function_called_with_arguments(esoTERM_common.register_module, esoTERM.module_register, esoTERM_crafting)
end
-- }}}

-- activate {{{
function test_esoTERM_crafting_library.and_that_activate_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_crafting, "activate")
end

function test_esoTERM_crafting_library.then_activate_was_called()
    test_library.stub_function_called_without_arguments(esoTERM_crafting.activate)
end

function test_esoTERM_crafting_library.then_activate_was_not_called()
    test_library.stub_function_was_not_called(esoTERM_crafting.activate)
end
-- }}}

return test_esoTERM_crafting_library

-- vim:fdm=marker
