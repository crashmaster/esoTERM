-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_loot_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_loot, module_name_in_settings = "loot" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
            { module = esoTERM_common, function_name = "register_for_event", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_RETURNS] = {
            { module = GLOBAL, function_name = "GetBagSize", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_REPLACED_BY] = {
            { module = GLOBAL, function_name = "GetItemName", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_REGISTER_FOR_EVENT_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED] = {
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = GLOBAL, function_name = "GetBagSize", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH_MULTI_VALUES] = {
            { module = GLOBAL, function_name = "GetItemName", },
        },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "initialize_module", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED_WITH] = {
            { module = esoTERM_common, function_name = "initialize_module", },
        },
        [FUNCTION_NAME_TEMPLATES.VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME] = { { }, },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = esoTERM_loot, function_name = "activate", },
            { module = esoTERM_loot, function_name = "initialize", },
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
        },
    }
)

local and_GetBagSize_was_called_with = tl.and_GetBagSize_was_called_with
local and_GetItemName_was_called_with_multi_values = tl.and_GetItemName_was_called_with_multi_values
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_initialize_bag_cache_was_called = tl.and_initialize_bag_cache_was_called
local and_register_for_event_was_called_with = tl.and_register_for_event_was_called_with
local and_that_GetBagSize_returns = tl.and_that_GetBagSize_returns
local and_that_GetItemName_is_replaced_by = tl.and_that_GetItemName_is_replaced_by
local and_that_initialize_bag_cache_is_stubbed = tl.and_that_initialize_bag_cache_is_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local get_expected_register_for_event_call_parameters = tl.get_expected_register_for_event_call_parameters
local given_that_bag_cache_is_empty = tl.given_that_bag_cache_is_empty
local given_that_initialize_module_is_stubbed = tl.given_that_initialize_module_is_stubbed
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local then_bag_cache_became = tl.then_bag_cache_became
local then_initialize_module_was_called_with = tl.then_initialize_module_was_called_with
local then_module_became_active = tl.then_module_became_active
local then_module_became_inactive = tl.then_module_became_inactive
local verify_that_module_has_the_expected_name = tl.verify_that_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_bag_cache_is_called = tl.when_initialize_bag_cache_is_called
local when_initialize_is_called = tl.when_initialize_is_called
-- }}}

describe("Test module.", function()
    it("Module is called: loot.",
    function()
        verify_that_module_has_the_expected_name(esoTERM_loot, "loot")
    end)
end)

describe("Test the esoTERM_loot module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize",
    function()
        given_that_initialize_module_is_stubbed()
            and_that_initialize_bag_cache_is_stubbed()

        when_initialize_is_called()
            and_initialize_bag_cache_was_called()

        then_initialize_module_was_called_with(esoTERM_loot)
    end)
end)

describe("Test the esoTERM_loot module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    local function return_item_name_plus_arg(arg)
        return "item_name_" .. arg
    end

    local expected_bag_cache_after_initialize = {
        [0] = {
            item_name = "item_name_0",
            stack_size = 0,
        },
        [1] = {
            item_name = "item_name_1",
            stack_size = 0,
        }
    }

    it("Initialize bag cache",
    function()
        given_that_bag_cache_is_empty()
            and_that_GetBagSize_returns(2)
            and_that_GetItemName_is_replaced_by(return_item_name_plus_arg)

        when_initialize_bag_cache_is_called()

        then_bag_cache_became(expected_bag_cache_after_initialize)
            and_GetBagSize_was_called_with(BAG_BACKPACK)
            and_GetItemName_was_called_with_multi_values({0, 1})
    end)
end)

describe("Test esoTERM_loot module activate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)
    -- TODO: clear chache after tests?

    it("Update cache and subscribe for events on initialization for champion characters.",
    function()
        given_that_module_is_inactive(esoTERM_loot)
            and_that_register_for_event_is_stubbed()

        when_activate_is_called()

        then_module_became_active(esoTERM_loot)
            and_register_for_event_was_called_with(
                get_expected_register_for_event_call_parameters()
            )
            and_active_state_of_the_module_was_saved()
    end)
end)

describe("Test esoTERM_char module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        given_that_module_is_active(esoTERM_loot)
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_is_called()

        then_module_became_inactive()
            and_unregister_from_all_events_was_called_with(match.is_ref(esoTERM_loot))
            and_inactive_state_of_the_module_was_saved()
    end)
end)

describe("Test the event handlers.", function()
    local EVENT = "event"

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    describe("The on loot received event handler.", function()
        local BY = "by"
        local ITEM = "item"
        local QUALITY = 3
        local QUANTITY = 2
        local SOUND = "sound"
        local LOOT_TYPE = "loot_type"
        local MESSAGE = "message"

        -- {{{
        local function given_that_esoTERM_output_stdout_is_stubbed()
            ut_helper.stub_function(esoTERM_output, "stdout", nil)
        end

        local function when_on_loot_received_is_called_with(event, by, item, quantity, sound, loot_type, self)
            esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
        end

        local function then_esoTERM_output_stdout_was_called_with(message)
            assert.spy(esoTERM_output.stdout).was.called_with(message)
        end

        local function and_get_item_received_message_returns(...)
            ut_helper.stub_function(esoTERM_common, "get_item_received_message", ...)
        end

        local function and_get_item_received_message_was_called_with(...)
            assert.spy(esoTERM_common.get_item_received_message).was.called_with(...)
        end
        -- }}}

        it("Looting happy flow.", function()
            given_that_esoTERM_output_stdout_is_stubbed()
                and_get_item_received_message_returns(MESSAGE)

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, true)

            then_esoTERM_output_stdout_was_called_with(MESSAGE)
                and_get_item_received_message_was_called_with(ITEM, QUANTITY)
        end)

        -- {{{
        local function and_get_item_received_message_was_not_called()
            assert.spy(esoTERM_common.get_item_received_message).was_not.called()
        end

        local function then_esoTERM_output_loot_to_chat_tab_was_not_called()
            assert.spy(esoTERM_output.stdout).was_not.called()
        end
        -- }}}

        it("Looting, if not self.", function()
            given_that_esoTERM_output_stdout_is_stubbed()
                and_get_item_received_message_returns(MESSAGE)

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, false)

            then_esoTERM_output_loot_to_chat_tab_was_not_called()
                and_get_item_received_message_was_not_called()
        end)

        -- {{{
        local function when_on_money_received_is_called_with(event, after, before, reason)
            esoTERM_loot.on_money_received(event, after, before, reason)
        end

        local function money_received_message(after, before)
            local diff = after - before
            return "Received " .. diff .. " gold, now you have " .. after .. " gold"
        end
        -- }}}

        it("Money looted", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 150, 100, nil)

            then_esoTERM_output_stdout_was_called_with(money_received_message(150, 100))
        end)

        -- {{{
        local function money_spent_message(after, before)
            local diff = before - after
            return "Spent " .. diff .. " gold, now you have " .. after .. " gold"
        end
        -- }}}

        it("Money spent", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 50, 100, nil)

            then_esoTERM_output_stdout_was_called_with(money_spent_message(50, 100))
        end)

        -- {{{
        local function then_esoTERM_output_stdout_was_not_called()
            assert.spy(esoTERM_output.stdout).was_not.called()
        end
        -- }}}

        it("Money same as before", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 50, 50, nil)

            then_esoTERM_output_stdout_was_not_called()
        end)
    end)
end)
