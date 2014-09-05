local ut_helper = require("tests/ut_helper")

local test_functions = {
    function_1 = function(argument) return argument*2 end,
    function_2 = function (argument) return argument*3 end
}

describe("Test stubbing related unit test helpers", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_function_1_works_as_originally_defined()
        assert.is.equal(2, test_functions.function_1(1))
    end

    local function when_function_1_is_replaced_with_a_stub_that_returns(value)
        ut_helper.stub_function(test_functions, "function_1", value)
    end

    local function then_function_1_called_with_anything_returns(value)
        assert.is.equal(value, test_functions.function_1(nil))
    end

    local function and_stubbed_function_1_was_called_once_with(value)
        assert.spy(test_functions.function_1).was.called_with(nil)
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
        ut_helper.stub_function(test_functions, "function_1", value)
        assert.is.equal(value, test_functions.function_1(nil))
    end

    local function when_function_1_is_restored()
        ut_helper.restore_stubbed_function(test_functions, "function_1")
    end

    local function then_function_1_works_as_originally_defined()
        assert.is.equal(2, test_functions.function_1(1))
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
        ut_helper.stub_function(test_functions, "function_2", value)
        assert.is.equal(value, test_functions.function_2(nil))
    end

    local function when_function_1_and_function_2_are_restored()
        ut_helper.restore_stubbed_function(test_functions, "function_1")
        ut_helper.restore_stubbed_function(test_functions, "function_2")
    end

    local function and_function_2_works_as_originally_defined()
        assert.is.equal(3, test_functions.function_2(1))
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

describe("Test various unit test helpers", function()
    local n = 3
    local result = -1
    local test_table = nil

    before_each(function()
        test_table = {}
    end)

    after_each(function()
        result = -1
        test_table = nil
    end)

    -- {{{
    local function given_that_the_number_of_entries_in_the_test_table_is(n)
        local i = 0
        while i < n do
            test_table[string.format("entry_%s", i)] = i
            i = i + 1
        end
    end

    local function when_table_size_on_test_table_is_called()
        result = ut_helper.table_size(test_table)
    end

    local function then_the_returned_number_of_entires_was(n)
        assert.is.equal(n, result)
    end
    -- }}}

    it("Get table size.",
    function()
        given_that_the_number_of_entries_in_the_test_table_is(n)

        when_table_size_on_test_table_is_called()

        then_the_returned_number_of_entires_was(n)
    end)
end)

-- vim:fdm=marker
