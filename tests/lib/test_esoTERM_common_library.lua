test_esoTERM_common_library = {}

local module_register = {}

local test_module = {
    module_name = "test_module"
}

function test_esoTERM_common_library.given_that_test_module_is_registered()
    esoTERM_common.register_module(module_register, test_module)
end

function test_esoTERM_common_library.then_the_getter_returns_the_registered_module()
    local module = esoTERM_common.get_module(module_register, "tEsT_mOdUle")
    assert.is.equal("test_module", module.module_name)
end

return test_esoTERM_common_library

-- vim:fdm=marker
