local test_library = require("tests/test_library")

this = {}

this.CACHE = esoTERM_char.cache
this.EVENT_REGISTER = esoTERM_char.event_register

this.GENDER_1 = test_library.A_STRING
this.GENDER_2 = test_library.B_STRING
this.CLASS_1 = test_library.A_STRING
this.CLASS_2 = test_library.B_STRING
this.NAME_1 = test_library.A_STRING
this.NAME_2 = test_library.B_STRING
this.COMBAT_STATE_1 = test_library.A_BOOL
this.COMBAT_STATE_2 = test_library.B_BOOL
this.COMBAT_START_TIME = test_library.A_INTEGER
this.COMBAT_LENGHT = test_library.A_INTEGER
this.COMBAT_DAMAGE = test_library.A_INTEGER

local MODULE_NAME = "esoTERM-character"

this.RETURN_VALUES_OF_THE_GETTER_STUBS = {
    get_gender = this.GENDER_1,
    get_class = this.CLASS_1,
    get_name = this.NAME_1,
    get_combat_state = this.COMBAT_STATE_1,
    get_combat_start_time = this.COMBAT_START_TIME,
    get_combat_lenght = this.COMBAT_LENGHT,
    get_combat_damage = this.COMBAT_DAMAGE
}

this.EXPECTED_CACHED_VALUES = {
    gender = this.GENDER_1,
    class = this.CLASS_1,
    name = this.NAME_1,
    combat_state = this.COMBAT_STATE_1,
    combat_start_time = this.COMBAT_START_TIME,
    combat_lenght = this.COMBAT_LENGHT,
    combat_damage = this.COMBAT_DAMAGE
}

this.EXPECTED_REGISTER_FOR_EVENT_PARAMS = {}

function this.when_module_name_is_get_then_expected_name_is_returned()
    assert.is.equal(MODULE_NAME, esoTERM_char.module_name)
end

function this.setup_getter_stubs()
    for getter, return_value in pairs(this.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        ut_helper.stub_function(esoTERM_char, getter, return_value)
    end
end

function this.given_that_cache_is_empty()
    assert.is.equal(0, ut_helper.table_size(this.CACHE))
end

function this.and_that_register_for_event_is_stubbed()
    ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
end

function this.and_that_expected_register_event_parameters_are_set_up()
    this.EXPECTED_REGISTER_FOR_EVENT_PARAMS.combat_state_update = {
        local_register = this.EVENT_REGISTER,
        event = EVENT_PLAYER_COMBAT_STATE,
        callback = esoTERM_char.on_combat_state_update
    }
    this.EXPECTED_REGISTER_FOR_EVENT_PARAMS.death_state_update = {
        local_register = this.EVENT_REGISTER,
        event = EVENT_UNIT_DEATH_STATE_CHANGED,
        callback = esoTERM_char.on_unit_death_state_change
    }
end

function this.and_that_register_module_is_stubbed()
    ut_helper.stub_function(esoTERM_common, "register_module", nil)
end

function this.when_initialize_is_called()
    esoTERM_char.initialize()
end

function this.then_cache_is_no_longer_empty()
    assert.is_not.equal(0, ut_helper.table_size(this.CACHE))
end

function this.and_cached_values_became_initialized()
    for cache_attribute, expected_value in pairs(this.EXPECTED_CACHED_VALUES) do
        assert.is.equal(expected_value, this.CACHE[cache_attribute])
    end
end

function this.and_getter_stubs_were_called()
    for getter, _ in pairs(this.RETURN_VALUES_OF_THE_GETTER_STUBS) do
        assert.spy(esoTERM_char[getter]).was.called_with()
    end
end

function this.and_register_for_event_was_called_with_expected_parameters()
    assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(this.EXPECTED_REGISTER_FOR_EVENT_PARAMS))
    for param in pairs(this.EXPECTED_REGISTER_FOR_EVENT_PARAMS) do
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            this.EXPECTED_REGISTER_FOR_EVENT_PARAMS[param].local_register,
            this.EXPECTED_REGISTER_FOR_EVENT_PARAMS[param].event,
            this.EXPECTED_REGISTER_FOR_EVENT_PARAMS[param].callback)
        assert.is_not.equal(nil, this.EXPECTED_REGISTER_FOR_EVENT_PARAMS[param].callback)
    end
end

function this.and_register_module_was_called()
    assert.spy(esoTERM_common.register_module).was.called_with(
        esoTERM.module_register, esoTERM_char)
end

function this.and_module_is_active()
    assert.is.equal(true, esoTERM_char.is_active)
end

return this
