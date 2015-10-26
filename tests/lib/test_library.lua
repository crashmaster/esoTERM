local ut_helper = require("tests/ut_helper")

this = {}

GLOBAL = _G
PLAYER = "player"

this.A_BOOL = true
this.B_BOOL = false
this.A_INTEGER = 1111
this.B_INTEGER = 2222
this.C_INTEGER = 3333
this.D_INTEGER = 4444
this.E_INTEGER = 5555
this.F_INTEGER = 6666
this.G_INTEGER = 7777
this.H_INTEGER = 8888
this.I_INTEGER = 9999
this.J_INTEGER = 1234
this.K_INTEGER = 5678
this.L_INTEGER = 9012
this.M_INTEGER = 3456
this.N_INTEGER = 7890
this.O_INTEGER = 9876
this.P_INTEGER = 5432
this.Q_INTEGER = 1098
this.R_INTEGER = 7654
this.S_INTEGER = 3210
this.A_STRING = "aAaAa"
this.B_STRING = "bBbBb"
this.C_STRING = "cCcCc"
this.D_STRING = "dDdDd"
this.E_STRING = "eEeEe"
this.F_STRING = "fFfFf"

local function stub_function(module, function_name, return_value)
    ut_helper.stub_function(module, function_name, return_value)
end

function this.stub_function_with_no_return_value(module, function_name)
    stub_function(module, function_name, nil)
end

function this.stub_function_with_return_value(module, function_name, return_value)
    stub_function(module, function_name, return_value)
end

function this.stub_function_was_not_called(module_function)
    assert.spy(module_function).was_not.called()
end

function this.stub_function_called_without_arguments(module_function)
    assert.spy(module_function).was.called_with()
end

function this.stub_function_called_with_arguments(module_function, ...)
    assert.spy(module_function).was.called_with(...)
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

function this.configure_module_as_active(module_name)
    local setting = {
        [module_name] = true
    }
    this.stub_function_with_return_value(ZO_SavedVars, "New", setting)
end

function this.ZO_SavedVars_new_was_called_with_module(module_name)
    assert.spy(ZO_SavedVars.New).was.called_with(
        ZO_SavedVars,
        "esoTERM_settings",
        2,
        "active_modules",
        {
            [module_name] = true
        }
    )
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
