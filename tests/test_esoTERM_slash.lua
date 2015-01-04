local requires_for_tests = require("tests/requires_for_tests")

describe("Test slash command handler initialization.", function()
    -- {{{
    local function when_initialize_is_called()
        esoTERM_slash.initialize()
    end

    local function then_slash_command_handler_for_esoTERM_is_registered()
        assert.is.equal(SLASH_COMMANDS["/esoterm"], esoTERM_slash.slash_command_handler)
    end
    -- }}}

    it("Command handler for /esoterm commands is registered.", function()
        when_initialize_is_called()

        then_slash_command_handler_for_esoTERM_is_registered()
    end)
end)

describe("Test slash command handlers.", function()
    local fake_active_module = {
        module_name = "fake_active_module",
        is_active = true
    }
    local fake_inactive_module = {
        module_name = "fake_inactive_module",
        is_active = false
    }

    before_each(function()
        ut_helper.stub_function(esoTERM_output, "sysout", nil)
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
        esoTERM.module_register = {}
    end)

    -- {{{
    local function when_command_handler_called_with(command)
        esoTERM_slash.slash_command_handler(command)
    end

    local function then_sysout_was_called_with(message)
        assert.spy(esoTERM_output.sysout).was.called_with(message)
    end
    -- }}}

    it("Output of no command", function()
        when_command_handler_called_with("")

        then_sysout_was_called_with("esoTERM active")
    end)

    it("Output of invalid command", function()
        when_command_handler_called_with("foobar")

        then_sysout_was_called_with("Invalid command: foobar")
    end)

    it("Output of lower case help command", function()
        when_command_handler_called_with("help")

        then_sysout_was_called_with("No help here")
    end)

    it("Output of mixed case help command", function()
        when_command_handler_called_with("hElP")

        then_sysout_was_called_with("No help here")
    end)

    -- {{{
    local function given_that_there_is_no_module_registered()
        esoTERM.module_register = {}
    end
    -- }}}

    it("Output of status command if no module registered", function()
        given_that_there_is_no_module_registered()

        when_command_handler_called_with("status")

        then_sysout_was_called_with("No registered modules")
    end)

    -- {{{
    local function given_that_there_is_one_module_registered(module)
        esoTERM_common.register_module(esoTERM.module_register, module)
    end
    -- }}}

    it("The status command returns the status of one active module", function()
        given_that_there_is_one_module_registered(fake_active_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("fake_active_module  <ACTIVE>")
    end)

    it("The status command returns the status of one inactive module", function()
        given_that_there_is_one_module_registered(fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("fake_inactive_module  <INACTIVE>")
    end)

    -- {{{
    local function given_that_there_are_two_module_registered(module_1, module_2)
        esoTERM_common.register_module(esoTERM.module_register, module_1)
        esoTERM_common.register_module(esoTERM.module_register, module_2)
    end
    -- }}}

    it("The status command returns the status of two active modules", function()
        given_that_there_are_two_module_registered(fake_active_module,
                                                   fake_active_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("fake_active_module  <ACTIVE>\n" ..
                                    "fake_active_module  <ACTIVE>")
    end)

    it("The status command returns the status of two inactive modules", function()
        given_that_there_are_two_module_registered(fake_inactive_module,
                                                   fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("fake_inactive_module  <INACTIVE>\n" ..
                                    "fake_inactive_module  <INACTIVE>")
    end)

    it("The status command returns the status of an active and an inactive module", function()
        given_that_there_are_two_module_registered(fake_active_module,
                                                   fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("fake_active_module  <ACTIVE>\n" ..
                                    "fake_inactive_module  <INACTIVE>")
    end)
end)
