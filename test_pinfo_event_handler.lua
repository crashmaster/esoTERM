local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")

describe("Test event handler initialization", function()
    local pinfo = nil
    local addon_name = "addon_name"

    setup(function()
        pinfo = {}
        pinfo.ADDON_NAME = addon_name
    end)

    teardown(function()
        pinfo = nil
    end)

    -- {{{
    local function given_that_event_manager_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_pinfo_event_handler_on_experience_update_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "on_experience_update", nil)
    end

    local function when_pinfo_event_handler_initialize_is_called_with(addon)
        pinfo_event_handler.initialize(addon)
    end

    local function than_event_manager_RegisterForEvent_was_called_with(p1, p2, p3, p4, p5)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called(2)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(EVENT_MANAGER, p1, p2, p3)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(EVENT_MANAGER, p1, p4, p5)
    end
    -- }}}

    it("Register for events",
    function()
        given_that_event_manager_RegisterForEvent_is_stubbed()
            and_pinfo_event_handler_on_experience_update_is_stubbed()

        when_pinfo_event_handler_initialize_is_called_with(pinfo)

        than_event_manager_RegisterForEvent_was_called_with(addon_name,
                                                            EVENT_MANAGER.EVENT_VETERAN_POINTS_UPDATE,
                                                            pinfo_event_handler.on_experience_update,
                                                            EVENT_MANAGER.EVENT_EXPERIENCE_UPDATE,
                                                            pinfo_event_handler.on_experience_update)
    end)
end)

describe("Test event handlers", function()
end)

-- vim:fdm=marker
