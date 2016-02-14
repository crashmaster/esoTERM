local requires_for_tests = require("tests/requires_for_tests")

local GLOBAL = _G

local WINDOW = "window"
local FRAGMENT = "fragment"

local SCENES_WHERE_VISIBLE = {
    "achievements",
    "alchemy",
    "bank",
    "cadwellsAlmanac",
    "campaignBrowser",
    "campaignOverview",
    "enchanting",
    "fence_keyboard",
    "friendsList",
    "groupList",
    "groupingToolsKeyboard",
    "guildHistory",
    "guildHome",
    "guildRanks",
    "guildRoster",
    "helpCustomerSupport",
    "helpTutorials",
    "hud",
    "hudui",
    "ignoreList",
    "interact",
    "leaderboards",
    "loreLibrary",
    "mailInbox",
    "mailSend",
    "notifications",
    "provisioner",
    "questJournal",
    "siegeBar",
    "skills",
    "stables",
    "stats",
    "store",
    "tradinghouse",
}

describe("Test esoTERM window initialization.", function()
    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_ZO_SavedVars_New_is_stubbed()
        ut_helper.stub_function(ZO_SavedVars, "New", nil)
    end

    local function and_that_create_is_stubbed()
        ut_helper.stub_function(esoTERM_window, "create", nil)
    end

    local function and_that_set_window_visibility_is_stubbed()
        ut_helper.stub_function(esoTERM_window, "set_window_visibility", nil)
    end

    local function when_initialize_is_called()
        esoTERM_window.initialize()
    end

    local function then_ZO_SavedVars_New_was_called()
        assert.spy(esoTERM_window.set_window_visibility).was.called_with(
            "esoTERM_settings", 1, nil, esoTERM_window.default_settings
        )
    end

    local function and_create_was_called()
        assert.spy(esoTERM_window.create).was.called()
    end

    local function and_set_window_visibility_was_called()
        assert.spy(esoTERM_window.set_window_visibility).was.called()
    end
    -- }}}

    it("Window-create and visibility-setup is called on initialization.", function()
        given_that_ZO_SavedVars_New_is_stubbed()
            and_that_create_is_stubbed()
            and_that_set_window_visibility_is_stubbed()

        when_initialize_is_called()

            and_create_was_called()
            and_set_window_visibility_was_called()
    end)

    -- {{{
    local function given_that_top_level_window_is_set_to(window)
        esoTERM_window.etw = window
    end

    local function and_that_ZO_SimpleSceneFragment_New_returns(fragment)
        ut_helper.stub_function(ZO_SimpleSceneFragment, "New", fragment)
    end

    local function and_that_SCENE_MANAGER_GetScene_returns(scene)
        ut_helper.stub_function(SCENE_MANAGER, "GetScene", scene)
    end

    local function and_SCENE_AddFragment_is_stubbed()
        ut_helper.stub_function(SCENE, "AddFragment", nil)
    end

    local function when_set_window_visibility_is_called()
        esoTERM_window.set_window_visibility()
    end

    local function then_ZO_SimpleSceneFragment_New_was_called(window)
        assert.spy(ZO_SimpleSceneFragment.New).was.called_with(
            ZO_SimpleSceneFragment,
            window)
    end

    local function and_SCENE_MANAGER_GetScene_was_called()
        assert.spy(SCENE_MANAGER.GetScene).was.called(#SCENES_WHERE_VISIBLE)
        for i, scene in ipairs(SCENES_WHERE_VISIBLE) do
            assert.spy(SCENE_MANAGER.GetScene).was.called_with(SCENE_MANAGER, scene)
        end
    end

    local function and_SCENE_AddFragment_was_called()
        assert.spy(SCENE.AddFragment).was.called(#SCENES_WHERE_VISIBLE)
        for i, scene in ipairs(SCENES_WHERE_VISIBLE) do
            assert.spy(SCENE.AddFragment).was.called_with(SCENE, FRAGMENT)
        end
    end
    -- }}}

    it("Window visibility is specified.", function()
        given_that_top_level_window_is_set_to(WINDOW)
            and_that_ZO_SimpleSceneFragment_New_returns(FRAGMENT)
            and_that_SCENE_MANAGER_GetScene_returns(SCENE)
            and_SCENE_AddFragment_is_stubbed()

        when_set_window_visibility_is_called()

        then_ZO_SimpleSceneFragment_New_was_called(WINDOW)
            and_SCENE_MANAGER_GetScene_was_called()
            and_SCENE_AddFragment_was_called()
    end)
end)
