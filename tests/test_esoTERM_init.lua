local requires_for_tests = require("tests/requires_for_tests")

describe("Test esoTERM initialization", function()
    local esoTERM_modules = {
        esoTERM_char,
        esoTERM_pve,
        esoTERM_pvp,
        esoTERM_loot,
        esoTERM_slash,
        esoTERM_window,
        esoTERM_output,
    }

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_initialize_functions_are_stubbed()
        for index, module in ipairs(esoTERM_modules) do
            ut_helper.stub_function(module, "initialize", nil)
        end
    end

    local function and_that_esoTERM_output_stdout_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "stdout", nil)
    end

    local function and_that_callback_manager_FireCallbacks_is_stubbed()
        ut_helper.stub_function(CALLBACK_MANAGER, "FireCallbacks", nil)
    end

    local function and_that_event_manager_UnregisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
    end

    local function when_esoTERM_init_initialize_is_called()
        esoTERM_init.initialize(esoTERM.ADDON_NAME)
    end

    local function then_initialize_functions_were_called_once()
        for index, module in ipairs(esoTERM_modules) do
            assert.spy(module.initialize).was.called_with()
        end
    end

    local function and_esoTERM_output_stdout_was_called_once_with(message)
        assert.spy(esoTERM_output.stdout).was.called_with(message)
    end

    local function and_event_manager_UnregisterForEvent_was_called_with(param1, param2)
        assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
            EVENT_MANAGER,
            param1,
            param2)
    end

    local function and_callback_manager_FireCallbacks_was_called_with(event_name)
        assert.spy(CALLBACK_MANAGER.FireCallbacks).was.called_with(
            CALLBACK_MANAGER,
            event_name)
    end
    -- }}}

    it("Initialize if called with correct addon name",
    function()
        given_that_initialize_functions_are_stubbed()
            and_that_esoTERM_output_stdout_is_stubbed()
            and_that_callback_manager_FireCallbacks_is_stubbed()
            and_that_event_manager_UnregisterForEvent_is_stubbed()

        when_esoTERM_init_initialize_is_called()

        then_initialize_functions_were_called_once()
            and_esoTERM_output_stdout_was_called_once_with("esoTERM is active")
            and_callback_manager_FireCallbacks_was_called_with("esoTERMModulesInitialized")
            and_event_manager_UnregisterForEvent_was_called_with(esoTERM.ADDON_NAME,
                                                                 EVENT_ADD_ON_LOADED)
    end)
end)

-- vim:fdm=marker
