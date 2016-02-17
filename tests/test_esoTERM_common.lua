-- Locals {{{
local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_common_library")

tl.setup_test_functions(
    {
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_IS_STUBBED] = {
            { module = esoTERM_common, function_name = "register_module", },
            { module = tl.dummy_module, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_THAT_X_RETURNS] = {
            { module = GLOBAL, function_name = "GetItemLinkQuality", },
            { module = GLOBAL, function_name = "GetItemQualityColor", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_X_WAS_CALLED_WITH] = {
            { module = GLOBAL, function_name = "GetItemLinkQuality", },
            { module = GLOBAL, function_name = "GetItemQualityColor", },
            { module = GLOBAL, function_name = "zo_strformat", },
            { module = esoTERM_common, function_name = "register_module", },
        },
        [FUNCTION_NAME_TEMPLATES.AND_ZO_SAVEDVARS_NEW_WAS_CALLED_WITH] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_ACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.GIVEN_THAT_MODULE_IS_SET_INACTIVE_IN_THE_CONFIG_FILE] = { { }, },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_CALLED] = {
            { module = tl.dummy_module, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.THEN_X_WAS_NOT_CALLED] = {
            { module = tl.dummy_module, function_name = "activate", },
        },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED] = {
            { module = tl.dummy_module, function_name = "initialize", },
        },
        [FUNCTION_NAME_TEMPLATES.WHEN_X_IS_CALLED_WITH] = {
            { module = esoTERM_common, function_name = "get_item_received_message", },
            { module = esoTERM_common, function_name = "get_got_rid_of_item_message", },
        },
    }
)

local and_GetItemLinkQuality_was_called_with = tl.and_GetItemLinkQuality_was_called_with
local and_GetItemQualityColor_was_called_with = tl.and_GetItemQualityColor_was_called_with
local and_ZO_SavedVars_new_was_called_with = tl.and_ZO_SavedVars_new_was_called_with
local and_register_module_was_called_with = tl.and_register_module_was_called_with
local and_that_GetItemQualityColor_returns = tl.and_that_GetItemQualityColor_returns
local and_that_activate_is_stubbed = tl.and_that_activate_is_stubbed
local and_that_register_module_is_stubbed = tl.and_that_register_module_is_stubbed
local and_zo_strformat_was_called_with = tl.and_zo_strformat_was_called_with
local given_that_GetItemLinkQuality_returns = tl.and_that_GetItemLinkQuality_returns
local given_that_module_is_set_active_in_the_config_file = tl.given_that_module_is_set_active_in_the_config_file
local given_that_module_is_set_inactive_in_the_config_file = tl.given_that_module_is_set_inactive_in_the_config_file
local then_activate_was_called = tl.then_activate_was_called
local then_activate_was_not_called = tl.then_activate_was_not_called
local when_get_item_received_message_is_called_with = tl.when_get_item_received_message_is_called_with
local when_get_got_rid_of_item_message_is_called_with = tl.when_get_got_rid_of_item_message_is_called_with
local when_initialize_is_called = tl.when_initialize_is_called
-- }}}

