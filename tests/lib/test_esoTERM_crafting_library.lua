local test_library = require("tests/lib/test_library")
local esoTERM_crafting = require("esoTERM_crafting")

test_esoTERM_crafting_library = {}

local MODULE_NAME = "crafting"

-- setup_test_functions {{{
function test_esoTERM_crafting_library.setup_test_functions(...)
    test_library.setup_test_library_functions(test_esoTERM_crafting_library, ...)
end
-- }}}

-- register_for_event {{{
function test_esoTERM_crafting_library.get_expected_register_for_event_call_parameters()
    return {
        {
            module = esoTERM_crafting,
            event = EVENT_CRAFT_COMPLETED,
            callback = esoTERM_crafting.on_craft_completed_update
        },
    }
end
-- }}}

return test_esoTERM_crafting_library
