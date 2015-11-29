local test_library = require("tests/lib/test_library")
local esoTERM_inventory = require("esoTERM_inventory")

test_esoTERM_inventory_library = {}

-- setup_test_functions {{{
function test_esoTERM_inventory_library.setup_test_functions(...)
    test_library.setup_test_library_functions(test_esoTERM_inventory_library, ...)
end
-- }}}

-- register_for_event {{{
function test_esoTERM_inventory_library.get_expected_register_for_event_call_parameters()
    return {
        {
            module = esoTERM_inventory,
            event = EVENT_CRAFT_COMPLETED,
            callback = esoTERM_inventory.on_craft_completed_update
        },
    }
end
-- }}}

return test_esoTERM_inventory_library
