-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_loot_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_ACTIVE_STATE_OF_THE_MODULE_WAS_SAVED] = {
            { module = esoTERM_loot, module_name_in_settings = "loot" },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = GLOBAL, function_name = "GetItemLink", },
            { module = esoTERM_common, function_name = "register_for_event", },
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_RETURNS] = {
            { module = GLOBAL, function_name = "GetBagSize", },
            { module = GLOBAL, function_name = "GetItemLink", },
            { module = GLOBAL, function_name = "GetSlotStackSize", },
            { module = esoTERM_common, function_name = "get_item_received_message", },
            { module = esoTERM_common, function_name = "get_got_rid_of_item_message", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_REPLACED_BY] = {
            { module = GLOBAL, function_name = "GetItemLink", },
            { module = GLOBAL, function_name = "GetSlotStackSize", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_REGISTER_FOR_EVENT_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED] = {
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = GLOBAL, function_name = "GetBagSize", },
            { module = GLOBAL, function_name = "GetItemLink", },
            { module = GLOBAL, function_name = "GetSlotStackSize", },
            { module = esoTERM_common, function_name = "get_item_received_message", },
            { module = esoTERM_common, function_name = "get_got_rid_of_item_message", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_NOT_CALLED] = {
            { module = GLOBAL, function_name = "GetItemLink", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH_MULTI_VALUES] = {
            { module = GLOBAL, function_name = "GetItemLink", },
            { module = GLOBAL, function_name = "GetSlotStackSize", },
        },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_INACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "initialize_module", },
            { module = esoTERM_output, function_name = "stdout", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_MODULE_BECAME_ACTIVE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED_WITH] = {
            { module = esoTERM_common, function_name = "initialize_module", },
            { module = esoTERM_output, function_name = "stdout", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = {
            { module = esoTERM_output, function_name = "stdout", },
        },
        [FUNCTION_NAME_TEMPLATES.VERIFY_THAT_MODULE_HAS_THE_EXPECTED_NAME] = { { }, },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = esoTERM_loot, function_name = "activate", },
            { module = esoTERM_loot, function_name = "initialize", },
            { module = esoTERM_loot, function_name = "initialize_bag_cache", },
        },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED_WITH] = {
            { module = esoTERM_loot, function_name = "on_money_received", },
            { module = esoTERM_loot, function_name = "on_inventory_single_slot_update", },
        },
    }
)

