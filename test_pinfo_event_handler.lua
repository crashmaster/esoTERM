local pinfo = require("pinfo_event_handler")
local ut_helper = require("ut_helper")

local GLOBAL = _G


describe("Test event handlers", function()
    -- {{{
    local function given_that_d_is_stubbed()
        ut_helper.stub_function(GLOBAL, "d", nil)
    end

    local function when_on_experience_update_is_called_with(event, unit_tag, xp, xp_max, reason)
        pinfo_event_handler.on_experience_update(event, unit_tag, xp, xp_max, reason)
    end

    local function then_d_was_not_called()
        assert.spy(GLOBAL.d).was_not.called()
    end
    -- }}}

    it("Experience or veteran point update received with invalid unit tag",
    function()
        given_that_d_is_stubbed()

        when_on_experience_update_is_called_with(0, "foobar", 1, 2, 3)

        then_d_was_not_called()
    end)
end)

-- vim:fdm=marker
