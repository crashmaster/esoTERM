test_esoTERM_common_library = {}

local test_register = {}

local test_module = {
    module_name = "test_module"
}

function test_esoTERM_common_library.clean_test_module_register()
    ut_helper.clear_table(test_register)
end

function test_esoTERM_common_library.given_that_module_register_is_empty()
    assert.is.equal(0, ut_helper.table_size(test_register))
end

local function contains_module(module_register, expected_module)
    for index, module in pairs(module_register) do
        if module == expected_module then
            return true
        end
    end
    return false
end

function test_esoTERM_common_library.then_the_module_register_does_not_contains_module()
    assert.is.equal(false, contains_module(test_register, test_module))
end

function test_esoTERM_common_library.then_the_module_register_contains_that_module()
    assert.is.equal(true, contains_module(test_register, test_module))
end

local function resgister_test_module_in_test_register()
    esoTERM_common.register_module(test_register, test_module)
end

function test_esoTERM_common_library.when_module_registered()
    resgister_test_module_in_test_register()
end

function test_esoTERM_common_library.given_that_test_module_is_registered()
    resgister_test_module_in_test_register()
end

function test_esoTERM_common_library.then_the_getter_returns_the_registered_module()
    local module = esoTERM_common.get_module(test_register, "tEsT_mOdUle")
    assert.is.equal("test_module", module.module_name)
end

function test_esoTERM_common_library.split_string_into_strings_at_spaces(input_string, output_array)
    local result = esoTERM_common.split(input_string)
    for index, string in ipairs(output_array) do
        assert.is.equal(result[index], string)
    end
end

return test_esoTERM_common_library
