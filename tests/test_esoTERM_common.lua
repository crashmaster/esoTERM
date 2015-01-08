local requires_for_tests = require("tests/requires_for_tests")

describe("Test common functions.", function()
    describe("Local register for subscribed events.", function()
        local event_register = {}
        local fake_event_1 = 123
        local fake_event_2 = 456
        local fake_event_3 = 789
        local fake_callback_1 = function() return nil end
        local fake_callback_2 = function() return nil end
        local fake_callback_3 = function() return nil end

        before_each(function()
            event_register = {}
        end)

        after_each(function()
            ut_helper.restore_stubbed_functions()
        end)

        -- {{{
        local function given_that_event_register_is_empty()
            assert.is.equal(0, ut_helper.table_size(event_register))
        end

        local function and_that_EVENT_MANAGER_RegisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "RegisterForEvent", nil)
        end

        local function when_event_is_registered()
            esoTERM_common.register_for_event(event_register,
                                              fake_event_1,
                                              fake_callback_1)
        end

        local function then_the_event_was_registered_both_in_eso_and_locally()
            assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                EVENT_MANAGER, esoTERM.ADDON_NAME, fake_event_1, fake_callback_1)
            assert.is.equal(true, event_register[fake_event_1] == true)
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
            event_register[fake_event_1] = true
        end

        local function and_that_EVENT_MANAGER_UnregisterForEvent_is_stubbed()
            ut_helper.stub_function(EVENT_MANAGER, "UnregisterForEvent", nil)
        end

        local function when_event_is_unregistered()
            esoTERM_common.unregister_from_event(event_register, fake_event_1)
        end

        local function then_the_event_was_unregistered_both_locally_and_in_eso()
            assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
                EVENT_MANAGER, esoTERM.ADDON_NAME, fake_event_1)
            assert.is.equal(true, event_register[fake_event_1] == false)
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
            esoTERM_common.register_for_event(event_register,
                                              fake_event_1,
                                              fake_callback_1)
            esoTERM_common.register_for_event(event_register,
                                              fake_event_2,
                                              fake_callback_2)
        end

        local function and_that_unregister_from_event_is_stubbed()
            ut_helper.stub_function(esoTERM_common, "unregister_from_event", nil)
        end

        local function when_unregister_from_all_events_is_called()
            esoTERM_common.unregister_from_all_events(event_register)
        end

        local function then_unregister_from_event_is_called_twice()
            assert.spy(esoTERM_common.unregister_from_event).was.called(2)
            assert.spy(esoTERM_common.unregister_from_event).was.called_with(event_register, fake_event_1)
            assert.spy(esoTERM_common.unregister_from_event).was.called_with(event_register, fake_event_2)
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
            esoTERM_common.register_for_event(event_register,
                                              fake_event_1,
                                              fake_callback_1)
            esoTERM_common.register_for_event(event_register,
                                              fake_event_2,
                                              fake_callback_2)
            esoTERM_common.register_for_event(event_register,
                                              fake_event_3,
                                              fake_callback_3)
            esoTERM_common.unregister_from_event(event_register,
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
        local module_register = {}
        local module = {}

        before_each(function()
            module_register = {}
        end)

        -- {{{
        local function given_that_module_register_is_empty(register)
            assert.is.equal(0, ut_helper.table_size(register))
        end

        local function contains_module(module_register, expected_module)
            for index, module in pairs(module_register) do
                if module == expected_module then
                    return true
                end
            end
            return false
        end

        local function then_the_module_register_does_not_contains_module(register, module)
            assert.is.equal(false, contains_module(register, module))
        end
        -- }}}

        it("Empty register does not contain module.",
        function()
            given_that_module_register_is_empty(module_register)

            then_the_module_register_does_not_contains_module(module_register, module)
        end)

        -- {{{
        local function when_module_registered(register, module)
            esoTERM_common.register_module(register, module)
        end

        local function then_the_module_register_contains_that_module(register, module)
            assert.is.equal(true, contains_module(register, module))
        end
        -- }}}

        it("Register module.",
        function()
            given_that_module_register_is_empty(module_register)

            when_module_registered(module_register, module)

            then_the_module_register_contains_that_module(module_register, module)
        end)
    end)

    -- {{{
    local function split_string_into_strings_at_spaces(input_string, output_array)
        local result = esoTERM_common.split(input_string)
        for index, string in ipairs(output_array) do
            assert.is.equal(result[index], string)
        end
    end
    -- }}}

    describe("String is split into array of strings at spaces.", function()
        it("Empty input string results in empty output array.",
        function()
            split_string_into_strings_at_spaces("", {})
        end)

        it("Input string does not contain space.",
        function()
            split_string_into_strings_at_spaces("aaaa", {"aaaa"})
        end)

        it("Input string contains some spaces.",
        function()
            split_string_into_strings_at_spaces("a aa 1", {"a", "aa", "1"})
        end)

        it("Input string contains multiple spaces.",
        function()
            split_string_into_strings_at_spaces("a  aa    a", {"a", "aa", "a"})
        end)
    end)
end)

-- vim:fdm=marker
