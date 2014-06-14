pinfo = require("pinfo")
ut_helper = require("ut_helper")

describe("Test EVENT_ADD_ON_LOADED event handling", function()
    -- {{{
    local function given_that_pinfo_initialize_is_stubbed()
        ut_helper.stub_function(pinfo, "initialize", nil)
    end

    local function when_pinfo_on_addon_loaded_is_called_by_eso_with(event, name)
        pinfo.on_addon_loaded(event, name)
    end

    local function then_pinfo_initialize_was_called_once()
        assert.spy(pinfo.initialize).was.called_with()
    end
    -- }}}

    it("Received addon loaded event for pinfo addon",
    function()
        given_that_pinfo_initialize_is_stubbed()

        when_pinfo_on_addon_loaded_is_called_by_eso_with(nil, "pinfo")

        then_pinfo_initialize_was_called_once()
    end)
end)

-- vim:fdm=marker
