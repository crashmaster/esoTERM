local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/test_esoTERM_champ_library")

describe("Test the esoTERM_champ module.", function()
    it("Module is called: esoTERM-champion.",
    function()
        tl.verify_that_the_module_name_is_the_expected_one()
    end)
end)

describe("Test the esoTERM_champ module initialization.", function()
    after_each(function()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)

    it("Update cache and subscribe for events on initialization.",
    function()
        tl.given_that_module_is_inactive()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_expected_register_for_event_calls_are_set_up()

        tl.when_initialize_is_called()

        tl.and_module_became_active()
            tl.and_register_for_event_was_called_with_expected_parameters()
    end)
end)
