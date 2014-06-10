ut_helper = require("ut_helper")

function function_to_be_replaced_1(argument)
    return argument*2
end

function function_to_be_replaced_2(argument)
    return argument*3
end

describe("Test unit test helpers", function()
    it("Global function replaced and reverted.",
    function()
        assert.is.equal(4, function_to_be_replaced_1(2))
        ut_helper.replace_function(_G, "function_to_be_replaced_1", 2)
        assert.is.equal(2, function_to_be_replaced_1(2))
        ut_helper.restore_fake_functions()
        assert.is.equal(4, function_to_be_replaced_1(2))
    end)

    it("Global functions replaced and reverted.",
    function()
        assert.is.equal(4, function_to_be_replaced_1(2))
        assert.is.equal(6, function_to_be_replaced_2(2))
        ut_helper.replace_function(_G, "function_to_be_replaced_1", 2)
        ut_helper.replace_function(_G, "function_to_be_replaced_2", 3)
        assert.is.equal(2, function_to_be_replaced_1(2))
        assert.is.equal(3, function_to_be_replaced_2(2))
        ut_helper.restore_fake_functions()
        assert.is.equal(2, function_to_be_replaced_1(1))
        assert.is.equal(9, function_to_be_replaced_2(3))
    end)
end)
