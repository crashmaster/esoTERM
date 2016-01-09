local assert = require("luassert")
local test_library = require("tests/lib/test_library")
local esoTERM_pve = require("esoTERM_pve")

test_esoTERM_pve_library = {}

-- setup_test_functions {{{
function test_esoTERM_pve_library.setup_test_functions(...)
    test_library.setup_test_library_functions(test_esoTERM_pve_library, ...)
end
-- }}}

test_esoTERM_pve_library.CACHE = esoTERM_pve.cache
test_esoTERM_pve_library.EVENT_REGISTER = esoTERM_pve.event_register

test_esoTERM_pve_library.VETERANNESS_1 = test_library.A_BOOL
test_esoTERM_pve_library.VETERANNESS_2 = test_library.B_BOOL

test_esoTERM_pve_library.LEVEL_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_1 = test_library.C_INTEGER
test_esoTERM_pve_library.LEVEL_XP_2 = test_library.D_INTEGER
test_esoTERM_pve_library.LEVEL_VP_1 = test_library.E_INTEGER
test_esoTERM_pve_library.LEVEL_VP_2 = test_library.F_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_1 = test_library.G_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_2 = test_library.H_INTEGER
test_esoTERM_pve_library.LEVEL_VP_MAX_1 = test_library.I_INTEGER
test_esoTERM_pve_library.LEVEL_VP_MAX_2 = test_library.J_INTEGER
test_esoTERM_pve_library.LEVEL_XP_PERCENT = test_library.K_INTEGER
test_esoTERM_pve_library.LEVEL_XP_GAIN = test_library.L_INTEGER

local MODULE_NAME = "pve"

-- Activate {{{
function test_esoTERM_pve_library.get_expected_register_for_event_call_parameters_for_non_veteran_unit()
    return {
        {
            module = esoTERM_pve,
            event = EVENT_EXPERIENCE_UPDATE,
            callback = esoTERM_pve.on_experience_update
        },
        {
            module = esoTERM_pve,
            event = EVENT_LEVEL_UPDATE,
            callback = esoTERM_pve.on_level_update
        },
        {
            module = esoTERM_pve,
            event = EVENT_VETERAN_RANK_UPDATE,
            callback = esoTERM_pve.on_level_update
        },
    }
end

function test_esoTERM_pve_library.get_expected_register_for_event_call_parameters_for_veteran_unit()
    return {
        {
            module = esoTERM_pve,
            event = EVENT_VETERAN_POINTS_UPDATE,
            callback = esoTERM_pve.on_experience_update
        },
        {
            module = esoTERM_pve,
            event = EVENT_VETERAN_RANK_UPDATE,
            callback = esoTERM_pve.on_level_update
        },
    }
end

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON = {
    get_level = test_esoTERM_pve_library.LEVEL_1,
    get_level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    get_level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    get_level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    get_xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN = {
    is_veteran = test_esoTERM_pve_library.VETERANNESS_2,
}

for k, v in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON) do
    test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN[k] = v
end

test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN = {
    is_veteran = test_esoTERM_pve_library.VETERANNESS_1,
}

for k, v in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_COMMON) do
    test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN[k] = v
end

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON = {
    level = test_esoTERM_pve_library.LEVEL_1,
    level_xp = test_esoTERM_pve_library.LEVEL_XP_1,
    level_xp_max = test_esoTERM_pve_library.LEVEL_XP_MAX_1,
    level_xp_percent = test_esoTERM_pve_library.LEVEL_XP_PERCENT,
    xp_gain = test_esoTERM_pve_library.LEVEL_XP_GAIN,
}

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN = {
    veteran = test_esoTERM_pve_library.VETERANNESS_2,
}

for k, v in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON) do
    test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN[k] = v
end

test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN = {
    veteran = test_esoTERM_pve_library.VETERANNESS_1,
}

for k, v in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_COMMON) do
    test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN[k] = v
end

function test_esoTERM_pve_library.and_that_getter_functions_for_non_veteran_unit_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN) do
        test_library.stub_function_with_return_value(esoTERM_pve, getter, return_value)
    end
end

function test_esoTERM_pve_library.and_that_getter_functions_for_veteran_unit_are_stubbed()
    for getter, return_value in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_VETERAN) do
        test_library.stub_function_with_return_value(esoTERM_pve, getter, return_value)
    end
end

function test_esoTERM_pve_library.and_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(test_esoTERM_pve_library.CACHE))
end

function test_esoTERM_pve_library.and_register_for_event_was_called_for_non_veteran_unit_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

function test_esoTERM_pve_library.and_register_for_event_was_called_for_veteran_unit_was_called_with(...)
    test_library.register_for_event_was_called_with_expected_parameters(...)
end

function test_esoTERM_pve_library.and_getter_function_stubs_were_called()
    for getter, _ in pairs(test_esoTERM_pve_library.RETURN_VALUES_OF_THE_GETTER_STUBS_NON_VETERAN) do
        assert.spy(esoTERM_pve[getter]).was.called_with()
    end
end

function test_esoTERM_pve_library.and_cached_values_for_non_veteran_unit_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_NON_VETERAN) do
        assert.is.equal(expected_value, test_esoTERM_pve_library.CACHE[cache_attribute])
    end
end

function test_esoTERM_pve_library.and_cached_values_for_veteran_unit_became_initialized()
    for cache_attribute, expected_value in pairs(test_esoTERM_pve_library.EXPECTED_CACHED_VALUES_VETERAN) do
        assert.is.equal(expected_value, test_esoTERM_pve_library.CACHE[cache_attribute])
    end
end
-- }}}

return test_esoTERM_pve_library
