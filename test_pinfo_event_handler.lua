local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")

describe("Test event handler initialization", function()
    local ADDON_NAME = "addon_name"
    local pinfo = nil
    local expected_register_params = nil

    setup(function()
        pinfo = {}
        pinfo.ADDON_NAME = ADDON_NAME
        expected_register_params = {}
    end)

    teardown(function()
        pinfo = nil
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_event_manager_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_pinfo_event_handler_on_experience_update_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "on_experience_update", nil)
    end

    local function and_expected_register_event_parameters_is_set_up()
        expected_register_params.experience_points_update = {
            addon_name = ADDON_NAME,
            event = EVENT_EXPERIENCE_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.veteran_points_update = {
            addon_name = ADDON_NAME,
            event = EVENT_VETERAN_POINTS_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
    end

    local function when_pinfo_event_handler_initialize_is_called_with(addon)
        pinfo_event_handler.initialize(addon)
    end

    local function than_event_manager_RegisterForEvent_was_called_with(expected_params)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER,
                expected_params[param].addon_name,
                expected_params[param].event,
                expected_params[param].callback
            )
        end
    end
    -- }}}

    it("Register for events",
    function()
        given_that_event_manager_RegisterForEvent_is_stubbed()
            and_pinfo_event_handler_on_experience_update_is_stubbed()
            and_expected_register_event_parameters_is_set_up()

        when_pinfo_event_handler_initialize_is_called_with(pinfo)

        than_event_manager_RegisterForEvent_was_called_with(expected_register_params)
    end)
end)

describe("Test event handlers", function()
end)

-- vim:fdm=marker