local and_GetItemLink_was_not_called = tl.and_GetItemLink_was_not_called
local and_that_GetItemLink_is_stubbed = tl.and_that_GetItemLink_is_stubbed
local and_that_get_item_received_message_returns = tl.and_that_get_item_received_message_returns
local and_that_get_got_rid_of_item_message_returns = tl.and_that_get_got_rid_of_item_message_returns
local and_get_item_received_message_was_called_with = tl.and_get_item_received_message_was_called_with
local and_get_got_rid_of_item_message_was_called_with = tl.and_get_got_rid_of_item_message_was_called_with
local and_GetBagSize_was_called_with = tl.and_GetBagSize_was_called_with
local and_GetItemLink_was_called_with = tl.and_GetItemLink_was_called_with
local and_GetItemLink_was_called_with_multi_values = tl.and_GetItemLink_was_called_with_multi_values
local and_GetSlotStackSize_was_called_with = tl.and_GetSlotStackSize_was_called_with
local and_GetSlotStackSize_was_called_with_multi_values = tl.and_GetSlotStackSize_was_called_with_multi_values
local and_active_state_of_the_module_was_saved = tl.and_active_state_of_the_module_was_saved
local and_bag_cache_became = tl.then_bag_cache_became
local and_inactive_state_of_the_module_was_saved = tl.and_inactive_state_of_the_module_was_saved
local and_initialize_bag_cache_was_called = tl.and_initialize_bag_cache_was_called
local and_register_for_event_was_called_with = tl.and_register_for_event_was_called_with
local and_that_GetBagSize_returns = tl.and_that_GetBagSize_returns
local and_that_GetItemLink_is_replaced_by = tl.and_that_GetItemLink_is_replaced_by
local and_that_GetItemLink_returns = tl.and_that_GetItemLink_returns
local and_that_GetSlotStackSize_is_replaced_by = tl.and_that_GetSlotStackSize_is_replaced_by
local and_that_GetSlotStackSize_returns = tl.and_that_GetSlotStackSize_returns
local and_that_initialize_bag_cache_is_stubbed = tl.and_that_initialize_bag_cache_is_stubbed
local and_that_register_for_event_is_stubbed = tl.and_that_register_for_event_is_stubbed
local and_that_unregister_from_all_events_is_stubbed = tl.and_that_unregister_from_all_events_is_stubbed
local and_unregister_from_all_events_was_called_with = tl.and_unregister_from_all_events_was_called_with
local get_expected_register_for_event_call_parameters = tl.get_expected_register_for_event_call_parameters
local given_that_bag_cache_is_empty = tl.given_that_bag_cache_is_empty
local given_that_initialize_module_is_stubbed = tl.given_that_initialize_module_is_stubbed
local given_that_module_is_active = tl.given_that_module_is_active
local given_that_module_is_inactive = tl.given_that_module_is_inactive
local given_that_stdout_is_stubbed = tl.given_that_stdout_is_stubbed
local then_bag_cache_became = tl.then_bag_cache_became
local then_initialize_module_was_called_with = tl.then_initialize_module_was_called_with
local then_module_became_active = tl.then_module_became_active
local then_module_became_inactive = tl.then_module_became_inactive
local then_stdout_was_called_with = tl.then_stdout_was_called_with
local then_stdout_was_not_called = tl.then_stdout_was_not_called
local verify_that_module_has_the_expected_name = tl.verify_that_module_has_the_expected_name
local when_activate_is_called = tl.when_activate_is_called
local when_deactivate_is_called = tl.when_deactivate_is_called
local when_initialize_bag_cache_is_called = tl.when_initialize_bag_cache_is_called
local when_initialize_is_called = tl.when_initialize_is_called
local when_on_inventory_single_slot_update_is_called_with = tl.when_on_inventory_single_slot_update_is_called_with
local when_on_money_received_is_called_with = tl.when_on_money_received_is_called_with
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

    local function fake_GetItemLink(_bag_id, slot_index)
        return "item_link_" .. slot_index
    end

    local function fake_GetSlotStackSize(_bag_id, slot_index)
        local stack = 10 + slot_index
        local max_stack = 200
        return stack, max_stack
    end

    local expected_bag_cache_after_initialize = {
        [0] = {
            item_link = "item_link_0",
            stack_size = 10,
        },
        [1] = {
            item_link = "item_link_1",
            stack_size = 11,
        }
    }

    local expected_GetItemLink_calls = {
        {
            BAG_BACKPACK,
            0,
            LINK_STYLE_DEFAULT,
        },
        {
            BAG_BACKPACK,
            1,
            LINK_STYLE_DEFAULT,
        }
    }

    local expected_GetSlotStackSize_calls = {
        {
            BAG_BACKPACK,
            0,
        },
        {
            BAG_BACKPACK,
            1,
        }
    }

    it("Initialize bag cache",
    function()
        given_that_bag_cache_is_empty()
            and_that_GetBagSize_returns(2)
            and_that_GetItemLink_is_replaced_by(fake_GetItemLink)
            and_that_GetSlotStackSize_is_replaced_by(fake_GetSlotStackSize)

        when_initialize_bag_cache_is_called()

        then_bag_cache_became(expected_bag_cache_after_initialize)
            and_GetBagSize_was_called_with(BAG_BACKPACK)
            and_GetItemLink_was_called_with_multi_values(expected_GetItemLink_calls)
            and_GetSlotStackSize_was_called_with_multi_values(expected_GetSlotStackSize_calls)
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
    local ZERO_ITEM = 0
    local ONE_ITEM = 1
    local TWO_ITEMS = 2
    local MAX_STACK_SIZE = 200
    local SLOT_ID_TO_UPDATE = 1
    local bag_cache_empty = {}
    local bag_cache_one_item = {}
    local bag_cache_two_identical_items = {}

    before_each(function()
        bag_cache_empty = {
            [0] = {
                item_link = "",
                stack_size = 0,
            },
            [1] = {
                item_link = "",
                stack_size = 0,
            }
        }

        bag_cache_one_item = {
            [0] = {
                item_link = "",
                stack_size = 0,
            },
            [1] = {
                item_link = "item_link_1",
                stack_size = ONE_ITEM,
            }
        }

        bag_cache_two_identical_items = {
            [0] = {
                item_link = "",
                stack_size = 0,
            },
            [1] = {
                item_link = "item_link_1",
                stack_size = TWO_ITEMS,
            }
        }
    end)

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    describe("The on single slot update event handler.", function()
        -- {{{
        local function and_that_bag_cache_is(...)
            esoTERM_loot.cache.bag = ...
        end
        -- }}}

        it("The very first item in the backpack received", function()
            given_that_stdout_is_stubbed()
                and_that_bag_cache_is(bag_cache_empty)
                and_that_GetItemLink_returns("item_link_1")
                and_that_GetSlotStackSize_returns(ONE_ITEM, MAX_STACK_SIZE)
                and_that_get_item_received_message_returns("message")

            when_on_inventory_single_slot_update_is_called_with(
                nil, BAG_BACKPACK, SLOT_ID_TO_UPDATE, false, 0, 0
            )

            then_stdout_was_called_with("message")
                and_bag_cache_became(bag_cache_one_item)
                and_GetItemLink_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE, LINK_STYLE_DEFAULT)
                and_GetSlotStackSize_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE)
                and_get_item_received_message_was_called_with("item_link_1", ONE_ITEM)
        end)

        it("Another item from the same kind received", function()
            given_that_stdout_is_stubbed()
                and_that_bag_cache_is(bag_cache_one_item)
                and_that_GetItemLink_is_stubbed()
                and_that_GetSlotStackSize_returns(TWO_ITEMS, MAX_STACK_SIZE)
                and_that_get_item_received_message_returns("message")

            when_on_inventory_single_slot_update_is_called_with(
                nil, BAG_BACKPACK, SLOT_ID_TO_UPDATE, false, 0, 0
            )

            then_stdout_was_called_with("message")
                and_bag_cache_became(bag_cache_two_identical_items)
                and_GetItemLink_was_not_called()
                and_GetSlotStackSize_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE)
                and_get_item_received_message_was_called_with("item_link_1", ONE_ITEM)
        end)

        it("Get rid of one of two identical items", function()
            given_that_stdout_is_stubbed()
                and_that_bag_cache_is(bag_cache_two_identical_items)
                and_that_GetItemLink_is_stubbed()
                and_that_GetSlotStackSize_returns(ONE_ITEM, MAX_STACK_SIZE)
                and_that_get_got_rid_of_item_message_returns("message")

            when_on_inventory_single_slot_update_is_called_with(
                nil, BAG_BACKPACK, SLOT_ID_TO_UPDATE, false, 0, 0
            )

            then_stdout_was_called_with("message")
                and_bag_cache_became(bag_cache_one_item)
                and_GetItemLink_was_not_called()
                and_GetSlotStackSize_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE)
                and_get_got_rid_of_item_message_was_called_with("item_link_1", ONE_ITEM)
        end)

        it("Get rid of the very last item", function()
            given_that_stdout_is_stubbed()
                and_that_bag_cache_is(bag_cache_one_item)
                and_that_GetItemLink_returns("empty_link_1")
                and_that_GetSlotStackSize_returns(ZERO_ITEM, MAX_STACK_SIZE)
                and_that_get_got_rid_of_item_message_returns("message")

            when_on_inventory_single_slot_update_is_called_with(
                nil, BAG_BACKPACK, SLOT_ID_TO_UPDATE, false, 0, 0
            )

            then_stdout_was_called_with("message")
                and_bag_cache_became(bag_cache_one_item)
                and_GetItemLink_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE, LINK_STYLE_DEFAULT)
                and_GetSlotStackSize_was_called_with(BAG_BACKPACK, SLOT_ID_TO_UPDATE)
                and_get_got_rid_of_item_message_was_called_with("item_link_1", ONE_ITEM)
        end)

        it("Update event not for backpack is not printed", function()
            given_that_stdout_is_stubbed()

            when_on_inventory_single_slot_update_is_called_with(nil, BAG_BANK, 0, false, 0, 0)

            then_stdout_was_not_called()
        end)
    end)

    describe("The on money received event handler.", function()
        -- {{{
        local function money_received_message(after, before)
            local diff = after - before
            return "Received " .. diff .. " gold, now you have " .. after .. " gold"
        end
        -- }}}

        it("Money looted", function()
            given_that_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 150, 100, nil)

            then_stdout_was_called_with(money_received_message(150, 100))
        end)

        -- {{{
        local function money_spent_message(after, before)
            local diff = before - after
            return "Spent " .. diff .. " gold, now you have " .. after .. " gold"
        end
        -- }}}

        it("Money spent", function()
            given_that_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 50, 100, nil)

            then_stdout_was_called_with(money_spent_message(50, 100))
        end)

        it("Money same as before", function()
            given_that_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 50, 50, nil)

            then_stdout_was_not_called()
        end)
    end)
end)
