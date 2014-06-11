ut_helper = require("ut_helper")

function function_1(argument)
    return argument*2
end

function function_to_be_replaced_2(argument)
    return argument*3
end

describe("Test unit test helpers", function()
    after_each(function()
        ut_helper.restore_stub_functions()
    end)

    -- {{{
    local function given_that_function_1_returns_4_on_2()
        assert.is.equal(4, function_1(2))
    end

    local function when_function_1_is_replaced_with_a_stub_that_returns_2()
        ut_helper.replace_function(_G, "function_1", 2)
    end

    local function then_function_1_returns_2_on_4()
        assert.is.equal(2, function_1(4))
    end
    -- }}}

    it("Function replaced with stub.",
    function()
        given_that_function_1_returns_4_on_2()
        when_function_1_is_replaced_with_a_stub_that_returns_2()
        then_function_1_returns_2_on_4()
    end)

--  -- {{{
--  local function given_that_function_1_is_replaced_with_a_stub_returning_3()
--      ut_helper.replace_function(_G, "function_1", 3)
--      assert.is.equal(3, function_1(0))
--  end

--  local function when_function_1_is_restored()
--      ut_helper.restore_stub_function("function_1")
--  end

--  local function then_funtion_1_returns_8_on_4()
--      assert.is.equal(8, function_1(4))
--  end
--  -- }}}

--  it("Restore stubbed function.",
--  function()
--      given_that_function_1_is_replaced_with_a_fake_returning_3()
--      when_function_1_is_restored()
--      then_funtion_1_returns_8_on_4()
--  end)

--  it("Two global functions replaced and reverted.",
--  function()
--      assert.is.equal(4, function_1(2))
--      assert.is.equal(6, function_to_be_replaced_2(2))
--      ut_helper.replace_function(_G, "function_1", 2)
--      ut_helper.replace_function(_G, "function_to_be_replaced_2", 3)
--      assert.is.equal(2, function_1(2))
--      assert.is.equal(3, function_to_be_replaced_2(2))
--      ut_helper.restore_fake_functions()
--      assert.is.equal(2, function_1(1))
--      assert.is.equal(9, function_to_be_replaced_2(3))
--  end)
end)

-- vim:fdm=marker
