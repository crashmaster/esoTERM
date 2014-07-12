local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")

describe("Test pinfo initialization", function()
    local pinfo = nil

    setup(function()
        pinfo = {}
        pinfo.CHARACTER_INFO = {}
    end)

    teardown(function()
        pinfo = nil
    end)

    -- {{{
    local function given_that_pinfo_addon_name_is(name)
        pinfo.ADDON_NAME = name
    end

    local function and_pinfo_event_handler_initialize_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "initialize", nil)
    end

    local function and_pinfo_char_initialize_is_stubbed()
        ut_helper.stub_function(pinfo_char, "initialize", nil)
    end

    local function and_event_manager_UnregisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
    end

    local function when_pinfo_init_initialize_is_called_with(name, addon)
        pinfo_init.initialize(name, addon)
    end

    local function then_pinfo_event_handler_initialize_was_called_once_with(param)
        assert.spy(pinfo_event_handler.initialize).was.called_with(param)
    end

    local function and_pinfo_char_initialize_was_called_once_with(param)
        assert.spy(pinfo_char.initialize).was.called_with(param)
    end

    local function and_event_manager_UnregisterForEvent_was_called_with(param1, param2)
        assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(EVENT_MANAGER,
                                                                     param1,
                                                                     param2)
    end
    -- }}}

    it("Initialize if called with correct addon name",
    function()
        given_that_pinfo_addon_name_is("bla")
            and_pinfo_event_handler_initialize_is_stubbed()
            and_pinfo_char_initialize_is_stubbed()
            and_event_manager_UnregisterForEvent_is_stubbed()

        when_pinfo_init_initialize_is_called_with("bla", pinfo)

        then_pinfo_event_handler_initialize_was_called_once_with(pinfo)
            and_pinfo_char_initialize_was_called_once_with(pinfo.CHARACTER_INFO)
            and_event_manager_UnregisterForEvent_was_called_with(REGISTER_FOR,
                                                                 EVENT_ADD_ON_LOADED)
    end)
end)

-- vim:fdm=marker
