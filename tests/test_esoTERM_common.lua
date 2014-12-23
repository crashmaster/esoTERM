local requires_for_tests = require("tests/requires_for_tests")

describe("Test common functions.", function()
    local event_register = {}
    local fake_event = 123
    local fake_callback = function() return nil end

    setup(function()
        event_register = {}
    end)

    teardown(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_event_register_is_empty()
        assert.is.equal(0, ut_helper.table_size(event_register))
    end

    local function and_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function when_event_is_registered()
        esoTERM_common.register_for_event(event_register,
                                          fake_event,
                                          fake_callback)
    end

    local function then_the_event_was_registered_both_in_eso_and_locally()
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
            EVENT_MANAGER, esoTERM.ADDON_NAME, fake_event, fake_callback)
        assert.is.equal(true, event_register[fake_event] == true)
    end
    -- }}}

    it("Register for event.",
    function()
        given_that_event_register_is_empty()
            and_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()

        when_event_is_registered()

        then_the_event_was_registered_both_in_eso_and_locally()
    end)

    -- {{{
    local function given_that_event_register_has_one_active_event()
        event_register[fake_event] = true
    end

    local function and_that_EVENT_MANAGER_UnregisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
    end

    local function when_event_is_unregistered()
        esoTERM_common.unregister_from_event(event_register, fake_event)
    end

    local function then_the_event_was_unregistered_both_locally_and_in_eso()
        assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
            EVENT_MANAGER, esoTERM.ADDON_NAME, fake_event)
        assert.is.equal(true, event_register[fake_event] == false)
    end
    -- }}}

    it("Unregister from event.",
    function()
        given_that_event_register_has_one_active_event()
            and_that_EVENT_MANAGER_UnregisterForEvent_is_stubbed()

        when_event_is_unregistered()

        then_the_event_was_unregistered_both_locally_and_in_eso()
    end)
end)
