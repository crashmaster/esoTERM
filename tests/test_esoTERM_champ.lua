local tl = require("tests/test_esoTERM_champ_library")

describe("Test the esoTERM_champ module.", function()
    it("Module is called: esoTERM-champion.",
    function()
        tl.verify_that_the_module_name_is_the_expected_one()
    end)
end)
