local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_loot_library")

describe("Test module.", function()
    local name = "loot"

    -- {{{
    local function when_module_name_is_get_then_expected_name_is_returned(name)
        assert.is.equal(name, esoTERM_loot.module_name)
    end
    -- }}}

    it("Module is called: esoTERM-loot.",
    function()
        when_module_name_is_get_then_expected_name_is_returned(name)
    end)
end)

describe("Test the esoTERM_loot module initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Initialize, but do not activate when configured as inactive.",
    function()
        tl.given_that_module_configured_as_inactive()
            tl.and_that_register_module_is_stubbed()
            tl.and_that_esoTERM_loot_activate_is_stubbed()

        tl.when_initialize_is_called()

        tl.then_esoTERM_loot_activate_was_not_called()
            tl.and_zo_savedvars_new_was_called()
            tl.and_register_module_was_called()
    end)

    it("Initialize, and activate when configured as active.",
    function()
        tl.given_that_module_configured_as_active()
            tl.and_that_register_module_is_stubbed()
            tl.and_that_esoTERM_loot_activate_is_stubbed()

        tl.when_initialize_is_called()

        tl.then_esoTERM_loot_activate_was_called()
            tl.and_zo_savedvars_new_was_called()
            tl.and_register_module_was_called()
    end)
end)

describe("Test esoTERM_loot module activate.", function()
    after_each(function()
        tl.expected_register_for_event_calls_are_cleared()
        ut_helper.restore_stubbed_functions()
    end)
    -- TODO: clear chache after tests?

    it("Update cache and subscribe for events on initialization for champion characters.",
    function()
        tl.given_that_module_is_inactive()
            tl.and_that_cache_is_empty()
            tl.and_that_expected_register_for_event_calls_are_set_up()
            tl.and_that_register_for_event_is_stubbed()
            tl.and_that_getter_functions_are_stubbed()

        tl.when_activate_is_called()

        tl.and_module_became_active()
            tl.and_cache_is_no_longer_empty()
            tl.and_register_for_event_was_called_with_expected_parameters()
            tl.and_getter_function_stubs_were_called()
            tl.and_cached_values_became_initialized()
            tl.and_module_is_active_was_saved()
    end)
end)

describe("Test esoTERM_char module deactivate.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    it("Unsubscribe from active events on deactivate.",
    function()
        tl.given_that_module_is_active()
            tl.and_that_unregister_from_all_events_is_stubbed()

        tl.when_deactivate_for_the_module_is_called()

        tl.then_module_became_inactive()
            tl.and_unregister_from_all_events_was_called()
            tl.and_module_is_inactive_was_saved()
    end)
end)

