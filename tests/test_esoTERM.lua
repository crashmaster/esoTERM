local ut_helper = require("tests/ut_helper")
local ZO_Symbols = require("tests/fake_zo_symbols")
local esoTERM_init = require("esoTERM_init")

describe("Test main module.", function()
    -- {{{
    local function given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function when_esoTERM_is_loaded()
        local esoTERM = require("esoTERM")
    end

    local function then_esoTERM_registered_for_addon_loaded_event()
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
            EVENT_MANAGER,
            esoTERM.ADDON_NAME,
            EVENT_ADD_ON_LOADED,
            esoTERM.on_addon_loaded)
    end
    -- }}}

    it("Register for addon loaded event.",
    function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()

        when_esoTERM_is_loaded()

        then_esoTERM_registered_for_addon_loaded_event()
    end)

    -- {{{
    local function given_that_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_init, "initialize", nil)
    end

    local function when_on_addon_loaded_called()
        esoTERM.on_addon_loaded(nil, esoTERM.ADDON_NAME)
    end

    local function then_initialize_was_called()
        assert.spy(esoTERM_init.initialize).was.called_with(esoTERM.ADDON_NAME)
    end
    -- }}}

    it("Complete initialization is called on addon loaded event",
    function()
        given_that_initialize_is_stubbed()

        when_on_addon_loaded_called()

        then_initialize_was_called()
    end)
end)

-- vim:fdm=marker
