local ut_helper = require("tests/ut_helper")

this = {}

GLOBAL = _G
PLAYER = "player"

FUNCTION_NAME_TEMPLATES = {
    AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED = "and_active_state_of_the_module_was_saved",
    AND_INACTIVE_STATE_OF_THE_MODULE_WAS_SAVED = "and_inactive_state_of_the_module_was_saved",
    AND_THAT_X_IS_STUBBED = "and_that_x_is_stubbed",
    AND_X_WAS_CALLED_WITH = "and_x_was_called_with",
    AND_ZO_SAVEDVARS_NEW_WAS_CALLED_WITH = "and_ZO_SavedVars_new_was_called_with",
    GIVEN_THAT_MODULE_IS_ACTIVE = "given_that_module_is_active",
    GIVEN_THAT_MODULE_IS_INACTIVE = "given_that_module_is_inactive",
    GIVEN_THAT_MODULE_IS_SET_ACTIVE_IN_THE_CONFIG_FILE = "given_that_module_is_set_active_in_the_config_file",
    GIVEN_THAT_MODULE_IS_SET_INACTIVE_IN_THE_CONFIG_FILE = "given_that_module_is_set_inactive_in_the_config_file",
    THEN_MODULE_BECAME_ACTIVE = "then_module_became_active",
    THEN_MODULE_BECAME_INACTIVE = "then_module_became_inactive",
    THEN_X_WAS_CALLED = "then_x_was_called",
    THEN_X_WAS_NOT_CALLED = "then_x_was_not_called",
    VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME = "verify_that_module_has_the_expected_name",
    WHEN_X_IS_CALLED = "when_x_is_called",
}

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

local function add_and_active_state_of_the_module_was_saved_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["and_active_state_of_the_module_was_saved" ] = function()
        assert.is.equal(fp.module.settings[fp.module_name_in_settings], true)
    end
end

local function add_and_inactive_state_of_the_module_was_saved_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["and_inactive_state_of_the_module_was_saved" ] = function()
        assert.is.equal(fp.module.settings[fp.module_name_in_settings], false)
    end
end

local function add_and_that_x_is_stubbed_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["and_that_" .. fp.function_name .. "_is_stubbed" ] = function()
        this.stub_function_with_no_return_value(fp.module, fp.function_name)
    end
end

local function add_and_x_was_called_with_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["and_" .. fp.function_name .. "_was_called_with"] = function(...)
        this.stub_function_called_with_arguments(fp.module[fp.function_name], ...)
    end
end

local function add_and_zo_savedvars_new_was_called_with_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["and_ZO_SavedVars_new_was_called_with"] = function(...)
        this.ZO_SavedVars_new_was_called_with_module(...)
    end
end

local function add_given_that_module_is_active_test_library_function(test_library, function_properties)
    test_library["given_that_module_is_active"] = function(...)
        this.set_module_to_active(...)
    end
end

local function add_given_that_module_is_inactive_test_library_function(test_library, function_properties)
    test_library["given_that_module_is_inactive"] = function(...)
        this.set_module_to_active(...)
    end
end

local function add_given_that_module_is_set_active_in_the_config_file_test_library_function(test_library, function_properties)
    test_library["given_that_module_is_set_active_in_the_config_file"] = function(...)
        this.set_module_to_active_in_config_file(...)
    end
end

local function add_given_that_module_is_set_inactive_in_the_config_file_test_library_function(test_library, function_properties)
    test_library["given_that_module_is_set_inactive_in_the_config_file"] = function(...)
        this.set_module_to_inactive_in_config_file(...)
    end
end

local function add_then_module_became_active_test_library_function(test_library, function_properties)
    test_library["then_module_became_active"] = function(...)
        this.check_that_module_became_active(...)
    end
end

local function add_then_module_became_inactive_test_library_function(test_library, function_properties)
    test_library["then_module_became_inactive"] = function(...)
        this.check_that_module_became_inactive(...)
    end
end

local function add_then_x_was_called_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["then_" .. fp.function_name .. "_was_called" ] = function()
        this.stub_function_called_without_arguments(fp.module[fp.function_name])
    end
end

local function add_then_x_was_not_called_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["then_" .. fp.function_name .. "_was_not_called" ] = function()
        this.stub_function_was_not_called(fp.module[fp.function_name])
    end
end

local function add_verify_that_module_has_the_expected_name_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["verify_that_module_has_the_expected_name"] = function(module, expected_name)
        assert.is.equal(expected_name, module.module_name)
    end
end

local function add_when_x_is_called_test_library_function(test_library, function_properties)
    local fp = function_properties
    test_library["when_" .. fp.function_name .. "_is_called"] = function()
        fp.module[fp.function_name]()
    end
end

local FUNCTION_NAME_TEMPLATE_TO_ADD_FUCTION = {
    [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = add_and_active_state_of_the_module_was_saved_test_library_function,
    [FUNCTION_NAME_TEMPLATES.AND_INACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = add_and_inactive_state_of_the_module_was_saved_test_library_function,
    [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = add_and_that_x_is_stubbed_test_library_function,
    [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = add_and_x_was_called_with_test_library_function,
    [FUNCTION_NAME_TEMPLATES.AND_ZO_SAVEDVARS_NEW_WAS_CALLED_WITH] = add_and_zo_savedvars_new_was_called_with_test_library_function,
    [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = add_given_that_module_is_active_test_library_function,
    [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = add_given_that_module_is_inactive_test_library_function,
    [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_ACTIVE_IN_THE_CONFIG_FILE] = add_given_that_module_is_set_active_in_the_config_file_test_library_function,
    [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_INACTIVE_IN_THE_CONFIG_FILE] = add_given_that_module_is_set_inactive_in_the_config_file_test_library_function,
    [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = add_then_module_became_active_test_library_function,
    [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_INACTIVE] = add_then_module_became_inactive_test_library_function,
    [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED] = add_then_x_was_called_test_library_function,
    [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = add_then_x_was_not_called_test_library_function,
    [FUNCTION_NAME_TEMPLATES.VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME] = add_verify_that_module_has_the_expected_name_test_library_function,
    [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = add_when_x_is_called_test_library_function,
}

function this.setup_test_library_functions(test_library, schema)
    for function_name_template, template_specialization_parameters in pairs(schema) do
        for _i, function_properties in ipairs(template_specialization_parameters) do
            FUNCTION_NAME_TEMPLATE_TO_ADD_FUCTION[function_name_template](
                test_library, function_properties
            )
        end
    end
end

-- Initialization {{{
-- TODO: will be obsolete when function generator is everywhere in place
function this.initialize_module(module)
    module.initialize()
end

local function set_state_of_the_module_in_the_config_file(module_name, state)
    local setting = {
        [module_name] = state
    }
    this.stub_function_with_return_value(ZO_SavedVars, "New", setting)
end

function this.set_module_to_active_in_config_file(module_name)
    set_state_of_the_module_in_the_config_file(module_name, true)
end

function this.set_module_to_inactive_in_config_file(module_name)
    set_state_of_the_module_in_the_config_file(module_name, false)
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

-- register_for_event_was_called_with_expected_parameters {{{
function this.register_for_event_was_called_with_expected_parameters(expected_register_for_event_calls)
    assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(expected_register_for_event_calls))
    for param in pairs(expected_register_for_event_calls) do
        this.stub_function_called_with_arguments(
            esoTERM_common.register_for_event,
            expected_register_for_event_calls[param].module,
            expected_register_for_event_calls[param].event,
            expected_register_for_event_calls[param].callback)
        assert.is_not.equal(nil, expected_register_for_event_calls[param].callback)
    end
end
-- }}}

return this
