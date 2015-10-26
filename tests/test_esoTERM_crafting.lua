-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_crafting_library")

local verify_that_esoTERM_crafting_module_has_the_expected_name = tl.verify_that_esoTERM_crafting_module_has_the_expected_name
-- }}}

describe("Test the esoTERM_crafting module.", function()
    it("Module is called: crafting.",
    function()
        verify_that_esoTERM_crafting_module_has_the_expected_name()
    end)
end)
