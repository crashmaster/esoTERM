local test_library = require("tests/lib/test_library")
local esoTERM_crafting = require("esoTERM_crafting")

test_esoTERM_crafting_library = {}

local MODULE_NAME = "crafting"

-- setup_test_functions {{{
function test_esoTERM_crafting_library.setup_test_functions(...)
    test_library.setup_test_library_functions(test_esoTERM_crafting_library, ...)
end
-- }}}

-- ZO_SavedVars {{{
function test_esoTERM_crafting_library.given_that_module_configured_as_inactive(...)
    test_library.configure_module_as_inactive(...)
end

function test_esoTERM_crafting_library.given_that_module_configured_as_active(...)
    test_library.configure_module_as_active(...)
end

function test_esoTERM_crafting_library.and_ZO_SavedVars_new_was_called()
    test_library.ZO_SavedVars_new_was_called_with_module(MODULE_NAME)
end
-- }}}

-- register_for_event {{{
test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function test_esoTERM_crafting_library.expected_register_for_event_calls_are_cleared()
    ut_helper.clear_table(test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS)
end

function test_esoTERM_crafting_library.and_that_expected_register_for_event_calls_are_set_up()
    test_esoTERM_crafting_library.EXPECTED_REGISTER_FOR_EVENT_CALLS.craft_completed_update = {
        module = esoTERM_crafting,
        event = EVENT_CRAFT_COMPLETED,
        callback = esoTERM_crafting.on_craft_completed_update
    }
end

function test_esoTERM_crafting_library.and_register_for_event_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end
-- }}}

return test_esoTERM_crafting_library
