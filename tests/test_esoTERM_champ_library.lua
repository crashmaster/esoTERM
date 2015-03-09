local test_library = require("tests/test_library")

this = {}

local MODULE_NAME = "esoTERM-champion"

-- module_name {{{
function this.verify_that_the_module_name_is_the_expected_one()
    assert.is.equal(MODULE_NAME, esoTERM_champ.module_name)
end
-- }}}

-- esoTERM_champ module activeness {{{
this.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}

function this.expected_register_for_event_calls_are_cleared()
    this.EXPECTED_REGISTER_FOR_EVENT_CALLS = {}
end

function this.given_that_module_is_active()
    test_library.set_module_to_active(esoTERM_champ)
end

function this.given_that_module_is_inactive()
    test_library.set_module_to_inactive(esoTERM_champ)
end

function this.and_that_register_for_event_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_for_event")
end

function this.and_that_unregister_from_all_events_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "unregister_from_all_events")
end

function this.and_that_expected_register_for_event_calls_are_set_up()
    this.EXPECTED_REGISTER_FOR_EVENT_CALLS.champion_xp_gained = {
        module = esoTERM_champ,
        event = EVENT_EXPERIENCE_UPDATE,
        callback = esoTERM_champ.on_experience_update
    }
    this.EXPECTED_REGISTER_FOR_EVENT_CALLS.champion_point_gained = {
        module = esoTERM_champ,
        event = EVENT_CHAMPION_POINT_GAINED,
        callback = esoTERM_champ.on_champion_point_gain
    }
end

function this.when_initialize_is_called()
    esoTERM_champ.initialize()
end

function this.when_deactivate_for_the_module_is_called()
    esoTERM_champ.deactivate()
end

function this.and_module_became_active()
    test_library.check_that_module_became_active(esoTERM_champ)
end

function this.then_module_became_inactive()
    test_library.check_that_module_became_inactive(esoTERM_champ)
end

function this.and_register_for_event_was_called_with_expected_parameters()
    assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(this.EXPECTED_REGISTER_FOR_EVENT_CALLS))
    for param in pairs(this.EXPECTED_REGISTER_FOR_EVENT_CALLS) do
        assert.spy(esoTERM_common.register_for_event).was.called_with(
            this.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].module,
            this.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].event,
            this.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
        assert.is_not.equal(nil, this.EXPECTED_REGISTER_FOR_EVENT_CALLS[param].callback)
    end
end

function this.and_unregister_from_all_events_was_called()
    assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(esoTERM_champ)
end

function this.and_that_register_module_is_stubbed()
    test_library.stub_function_with_no_return_value(esoTERM_common, "register_module")
end

function this.and_register_module_was_called()
    assert.spy(esoTERM_common.register_module).was.called_with(esoTERM.module_register, esoTERM_champ)
end
-- }}}

return this

-- vim:fdm=marker
