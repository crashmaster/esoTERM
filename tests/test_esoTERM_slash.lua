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
    before_each(function()
        ut_helper.stub_function(esoTERM_output, "sysout", nil)
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function when_command_handler_called_with(command)
        esoTERM_slash.slash_command_handler(command)
    end

    local function then_sysout_was_called_with(message)
        assert.spy(esoTERM_output.sysout).was.called_with(message)
    end
    -- }}}

    it("No command provided", function()
        when_command_handler_called_with("")

        then_sysout_was_called_with("Running")
    end)

    it("Invalid command provided", function()
        when_command_handler_called_with("foobar")

        then_sysout_was_called_with("Invalid command: foobar")
    end)

    it("Lower case help provided", function()
        when_command_handler_called_with("help")

        then_sysout_was_called_with("No help here")
    end)

    it("Mixed case help provided", function()
        when_command_handler_called_with("hElP")

        then_sysout_was_called_with("No help here")
    end)
end)
