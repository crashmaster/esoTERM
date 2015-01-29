local ut_helper = require("tests/ut_helper")
local ZO_Symbols = require("tests/fake_zo_symbols")
local tl = require("tests/test_esoTERM_library")

describe("Test main module.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function when_esoTERM_is_loaded()
        package.loaded["esoTERM"] = nil
        local esoTERM = require("esoTERM")
    end

    -- }}}

    it("Register for addon loaded event.",
    function()
        tl.given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()

        when_esoTERM_is_loaded()

        tl.then_esoTERM_registered_for_addon_loaded_event()
    end)

    -- {{{
    local function when_on_addon_loaded_called()
        esoTERM.on_addon_loaded(nil, esoTERM.ADDON_NAME)
    end
    -- }}}

    it("Complete initialization is called on addon loaded event",
    function()
        tl.given_that_initialize_is_stubbed()

        when_on_addon_loaded_called()

        tl.then_initialize_was_called()
    end)
end)

-- vim:fdm=marker
