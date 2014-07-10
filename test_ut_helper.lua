ut_helper = require("ut_helper")

function function_1(argument)
    return argument*2
end

function function_2(argument)
    return argument*3
end

describe("Test unit test helpers", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_function_1_works_as_originally_defined()
        assert.is.equal(2, function_1(1))
    end

    local function when_function_1_is_replaced_with_a_stub_that_returns(value)
        ut_helper.stub_function(_G, "function_1", value)
    end

    local function then_function_1_called_with_anything_returns(value)
        assert.is.equal(value, function_1(nil))
    end

    local function and_stubbed_function_1_was_called_once_with(value)
        assert.spy(_G.function_1).was.called_with(nil)
    end
    -- }}}

    it("Replace a function with a stub.",
    function()
        given_that_function_1_works_as_originally_defined()

        when_function_1_is_replaced_with_a_stub_that_returns(2)

        then_function_1_called_with_anything_returns(2)
            and_stubbed_function_1_was_called_once_with(nil)
    end)

    -- {{{
    local function given_that_stubbed_function_1_returns(value)
        ut_helper.stub_function(_G, "function_1", value)
        assert.is.equal(value, function_1(nil))
    end

    local function when_function_1_is_restored()
        ut_helper.restore_stubbed_function(_G, "function_1")
    end

    local function then_function_1_works_as_originally_defined()
        assert.is.equal(2, function_1(1))
    end
    -- }}}

    it("Restore a stubbed function.",
    function()
        given_that_stubbed_function_1_returns(3)

        when_function_1_is_restored()

        then_function_1_works_as_originally_defined()
    end)

    -- {{{
    local function and_that_stubbed_function_2_returns(value)
        ut_helper.stub_function(_G, "function_2", value)
        assert.is.equal(value, function_2(nil))
    end

    local function when_function_1_and_function_2_are_restored()
        ut_helper.restore_stubbed_function(_G, "function_1")
        ut_helper.restore_stubbed_function(_G, "function_2")
    end

    local function and_function_2_works_as_originally_defined()
        assert.is.equal(3, function_2(1))
    end
    -- }}}

    it("Restore two stubbed functions.",
    function()
        given_that_stubbed_function_1_returns(1)
            and_that_stubbed_function_2_returns(2)

        when_function_1_and_function_2_are_restored()

        then_function_1_works_as_originally_defined()
            and_function_2_works_as_originally_defined()
    end)
end)

-- vim:fdm=marker
