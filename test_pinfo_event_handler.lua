local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")

local ADDON_NAME = "addon_name"

describe("Test event handler initialization", function()
    local pinfo = nil
    local expected_register_params = nil

    setup(function()
        pinfo = {}
        pinfo.ADDON_NAME = ADDON_NAME
        expected_register_params = {}
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        pinfo = nil
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_event_manager_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_pinfo_event_handler_on_experience_update_is_stubbed()
        ut_helper.stub_function(pinfo_event_handler, "on_experience_update", nil)
    end

    local function and_expected_register_event_parameters_is_set_up()
        expected_register_params.experience_points_update = {
            addon_name = ADDON_NAME,
            event = EVENT_EXPERIENCE_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
        expected_register_params.veteran_points_update = {
            addon_name = ADDON_NAME,
            event = EVENT_VETERAN_POINTS_UPDATE,
            callback = pinfo_event_handler.on_experience_update
        }
    end

    local function when_initialize_is_called_with(addon)
        pinfo_event_handler.initialize(addon)
    end

    local function than_event_manager_RegisterForEvent_was_called_with(expected_params)
        assert.spy(EVENT_MANAGER.RegisterForEvent).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER,
                expected_params[param].addon_name,
                expected_params[param].event,
                expected_params[param].callback
            )
        end
    end
    -- }}}

    it("Register for events",
    function()
        given_that_event_manager_RegisterForEvent_is_stubbed()
            and_pinfo_event_handler_on_experience_update_is_stubbed()
            and_expected_register_event_parameters_is_set_up()

        when_initialize_is_called_with(pinfo)

        than_event_manager_RegisterForEvent_was_called_with(expected_register_params)
    end)
end)

describe("Test the on experience update event handler", function()
    local EVENT = -1
    local UNIT = "player"
    local REASON = 0

    local OLD_XP = 100
    local OLD_XP_MAX = 1000
    local OLD_XP_PCT = OLD_XP * 100 / OLD_XP_MAX
    local NEW_XP = 100
    local NEW_XP_MAX = 1000
    local NEW_XP_PCT = NEW_XP * 100 / NEW_XP_MAX

    local pinfo = nil
    local character_info = nil

    before_each(function()
        pinfo = {}
        pinfo.ADDON_NAME = ADDON_NAME
        character_info = {
            level_xp = OLD_XP,
            level_xp_max = OLD_XP_MAX,
            level_xp_percent = OLD_XP_PCT
        }
        pinfo.CHARACTER_INFO = character_info
        pinfo_event_handler.initialize(pinfo)
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
        character_info = nil
        pinfo = nil
    end)

    -- {{{
    local function given_that_pinfo_output_character_info_to_debug_is_stubbed()
        ut_helper.stub_function(pinfo_output, "character_info_to_debug", nil)
    end

    local function when_on_experience_update_is_called_with(event, unit, xp, xp_max, reason)
        pinfo_event_handler.on_experience_update(event, unit, xp, xp_max, reason)
    end

    local function then_the_xp_properties_in_character_info_where_updated()
        assert.is.equal(NEW_XP, character_info.level_xp)
        assert.is.equal(NEW_XP_MAX, character_info.level_xp_max)
        assert.is.equal(NEW_XP_PCT, character_info.level_xp_percent)
    end

    local function and_pinfo_output_character_info_to_debug_was_called_once()
        assert.spy(pinfo_output.character_info_to_debug).was.called_with()
    end
    -- }}}

    it("On experience update, happy flow",
    function()
        given_that_pinfo_output_character_info_to_debug_is_stubbed()

        when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, REASON)

        then_the_xp_properties_in_character_info_where_updated()
            and_pinfo_output_character_info_to_debug_was_called_once()
    end)

    -- {{{
    local function then_the_xp_properties_in_character_info_where_not_updated()
        assert.is.equal(OLD_XP, character_info.level_xp)
        assert.is.equal(OLD_XP_MAX, character_info.level_xp_max)
        assert.is.equal(OLD_XP_PCT, character_info.level_xp_percent)
    end

    local function and_pinfo_output_character_info_to_debug_was_not_called()
        assert.spy(pinfo_output.character_info_to_debug).was_not.called()
    end
    -- }}}

    it("On experience update, incorrect unit",
    function()
        given_that_pinfo_output_character_info_to_debug_is_stubbed()

        when_on_experience_update_is_called_with(EVENT, "foo", NEW_XP, NEW_XP_MAX, REASON)

        then_the_xp_properties_in_character_info_where_not_updated()
            and_pinfo_output_character_info_to_debug_was_not_called()
    end)

    it("On experience update, incorrect reason",
    function()
        given_that_pinfo_output_character_info_to_debug_is_stubbed()

        when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, NEW_XP_MAX, -1)

        then_the_xp_properties_in_character_info_where_not_updated()
            and_pinfo_output_character_info_to_debug_was_not_called()
    end)

    it("On experience update, total maximum xp reached",
    function()
        given_that_pinfo_output_character_info_to_debug_is_stubbed()

        when_on_experience_update_is_called_with(EVENT, UNIT, NEW_XP, 0, REASON)

        then_the_xp_properties_in_character_info_where_not_updated()
            and_pinfo_output_character_info_to_debug_was_not_called()
    end)
end)

-- vim:fdm=marker