describe("Test common functions.", function()
    describe("Local register for subscribed events.", function()
        local fake_module = {
            event_register = {},
            module_name = "fake_module"
        }
        local fake_event_1 = 123
        local fake_event_2 = 456
        local fake_event_3 = 789
        local fake_callback_1 = function() return nil end
        local fake_callback_2 = function() return nil end
        local fake_callback_3 = function() return nil end

        before_each(function()
            fake_module.event_register = {}
        end)

        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        -- {{{
        local function given_that_event_register_is_empty()
            assert.is.equal(0, ut_helper.table_size(fake_module.event_register))
        end

        local function and_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
        end

        local function when_event_is_registered()
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_1,
                                              fake_callback_1)
        end

        local function then_the_event_was_registered_both_in_eso_and_locally()
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER, fake_module.module_name, fake_event_1, fake_callback_1)
            assert.is.equal(true, fake_module.event_register[fake_event_1] == true)
        end
        -- }}}

        it("Register for event.",
        function()
            given_that_event_register_is_empty()
                and_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()

            when_event_is_registered()

            then_the_event_was_registered_both_in_eso_and_locally()
        end)

        -- {{{
        local function given_that_event_register_has_one_active_event()
            fake_module.event_register[fake_event_1] = true
        end

        local function and_that_EVENT_MANAGER_UnregisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
        end

        local function when_event_is_unregistered()
            esoTERM_common.unregister_from_event(fake_module, fake_event_1)
        end

        local function then_the_event_was_unregistered_both_locally_and_in_eso()
            assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
                EVENT_MANAGER, fake_module.module_name, fake_event_1)
            assert.is.equal(true, fake_module.event_register[fake_event_1] == false)
        end
        -- }}}

        it("Unregister from event.",
        function()
            given_that_event_register_has_one_active_event()
                and_that_EVENT_MANAGER_UnregisterForEvent_is_stubbed()

            when_event_is_unregistered()

            then_the_event_was_unregistered_both_locally_and_in_eso()
        end)

        -- {{{
        local function given_that_event_register_has_two_active_events()
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_1,
                                              fake_callback_1)
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_2,
                                              fake_callback_2)
        end

        local function and_that_unregister_from_event_is_stubbed()
            ut_helper.stub_function(esoTERM_common, "unregister_from_event", nil)
        end

        local function when_unregister_from_all_events_is_called()
            esoTERM_common.unregister_from_all_events(fake_module)
        end

        local function then_unregister_from_event_is_called_twice()
            assert.spy(esoTERM_common.unregister_from_event).was.called(2)
            assert.spy(esoTERM_common.unregister_from_event).was.called_with(fake_module, fake_event_1)
            assert.spy(esoTERM_common.unregister_from_event).was.called_with(fake_module, fake_event_2)
        end
        -- }}}

        it("Unregister from all active events.",
        function()
            given_that_event_register_has_two_active_events()
                and_that_unregister_from_event_is_stubbed()

            when_unregister_from_all_events_is_called()

            then_unregister_from_event_is_called_twice()
        end)

        -- {{{
        local function given_that_event_register_has_two_active_and_one_inactive_events()
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_1,
                                              fake_callback_1)
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_2,
                                              fake_callback_2)
            esoTERM_common.register_for_event(fake_module,
                                              fake_event_3,
                                              fake_callback_3)
            esoTERM_common.unregister_from_event(fake_module,
                                                 fake_event_3)
        end
        -- }}}

        it("Unregister from all active events, there is one inactive too.",
        function()
            given_that_event_register_has_two_active_and_one_inactive_events()
                and_that_unregister_from_event_is_stubbed()

            when_unregister_from_all_events_is_called()

            then_unregister_from_event_is_called_twice()
        end)
    end)

    describe("Register for active/inactive modules.", function()
        after_each(function()
            tl.clean_test_module_register()
        end)

        it("Empty register does not contain module.",
        function()
            tl.given_that_module_register_is_empty()

            tl.then_the_module_register_does_not_contains_module(module_register, module)
        end)

        it("Register module.",
        function()
            tl.given_that_module_register_is_empty()

            tl.when_module_registered()

            tl.then_the_module_register_contains_that_module()
        end)

        it("Get registered module by not case-sensitive name.",
        function()
            tl.given_that_test_module_is_registered()

            tl.then_the_getter_returns_the_registered_module()
        end)
    end)

    describe("String is split into array of strings at spaces.", function()
        it("Empty input string results in empty output array.",
        function()
            tl.split_string_into_strings_at_spaces("", {})
        end)

        it("Input string does not contain space.",
        function()
            tl.split_string_into_strings_at_spaces("aaaa", {"aaaa"})
        end)

        it("Input string contains some spaces.",
        function()
            tl.split_string_into_strings_at_spaces("a aa 1", {"a", "aa", "1"})
        end)

        it("Input string contains multiple spaces.",
        function()
            tl.split_string_into_strings_at_spaces("a  aa    a", {"a", "aa", "a"})
        end)
    end)

    describe("Get item received/got rid of log message including colorized item link.", function()
        local NAME_OF_ITEM_RECEIVED = "item"
        local NAME_OF_ITEM_GOT_RID_OF = "item"
        local NUMBER_OF_ITEMS_RECEIVED = 1
        local NUMBER_OF_ITEMS_GOT_RID_OF = 1
        local NUMBER_OF_ITEMS_IN_BACKPACK = 2
        local NUMBER_OF_ITEMS_IN_BANK = 10
        local EXPECTED_ITEM_RECEIVED_MESSAGE =
            "Received " ..
            NUMBER_OF_ITEMS_RECEIVED ..
            " [" .. NAME_OF_ITEM_RECEIVED .. "]:" ..
            " backpack: " .. NUMBER_OF_ITEMS_IN_BACKPACK .. "," ..
            " bank: " .. NUMBER_OF_ITEMS_IN_BANK
        local EXPECTED_ITEM_GOT_RID_OF_MESSAGE =
            "Got rid of " ..
            NUMBER_OF_ITEMS_GOT_RID_OF ..
            " [" .. NAME_OF_ITEM_GOT_RID_OF .. "]:" ..
            " backpack: " .. NUMBER_OF_ITEMS_IN_BACKPACK .. "," ..
            " bank: " .. NUMBER_OF_ITEMS_IN_BANK

        local fake_color = {
            Colorize = function(self, message) return message end
        }

        before_each(function()
            spy.on(fake_color, "Colorize")
            spy.on(GLOBAL, "zo_strformat")
        end)

        after_each(function()
            fake_color.Colorize:revert()
            GLOBAL.zo_strformat:revert()
        end)

        -- {{{
        local function then_the_returned_message_was(...)
            assert.is.equal(...)
        end

        local function and_fake_color_was_called()
            assert.spy(fake_color.Colorize).was.called(2)
            assert.spy(fake_color.Colorize).was.called_with(fake_color, "[")
            assert.spy(fake_color.Colorize).was.called_with(fake_color, "]")
        end
        -- }}}

        it("Get item received message gives the expected output",
        function()
            given_that_GetItemLinkQuality_returns("quality")
                and_that_GetItemQualityColor_returns(fake_color)

            actual_message = when_get_item_received_message_is_called_with(
                NAME_OF_ITEM_RECEIVED,
                NUMBER_OF_ITEMS_RECEIVED,
                NUMBER_OF_ITEMS_IN_BACKPACK,
                NUMBER_OF_ITEMS_IN_BANK)

            then_the_returned_message_was(EXPECTED_ITEM_RECEIVED_MESSAGE, actual_message)
                and_GetItemLinkQuality_was_called_with(NAME_OF_ITEM_RECEIVED)
                and_GetItemQualityColor_was_called_with("quality")
                and_fake_color_was_called()
                and_zo_strformat_was_called_with(SI_TOOLTIP_ITEM_NAME, NAME_OF_ITEM_RECEIVED)
        end)

        it("Get got rid of item message gives the expected output",
        function()
            given_that_GetItemLinkQuality_returns("quality")
                and_that_GetItemQualityColor_returns(fake_color)

            actual_message = when_get_got_rid_of_item_message_is_called_with(
                NAME_OF_ITEM_GOT_RID_OF,
                NUMBER_OF_ITEMS_GOT_RID_OF,
                NUMBER_OF_ITEMS_IN_BACKPACK,
                NUMBER_OF_ITEMS_IN_BANK)

            then_the_returned_message_was(EXPECTED_ITEM_GOT_RID_OF_MESSAGE, actual_message)
                and_GetItemLinkQuality_was_called_with(NAME_OF_ITEM_GOT_RID_OF)
                and_GetItemQualityColor_was_called_with("quality")
                and_fake_color_was_called()
                and_zo_strformat_was_called_with(SI_TOOLTIP_ITEM_NAME, NAME_OF_ITEM_GOT_RID_OF)
        end)
    end)

    describe("Test module initialization.", function()
        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        it("Initialize, but do not activate when configured as inactive.",
        function()
            given_that_module_is_set_inactive_in_the_config_file(tl.dummy_module_name)
                and_that_register_module_is_stubbed()
                and_that_activate_is_stubbed()

            when_initialize_is_called()

            then_activate_was_not_called()
                and_ZO_SavedVars_new_was_called_with(tl.dummy_module_name)
                and_register_module_was_called_with(esoTERM.module_register, tl.dummy_module)
        end)

        it("Initialize, and activate when configured as active.",
        function()
            given_that_module_is_set_active_in_the_config_file(tl.dummy_module_name)
                and_that_register_module_is_stubbed()
                and_that_activate_is_stubbed()

            when_initialize_is_called()

            then_activate_was_called()
                and_ZO_SavedVars_new_was_called_with(tl.dummy_module_name)
                and_register_module_was_called_with(esoTERM.module_register, tl.dummy_module)
        end)
    end)
end)
