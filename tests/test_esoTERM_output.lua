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
end)

describe("Test output.", function()
    before_each(function()
        esoTERM_output.initialize()
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function when_message_is_sent_to_stdout(message)
        esoTERM_output.stdout(message)
    end

    local function then_stdout_message_buffer_contains(message)
        assert.is.equal(message, esoTERM_output.message_buffers.stdout[1])
    end
    -- }}}

    it("Messages to sysout are stored before player is activated.",
    function()
        when_message_is_sent_to_stdout("foobar")

        then_stdout_message_buffer_contains("foobar")
    end)

    -- {{{
    local function when_message_is_sent_to_sysout(message)
        esoTERM_output.sysout(message)
    end

    local function then_sysout_message_buffer_contains(message)
        assert.is.equal(message, esoTERM_output.message_buffers.sysout[1])
    end
    -- }}}

    it("Messages to sysout are stored before player is activated.",
    function()
        when_message_is_sent_to_sysout("foobar")

        then_sysout_message_buffer_contains("foobar")
    end)

    -- {{{
    local function given_that_esoTERM_window_print_message_is_stubbed()
        ut_helper.stub_function(esoTERM_window, "print_message", nil)
    end

    local function and_message_is_sent_to_stdout(message)
        esoTERM_output.stdout(message)
    end

    local function when_player_activated_event_occured()
        esoTERM_output.on_player_activated(nil)
    end

    local function then_esoTERM_window_print_message_was_called_with(buffered, unbuffered)
        assert.spy(esoTERM_window.print_message).was.called_with(buffered)
        assert.spy(esoTERM_window.print_message).was.called_with(unbuffered)
    end

    local function and_esoTERM_output_stdout_message_buffer_became_empty()
        assert.is.equal(0, ut_helper.table_size(esoTERM_output.message_buffers.stdout))
    end
    -- }}}

    it("Messages to stdout are printed after player is activated.",
    function()
        given_that_esoTERM_window_print_message_is_stubbed()
            and_message_is_sent_to_stdout("foobar")

        when_player_activated_event_occured()
            and_message_is_sent_to_stdout("foobar2")

        then_esoTERM_window_print_message_was_called_with("foobar", "foobar2")
            and_esoTERM_output_stdout_message_buffer_became_empty()
    end)

    -- {{{
    local function given_that_d_stubbed()
        ut_helper.stub_function(GLOBAL, "d", nil)
    end

    local function and_message_is_sent_to_sysout(message)
        esoTERM_output.sysout(message)
    end

    local function then_d_was_called_with(buffered, unbuffered)
        assert.spy(GLOBAL.d).was.called_with(buffered)
        assert.spy(GLOBAL.d).was.called_with(unbuffered)
    end

    local function and_esoTERM_output_sysout_message_buffer_became_empty()
        assert.is.equal(0, ut_helper.table_size(esoTERM_output.message_buffers.sysout))
    end
    -- }}}

    it("Messages to sysout are printed after player is activated.",
    function()
        given_that_d_stubbed()
            and_message_is_sent_to_sysout("barfoo")

        when_player_activated_event_occured()
            and_message_is_sent_to_sysout("barfoo2")

        then_d_was_called_with("[esoTERM] barfoo", "[esoTERM] barfoo2")
            and_esoTERM_output_sysout_message_buffer_became_empty()
    end)
end)

-- vim:fdm=marker
