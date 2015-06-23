local ut_helper = require("tests/ut_helper")

this = {}

GLOBAL = _G
PLAYER = "player"

this.A_BOOL = true
this.B_BOOL = false
this.A_INTEGER = 1111
this.B_INTEGER = 2222
this.A_STRING = "aAaAa"
this.B_STRING = "bBbBb"

local function stub_function(module, function_name, return_value)
    ut_helper.stub_function(module, function_name, return_value)
end

function this.stub_function_with_no_return_value(module, function_name)
    stub_function(module, function_name, nil)
end

function this.stub_function_with_return_value(module, function_name, return_value)
    stub_function(module, function_name, return_value)
end

-- Initialization {{{
function this.initialize_module(module)
    module.initialize()
end

function this.configure_module_as_inactive(module_name)
    local setting = {
        [module_name] = false
    }
    this.stub_function_with_return_value(ZO_SavedVars, "New", setting)
end
-- }}}

-- Module activeness {{{
local MODULE_ACTIVE = true
local MODULE_INACTIVE = false

function this.set_module_to_active(module)
    module.is_active = MODULE_ACTIVE
end

function this.set_module_to_inactive(module)
    module.is_active = MODULE_INACTIVE
end

function this.check_that_module_became_active(module)
    assert.is.equal(MODULE_ACTIVE, module.is_active)
end

function this.check_that_module_became_inactive(module)
    assert.is.equal(MODULE_INACTIVE, module.is_active)
end
-- }}}

return this

-- vim:fdm=marker
