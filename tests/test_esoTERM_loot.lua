local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

local A_STRING = "aAaAa"
local A_INTEGER = 1111

local LOOTED_ITEM = A_STRING
local LOOT_QUANTITY = A_INTEGER

local CACHE = esoTERM_loot.cache
local EVENT_REGISTER = esoTERM_loot.event_register

describe("Test module.", function()
    local name = "esoTERM-loot"

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

describe("Test Loot module initialization.", function()
    local return_values_of_the_getter_stubs = {
        get_loot_quantity = LOOT_QUANTITY,
        get_looted_item = LOOTED_ITEM,
    }
    local expected_cached_values = {
        loot_quantity = LOOT_QUANTITY,
        looted_item = LOOTED_ITEM,
    }

    local expected_register_params = {}

    local function setup_getter_stubs()
        for getter, return_value in pairs(return_values_of_the_getter_stubs) do
            ut_helper.stub_function(esoTERM_loot, getter, return_value)
        end
    end

    setup(function()
        setup_getter_stubs()
    end)

    after_each(function()
        expected_register_params = nil
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cache_is_empty()
        assert.is.equal(0, ut_helper.table_size(CACHE))
    end

    local function and_that_register_for_event_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_for_event", nil)
    end

    local function and_that_expected_register_event_parameters_are_set_up()
        expected_register_params.loot_received_update = {
            local_register = EVENT_REGISTER,
            event = EVENT_LOOT_RECEIVED,
            callback = esoTERM_loot.on_loot_received
        }
        expected_register_params.money_received_update = {
            local_register = EVENT_REGISTER,
            event = EVENT_MONEY_UPDATE,
            callback = esoTERM_loot.on_money_received
        }
    end

    local function and_that_register_module_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "register_module", nil)
    end

    local function when_initialize_is_called()
        esoTERM_loot.initialize()
    end

    local function then_cache_is_no_longer_empty()
        assert.is_not.equal(0, ut_helper.table_size(CACHE))
    end

    local function and_cached_values_became_initialized()
        for cache_attribute, expected_value in pairs(expected_cached_values) do
            assert.is.equal(expected_value, CACHE[cache_attribute])
        end
    end

    local function and_getter_stubs_were_called_with_cache()
        for getter, _ in pairs(return_values_of_the_getter_stubs) do
            assert.spy(esoTERM_loot[getter]).was.called_with(esoTERM_loot)
        end
    end

    local function and_register_for_event_was_called_with(expected_params)
        assert.spy(esoTERM_common.register_for_event).was.called(ut_helper.table_size(expected_params))
        for param in pairs(expected_params) do
            assert.spy(esoTERM_common.register_for_event).was.called_with(
                expected_params[param].local_register,
                expected_params[param].event,
                expected_params[param].callback
            )
            assert.is_not.equal(nil, expected_params[param].callback)
        end
    end

    local function and_register_module_was_called()
        assert.spy(esoTERM_common.register_module).was.called_with(
            esoTERM.module_register, esoTERM_loot)
    end

    local function and_module_is_active()
        assert.is.equal(true, esoTERM_loot.is_active)
    end
    -- }}}

    it("Cached loot data is updated and subscribed for events.",
    function()
        given_that_cache_is_empty()
            and_that_register_for_event_is_stubbed()
            and_that_expected_register_event_parameters_are_set_up()
            and_that_register_module_is_stubbed()

        when_initialize_is_called()

        then_cache_is_no_longer_empty()
            and_cached_values_became_initialized()
            and_getter_stubs_were_called_with_cache()
            and_register_for_event_was_called_with(expected_register_params)
            and_register_module_was_called()
            and_module_is_active()
    end)
end)

describe("Test deactivate.", function()
    -- {{{
    local function given_that_module_is_active()
        esoTERM_loot.is_active = true
    end

    local function and_that_unregister_from_all_events_is_stubbed()
        ut_helper.stub_function(esoTERM_common, "unregister_from_all_events", nil)
    end

    local function when_deactivate_for_the_module_is_called()
        esoTERM_loot.deactivate()
    end

    local function then_unregister_from_all_events_was_called()
        assert.spy(esoTERM_common.unregister_from_all_events).was.called_with(EVENT_REGISTER)
    end

    local function and_module_becomes_inactive()
        assert.is.equal(false, esoTERM_loot.is_active)
    end
    -- }}}

    it("Unsubscribe from active events and set activeness to false.",
    function()
        given_that_module_is_active()
            and_that_unregister_from_all_events_is_stubbed()

        when_deactivate_for_the_module_is_called()

        then_unregister_from_all_events_was_called()
            and_module_becomes_inactive()
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
        CACHE.looted_item = nil
    end

    local function when_get_looted_item_is_called_with_cache()
        results.looted_item = esoTERM_loot:get_looted_item()
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
        CACHE.looted_item = item
    end
    -- }}}

    it("Query CHARACTER LOOTED ITEM, when CACHED.",
    function()
        given_that_cached_looted_item_is(LOOTED_ITEM)

        when_get_looted_item_is_called_with_cache()

        then_the_returned_looted_item_was(LOOTED_ITEM)
    end)

    -- {{{
    local function given_that_cached_loot_quantity_is_not_set()
        CACHE.loot_quantity = nil
    end

    local function when_get_loot_quantity_is_called_with_cache()
        results.loot_quantity = esoTERM_loot:get_loot_quantity()
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
        CACHE.loot_quantity = item
    end
    -- }}}

    it("Query CHARACTER LOOT QUANTITY, when CACHED.",
    function()
        given_that_cached_loot_quantity_is(LOOT_QUANTITY)

        when_get_loot_quantity_is_called_with_cache()

        then_the_returned_loot_quantity_was(LOOT_QUANTITY)
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
            assert.spy(esoTERM_loot.get_looted_item).was.called_with(esoTERM_loot)
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
            assert.spy(esoTERM_loot.get_loot_quantity).was.called_with(esoTERM_loot)
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

        local function get_money_loot_message(after, before)
            local diff = after - before
            return "Received " .. diff .. " gold, now you have " .. after .. " gold"
        end
        -- }}}

        it("Money looted", function()
            given_that_esoTERM_output_stdout_is_stubbed()

            when_on_money_received_is_called_with(nil, 150, 100, nil)

            then_esoTERM_output_stdout_was_called_with(get_money_loot_message(150, 100))
        end)
    end)
end)

-- vim:fdm=marker