describe("Test Loot related data getters.", function()
    local results = {}

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        results = nil
    end)

    -- {{{
    local function given_that_cached_looted_item_is_not_set()
        tl.CACHE.looted_item = nil
    end

    local function when_get_looted_item_is_called_with_cache()
        results.looted_item = esoTERM_loot.get_looted_item()
    end

    local function then_the_returned_looted_item_was(item)
        assert.is.equal(item, results.looted_item)
    end
    -- }}}

    it("Query CHARACTER LOOTED ITEM, when NOT CACHED.",
    function()
        given_that_cached_looted_item_is_not_set()

        when_get_looted_item_is_called_with_cache()

        then_the_returned_looted_item_was("N/A")
    end)

    -- {{{
    local function given_that_cached_looted_item_is(item)
        tl.CACHE.looted_item = item
    end
    -- }}}

    it("Query CHARACTER LOOTED ITEM, when CACHED.",
    function()
        given_that_cached_looted_item_is(tl.LOOTED_ITEM)

        when_get_looted_item_is_called_with_cache()

        then_the_returned_looted_item_was(tl.LOOTED_ITEM)
    end)

    -- {{{
    local function given_that_cached_loot_quantity_is_not_set()
        tl.CACHE.loot_quantity = nil
    end

    local function when_get_loot_quantity_is_called_with_cache()
        results.loot_quantity = esoTERM_loot.get_loot_quantity()
    end

    local function then_the_returned_loot_quantity_was(item)
        assert.is.equal(item, results.loot_quantity)
    end
    -- }}}

    it("Query CHARACTER LOOT QUANTITY, when NOT CACHED.",
    function()
        given_that_cached_loot_quantity_is_not_set()

        when_get_loot_quantity_is_called_with_cache()

        then_the_returned_loot_quantity_was(0)
    end)

    -- {{{
    local function given_that_cached_loot_quantity_is(item)
        tl.CACHE.loot_quantity = item
    end
    -- }}}

    it("Query CHARACTER LOOT QUANTITY, when CACHED.",
    function()
        given_that_cached_loot_quantity_is(tl.LOOT_QUANTITY)

        when_get_loot_quantity_is_called_with_cache()

        then_the_returned_loot_quantity_was(tl.LOOT_QUANTITY)
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
        local function given_that_esoTERM_output_stdout_is_stubbed()
            ut_helper.stub_function(esoTERM_output, "stdout", nil)
        end

        local function and_get_looted_item_returns(item)
            ut_helper.stub_function(esoTERM_loot, "get_looted_item", item)
        end

        local function and_get_looted_item_was_called()
            assert.spy(esoTERM_loot.get_looted_item).was.called_with()
        end

        local function and_GetItemLinkQuality_returns(quality)
            ut_helper.stub_function(GLOBAL, "GetItemLinkQuality", quality)
        end

        local function and_GetItemLinkQuality_was_called_with(item)
            assert.spy(GLOBAL.GetItemLinkQuality).was.called_with(item)
        end

        local function and_GetItemQualityColor_returns_fake_color()
            ut_helper.stub_function(GLOBAL, "GetItemQualityColor", fake_color)
        end

        local function and_GetItemQualityColor_was_called_with(quality)
            assert.spy(GLOBAL.GetItemQualityColor).was.called_with(quality)
        end

        local function and_get_loot_quantity_returns(quantity)
            ut_helper.stub_function(esoTERM_loot, "get_loot_quantity", quantity)
        end

        local function and_get_loot_quantity_was_called()
            assert.spy(esoTERM_loot.get_loot_quantity).was.called_with()
        end

        local function when_on_loot_received_is_called_with(event, by, item, quantity, sound, loot_type, self)
            esoTERM_loot.on_loot_received(event, by, item, quantity, sound, loot_type, self)
        end

        local function get_loot_message()
            return string.format("Received " ..  QUANTITY .. " " .. "[" .. ITEM .. "]")
        end

        local function then_esoTERM_output_stdout_was_called_with(message)
            assert.spy(esoTERM_output.stdout).was.called_with(message)
        end

        local function and_fake_color_was_called()
            assert.spy(fake_color.Colorize).was.called(2)
            assert.spy(fake_color.Colorize).was.called_with(fake_color, "[")
            assert.spy(fake_color.Colorize).was.called_with(fake_color, "]")
        end

        local function and_zo_strformat_was_called()
            assert.spy(GLOBAL.zo_strformat).was.called_with(SI_TOOLTIP_ITEM_NAME, ITEM)
        end
        -- }}}

        it("Looting happy flow.", function()
            given_that_esoTERM_output_stdout_is_stubbed()
                and_get_looted_item_returns(ITEM)
                and_GetItemLinkQuality_returns(QUALITY)
                and_GetItemQualityColor_returns_fake_color()
                and_get_loot_quantity_returns(QUANTITY)

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, true)

            then_esoTERM_output_stdout_was_called_with(get_loot_message())
                and_get_looted_item_was_called()
                and_GetItemLinkQuality_was_called_with(ITEM)
                and_GetItemQualityColor_was_called_with(QUALITY)
                and_get_loot_quantity_was_called()
                and_fake_color_was_called()
                and_zo_strformat_was_called()
        end)

        -- {{{
        local function and_get_loot_message_is_stubbed()
            ut_helper.stub_function(esoTERM_loot, "get_loot_message", nil)
        end

        local function and_get_loot_message_was_not_called()
            assert.spy(esoTERM_loot.get_loot_message).was_not.called()
        end

        local function then_esoTERM_output_loot_to_chat_tab_was_not_called()
            assert.spy(esoTERM_output.stdout).was_not.called()
        end
        -- }}}

        it("Looting, if not self.", function()
            given_that_esoTERM_output_stdout_is_stubbed()
                and_get_loot_message_is_stubbed()

            when_on_loot_received_is_called_with(EVENT, BY, ITEM, QUANTITY, SOUND, LOOT_TYPE, false)

            then_esoTERM_output_loot_to_chat_tab_was_not_called()
                and_get_loot_message_was_not_called()
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

-- vim:fdm=marker
