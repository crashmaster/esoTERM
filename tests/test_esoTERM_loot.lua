local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G


describe("Test event handler initialization.", function()
    local addon_name = "esoTERM"
    local expected_register_params = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        expected_register_params = nil
    end)

    -- {{{
    local function given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
        ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
    end

    local function and_expected_register_event_parameters_are_set_up()
        expected_register_params.loot_received_update = {
            addon_name = addon_name,
            event = EVENT_LOOT_RECEIVED,
            callback = esoTERM_loot.on_loot_received
        }
    end

    local function when_initialize_is_called()
        esoTERM_loot.initialize()
    end

    local function then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_params)
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

    it("Register for events", function()
        given_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            and_expected_register_event_parameters_are_set_up()

        when_initialize_is_called()

        then_EVENT_MANAGER_RegisterForEvent_was_called_with(expected_register_params)
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"
    local UNIT = "player"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    describe("The on loot received event handler.", function()
        local BY = "by"
        local ITEM = "item"
        local QUANTITY = 1
        local SOUND = "sound"
        local LOOT_TYPE = "loot_type"

        -- {{{
        local function given_that_esoTERM_output_loot_to_chat_tab_is_stubbed()
            ut_helper.stub_function(esoTERM_output, "loot_to_chat_tab", nil)
        end

        local function when_on_loot_received_is_called_with(event, by, item, quantity, sound, loot_type, self)
            esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
        end

        local function then_esoTERM_output_loot_to_chat_tab_was_called_with(item, quantity)
            assert.spy(esoTERM_output.loot_to_chat_tab).was.called_with(item, quantity)
        end
        -- }}}

        it("Happy flow.", function()
            given_that_esoTERM_output_loot_to_chat_tab_is_stubbed()

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, true)

            then_esoTERM_output_loot_to_chat_tab_was_called_with(ITEM, QUANTITY)
        end)

        -- {{{
        local function then_esoTERM_output_loot_to_chat_tab_was_not_called()
            assert.spy(esoTERM_output.loot_to_chat_tab).was_not.called()
        end
        -- }}}

        it("If not self.", function()
            given_that_esoTERM_output_loot_to_chat_tab_is_stubbed()

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, false)

            then_esoTERM_output_loot_to_chat_tab_was_not_called()
        end)
    end)
end)

-- vim:fdm=marker
