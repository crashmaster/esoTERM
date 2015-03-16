local requires_for_tests = require("tests/requires_for_tests")
local tl = require("tests/lib/test_esoTERM_common_library")

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
end)

-- vim:fdm=marker
