local requires_for_tests = require("tests/requires_for_tests")

describe("Test esoTERM initialization", function()
    local ADDON_NAME = "blabla"

    -- {{{
    local function given_that_esoTERM_addon_name_is(name)
        esoTERM.ADDON_NAME = name
    end

    local function and_esoTERM_char_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_char, "initialize", nil)
    end

    local function and_esoTERM_pve_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_pve, "initialize", nil)
    end

    local function and_esoTERM_pvp_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_pvp, "initialize", nil)
    end

    local function and_esoTERM_loot_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_loot, "initialize", nil)
    end

    local function and_esoTERM_slash_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_slash, "initialize", nil)
    end

    local function and_esoTERM_window_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_window, "initialize", nil)
    end

    local function and_esoTERM_output_initialize_is_stubbed()
        ut_helper.stub_function(esoTERM_output, "initialize", nil)
    end

    local function and_event_manager_UnregisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
    end

    local function when_esoTERM_init_initialize_is_called_with(name)
        esoTERM_init.initialize(name)
    end

    local function then_esoTERM_char_initialize_was_called_once_with()
        assert.spy(esoTERM_char.initialize).was.called_with()
    end

    local function and_esoTERM_pve_initialize_was_called_once_with()
        assert.spy(esoTERM_pve.initialize).was.called_with()
    end

    local function and_esoTERM_pvp_initialize_was_called_once_with()
        assert.spy(esoTERM_pvp.initialize).was.called_with()
    end

    local function and_esoTERM_loot_initialize_was_called_once_with()
        assert.spy(esoTERM_loot.initialize).was.called_with()
    end

    local function and_esoTERM_slash_initialize_was_called_once_with()
        assert.spy(esoTERM_slash.initialize).was.called_with()
    end

    local function and_esoTERM_window_initialize_was_called_once_with()
        assert.spy(esoTERM_window.initialize).was.called_with()
    end

    local function and_esoTERM_output_initialize_was_called_once_with()
        assert.spy(esoTERM_output.initialize).was.called_with()
    end

    local function and_event_manager_UnregisterForEvent_was_called_with(param1, param2)
        assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(EVENT_MANAGER,
                                                                     param1,
                                                                     param2)
    end
    -- }}}

    it("Initialize if called with correct addon name",
    function()
        given_that_esoTERM_addon_name_is(ADDON_NAME)
            and_esoTERM_char_initialize_is_stubbed()
            and_esoTERM_pve_initialize_is_stubbed()
            and_esoTERM_pvp_initialize_is_stubbed()
            and_esoTERM_loot_initialize_is_stubbed()
            and_esoTERM_slash_initialize_is_stubbed()
            and_esoTERM_window_initialize_is_stubbed()
            and_esoTERM_output_initialize_is_stubbed()
            and_event_manager_UnregisterForEvent_is_stubbed()

        when_esoTERM_init_initialize_is_called_with(ADDON_NAME)

        then_esoTERM_char_initialize_was_called_once_with()
            and_esoTERM_pve_initialize_was_called_once_with()
            and_esoTERM_pvp_initialize_was_called_once_with()
            and_esoTERM_loot_initialize_was_called_once_with()
            and_esoTERM_slash_initialize_was_called_once_with()
            and_esoTERM_window_initialize_was_called_once_with()
            and_esoTERM_output_initialize_was_called_once_with()
            and_event_manager_UnregisterForEvent_was_called_with(esoTERM.ADDON_NAME,
                                                                 EVENT_ADD_ON_LOADED)
    end)
end)

-- vim:fdm=marker
