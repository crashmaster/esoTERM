local requires_for_tests = require("tests/requires_for_tests")

describe("Test slash command handler initialization.", function()
    -- {{{
    local function when_initialize_is_called()
        esoTERM_slash.initialize()
    end

    local function then_slash_command_handler_for_esoTERM_was_registered()
        assert.is.equal(SLASH_COMMANDS["/esoterm"], esoTERM_slash.slash_command_handler)
    end

    local function and_command_handler_map_was_set_up()
        local commands = {
            "help",
            "status",
            "activate",
            "deactivate",
        }
        for _, command in ipairs(commands) do
            assert.is.equal(true, esoTERM_slash.command_handlers[command] ~= nil)
        end
    end
    -- }}}

    it("Command handler for /esoterm commands is registered.", function()
        when_initialize_is_called()

        then_slash_command_handler_for_esoTERM_was_registered()
            and_command_handler_map_was_set_up()
    end)
end)

describe("Test slash command handlers.", function()
    local fake_active_module = {
        module_name = "fake_active_module",
        is_active = true,
    }
    function fake_active_module.deactivate()
        fake_active_module.is_active = false
    end

    local fake_inactive_module = {
        module_name = "fake_inactive_module",
        is_active = false,
    }
    function fake_inactive_module.activate()
        fake_inactive_module.is_active = true
    end

    local help_message="Available command for esoTERM:\n" ..
                       " - show about: /esoterm\n" ..
                       " - show help: /esoterm help\n" ..
                       " - show status: /esoterm status"

    before_each(function()
        ut_helper.stub_function(esoTERM_output, "sysout", nil)
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
        esoTERM.module_register = {}
        fake_active_module.is_active = true
        fake_inactive_module.is_active = false
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

        then_sysout_was_called_with("About\n" ..
                                    "Name: esoTERM\n" ..
                                    "Author: @Gaul @ EU")
    end)

    it("Output of invalid command", function()
        when_command_handler_called_with("foobar")

        then_sysout_was_called_with("Invalid slash-command: foobar")
    end)

    it("Output of lower case help command", function()
        when_command_handler_called_with("help")

        then_sysout_was_called_with(help_message)
    end)

    it("Output of mixed case help command", function()
        when_command_handler_called_with("hElP")

        then_sysout_was_called_with(help_message)
    end)

    -- {{{
    local function given_that_there_is_no_module_registered()
        esoTERM.module_register = {}
    end
    -- }}}

    it("Output of status command if no module registered", function()
        given_that_there_is_no_module_registered()

        when_command_handler_called_with("status")

        then_sysout_was_called_with("Status of modules\n" ..
                                    "No registered modules")
    end)

    -- {{{
    local function given_that_there_is_one_module_registered(module)
        esoTERM_common.register_module(esoTERM.module_register, module)
    end
    -- }}}

    it("The status command returns the status of one active module", function()
        given_that_there_is_one_module_registered(fake_active_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("Status of modules\n" ..
                                    "fake_active_module is ACTIVE")
    end)

    it("The status command returns the status of one inactive module", function()
        given_that_there_is_one_module_registered(fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("Status of modules\n" ..
                                    "fake_inactive_module is INACTIVE")
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

        then_sysout_was_called_with("Status of modules\n" ..
                                    "fake_active_module is ACTIVE\n" ..
                                    "fake_active_module is ACTIVE")
    end)

    it("The status command returns the status of two inactive modules", function()
        given_that_there_are_two_module_registered(fake_inactive_module,
                                                   fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("Status of modules\n" ..
                                    "fake_inactive_module is INACTIVE\n" ..
                                    "fake_inactive_module is INACTIVE")
    end)

    it("The status command returns the status of an active and an inactive module", function()
        given_that_there_are_two_module_registered(fake_active_module,
                                                   fake_inactive_module)

        when_command_handler_called_with("status")

        then_sysout_was_called_with("Status of modules\n" ..
                                    "fake_active_module is ACTIVE\n" ..
                                    "fake_inactive_module is INACTIVE")
    end)

    -- {{{
    local function then_the_module_became_inactive(module)
        assert.is.equal(false, module.is_active)
    end

    local function and_sysout_was_called_with(message)
        assert.spy(esoTERM_output.sysout).was.called_with(message)
    end
    -- }}}

    it("Deactivate an active module", function()
        given_that_there_is_one_module_registered(fake_active_module)

        when_command_handler_called_with("deactivate fake_active_module")

        then_the_module_became_inactive(fake_active_module)
            and_sysout_was_called_with("Module fake_active_module deactivated")
    end)

    it("Deactivate an already inactive module", function()
        given_that_there_is_one_module_registered(fake_inactive_module)

        when_command_handler_called_with("deactivate fake_inactive_module")

        then_the_module_became_inactive(fake_inactive_module)
            and_sysout_was_called_with("Module fake_inactive_module already inactive")
    end)

    -- {{{
    local function then_the_module_became_active(module)
        assert.is.equal(true, module.is_active)
    end
    -- }}}

    it("Activate an inactive module", function()
        given_that_there_is_one_module_registered(fake_inactive_module)

        when_command_handler_called_with("activate fake_inactive_module")

        then_the_module_became_active(fake_inactive_module)
            and_sysout_was_called_with("Module fake_inactive_module activated")
    end)

    it("Activate an already active module", function()
        given_that_there_is_one_module_registered(fake_active_module)

        when_command_handler_called_with("activate fake_active_module")

        then_the_module_became_active(fake_active_module)
            and_sysout_was_called_with("Module fake_active_module already active")
    end)
end)
