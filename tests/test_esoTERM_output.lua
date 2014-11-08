local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

describe("Test output initialization", function()
    local expected_register_params = {}
    local expected_new_params = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_esoTERM_output_on_player_activated_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "on_player_activated", nil)
    end

    local function and_expected_register_event_parameter_is_set_up()
        expected_register_params.experience_points_update = {
            addon_name = esoTERM.ADDON_NAME,
            event = EVENT_PLAYER_ACTIVATED,
            callback = esoTERM_output.on_player_activated
        }
    end

    local function when_initialize_is_called()
        esoTERM_output.initialize()
    end

    local function then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_params)
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

    it("Register for player activated event",
    function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_esoTERM_output_on_player_activated_is_stubbed()
            and_expected_register_event_parameter_is_set_up()

        when_initialize_is_called()

        then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
    end)

    -- {{{
    local function given_that_ZO_SavedVars_New_is_stubbed()
        ut_helper.stub_function(ZO_SavedVars, "New", nil)
    end

    local function and_expected_saved_vars_new_is_set_up()
        expected_new_params.chat_saved_settings = {
            table_name = "esoTERM_saved_variables",
            version = 1,
            namespace = nil,
            default = {chat_tab_number = 1}
        }
    end

    local function then_ZO_SavedVars_New_was_called_with(expected_params)
        assert.spy(ZO_SavedVars.New).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(ZO_SavedVars.New).was.called_with(
                ZO_SavedVars,
                expected_params[param].table_name,
                expected_params[param].version,
                expected_params[param].namespace,
                expected_params[param].default
            )
        end
    end
    -- }}}

    it("Saved variables loaded",
    function()
        given_that_ZO_SavedVars_New_is_stubbed()
            and_expected_saved_vars_new_is_set_up()

        when_initialize_is_called()

        then_ZO_SavedVars_New_was_called_with(expected_new_params)
    end)
end)

-- vim:fdm=marker
