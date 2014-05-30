pinfo = require("pinfo")

local GLOBAL = _G
local ORIGINAL_FUNCTIONS = {}
local MOCKED_FUNCTIONS = {}

local function update_function(scope, function_name, function_object)
    ORIGINAL_FUNCTIONS[function_name] = scope[function_name]
    scope[function_name] = function_object
end

local function restore_function(scope, function_name)
    scope[function_name] = ORIGINAL_FUNCTIONS[function_name]
end

local function engage_spy_on_function(scope, function_name)
    spy.on(scope, function_name)
end

local function mock_function(scope, function_name, return_value)
    local function_object = function(arg) return return_value end
    update_function(scope, function_name, function_object)
    engage_spy_on_function(scope, function_name)
    MOCKED_FUNCTIONS[scope] = function_name
end

local function recall_spy_from_function(scope, function_name)
    scope[function_name]:revert()
end

local function restore_fake_functions()
    for scope, function_name in pairs(MOCKED_FUNCTIONS) do
        recall_spy_from_function(scope, function_name)
        restore_function(scope, function_name)
    end
    MOCKED_FUNCTIONS = {}
end

describe("Test character information getters", function()
    local character_info = nil
    local results = nil

    local char_name_s = "John"
    local char_name_c = "Jeff"
    local char_vet_s = false
    local char_vet_c = true
    local char_lvl_xp_s = 1
    local char_lvl_xp_c = 2
    local char_lvl_s = 1
    local char_lvl_c = 2

    before_each(function()
        character_info = {}
        results = {}
    end)

    after_each(function()
        character_info = nil
        results = nil
        restore_fake_functions()
    end)

    -- {{{
    local function given_that_GetUnitName_returns(name)
        mock_function(GLOBAL, "GetUnitName", name)
    end

    local function and_cached_character_name_is_not_set()
        character_info["name"] = nil
    end

    local function when_get_character_name_is_called_with_character_info()
        results["character_name"] = pinfo.get_character_name(character_info)
    end

    local function then_the_returned_character_name_was(name)
        assert.is.equal(name, results["character_name"])
    end

    local function and_GetUnitName_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitName).was.called_with("player")
    end

    local function and_the_cached_character_name_became(name)
        assert.is.equal(name, character_info["name"])
    end
    -- }}}

    it("Query NAME of the character from the system, when not cached",
    function()
        given_that_GetUnitName_returns(char_name_s)
            and_cached_character_name_is_not_set()

        when_get_character_name_is_called_with_character_info()

        then_the_returned_character_name_was(char_name_s)
            and_GetUnitName_was_called_once_with_player()
            and_the_cached_character_name_became(char_name_s)
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        character_info["name"] = name
    end

    local function and_GetUnitName_returns(name)
        mock_function(GLOBAL, "GetUnitName", name)
    end

    local function and_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Query NAME of the character from the cache",
    function()
        given_that_cached_character_name_is(char_name_c)
            and_GetUnitName_returns(char_name_s)

        when_get_character_name_is_called_with_character_info()

        then_the_returned_character_name_was(char_name_c)
            and_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_IsUnitVeteran_returns(veteranness)
        mock_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_cached_character_veteranness_is_not_set()
        character_info["veteran"] = nil
    end

    local function when_is_character_veteran_is_called_with_character_info()
        results["veteranness"] = pinfo.is_character_veteran(character_info)
    end

    local function then_the_returned_character_veteranness_was(veteranness)
        assert.is.equal(veteranness, results["veteranness"])
    end

    local function and_IsUnitVeteran_was_called_once_with_player()
        assert.spy(GLOBAL.IsUnitVeteran).was.called_with("player")
    end

    local function and_the_cached_character_veteranness_became(veteranness)
        assert.is.equal(veteranness, character_info["veteran"])
    end
    -- }}}

    it("Query VETERAN-NESS of the character from the system, when not cached",
    function()
        given_that_IsUnitVeteran_returns(char_vet_s)
            and_cached_character_veteranness_is_not_set()

        when_is_character_veteran_is_called_with_character_info()

        then_the_returned_character_veteranness_was(char_vet_s)
            and_IsUnitVeteran_was_called_once_with_player()
            and_the_cached_character_veteranness_became(char_vet_s)
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is(veteranness)
        character_info["veteran"] = veteranness
    end

    local function and_IsUnitVeteran_returns(veteranness)
        mock_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_IsUnitVeteran_was_not_called()
        assert.spy(GLOBAL.IsUnitVeteran).was_not.called()
    end
    -- }}}

    it("Query VETERAN-NESS of the character from the cache",
    function()
        given_that_cached_character_veteranness_is(char_vet_c)
            and_IsUnitVeteran_returns(char_vet_s)

        when_is_character_veteran_is_called_with_character_info()

        then_the_returned_character_veteranness_was(char_vet_c)
            and_IsUnitVeteran_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitXP_returns(level_xp)
        mock_function(GLOBAL, "GetUnitXP", level_xp)
    end

    local function and_is_character_veteran_returns(veteranness)
        mock_function(pinfo, "is_character_veteran", veteranness)
    end

    local function when_get_character_level_xp_is_called_with_character_info()
        results["level_xp"] = pinfo.get_character_level_xp(character_info)
    end

    local function then_the_returned_level_xp_was(level_xp)
        assert.is.equal(level_xp, results["level_xp"])
    end

    local function and_is_character_veteran_was_called_with_character_info()
        assert.spy(pinfo.is_character_veteran).was.called_with(character_info)
    end

    local function and_GetUnitXP_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXP).was.called_with("player")
    end

    local function and_the_cached_character_level_xp_became(xp)
        assert.is.equal(xp, character_info["level_xp"])
    end
    -- }}}

    it("Query LEVEL-XP of the non-veteran character from the system, when not cached",
    function()
        given_that_GetUnitXP_returns(char_lvl_xp_s)
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(char_lvl_xp_s)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitXP_was_called_once_with_player()
            and_the_cached_character_level_xp_became(char_lvl_xp_s)
    end)

    -- {{{
    local function given_that_GetUnitVeteranPoints_returns(level_xp)
        mock_function(GLOBAL, "GetUnitVeteranPoints", level_xp)
    end

    local function and_GetUnitVeteranPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was.called_with("player")
    end
    -- }}}

    it("Query LEVEL-XP of the veteran character from the system, when not cached",
    function()
        given_that_GetUnitVeteranPoints_returns(char_lvl_xp_s)
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(char_lvl_xp_s)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitVeteranPoints_was_called_once_with_player()
            and_the_cached_character_level_xp_became(char_lvl_xp_s)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is(xp)
        character_info["level_xp"] = xp
    end

    local function and_GetUnitXP_returns(xp)
        mock_function(GLOBAL, "GetUnitXP", xp)
    end

    local function and_GetUnitXP_was_not_called()
        assert.spy(GLOBAL.GetUnitXP).was_not.called()
    end
    -- }}}

    it("Query LEVEL-XP of the non-veteran character from the cache",
    function()
        given_that_cached_character_level_xp_is(char_lvl_xp_c)
            and_GetUnitXP_returns(char_lvl_xp_s)
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(char_lvl_xp_c)
            and_GetUnitXP_was_not_called()
    end)

    -- {{{
    local function and_GetUnitVeteranPoints_returns()
        mock_function(GLOBAL, "GetUnitVeteranPoints", xp)
    end

    local function and_GetUnitVeteranPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was_not.called()
    end
    -- }}}

    it("Query LEVEL-XP of the veteran character from the cache",
    function()
        given_that_cached_character_level_xp_is(char_lvl_xp_c)
            and_GetUnitVeteranPoints_returns(char_lvl_xp_s)
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(char_lvl_xp_c)
            and_GetUnitVeteranPoints_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitLevel_returns(level)
        mock_function(GLOBAL, "GetUnitLevel", level)
    end

    local function when_get_character_level_is_called_with_character_info()
        results["level"] = pinfo.get_character_level(character_info)
    end

    local function then_the_returned_level_was(level)
        assert.is.equal(level, results["level"])
    end

    local function and_GetUnitLevel_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitLevel).was.called_with("player")
    end
    -- }}}

    it("Query LEVEL of the non-veteran character from the system, when not cached",
    function()
        given_that_GetUnitLevel_returns(char_lvl_s)
            and_is_character_veteran_returns(false)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(char_lvl_s)
            and_GetUnitLevel_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_GetUnitVeteranRank_returns(level)
        mock_function(GLOBAL, "GetUnitVeteranRank", level)
    end

    local function and_GetUnitVeteranRank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranRank).was.called_with("player")
    end
    -- }}}

    it("Query LEVEL of the veteran character from the system, when not cached",
    function()
        given_that_GetUnitVeteranRank_returns(char_lvl_s)
            and_is_character_veteran_returns(true)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(char_lvl_s)
            and_GetUnitVeteranRank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_is(lvl)
        character_info["level"] = lvl
    end

    local function and_GetUnitLevel_returns(lvl)
        mock_function(GLOBAL, "GetUnitLevel", lvl)
    end

    local function and_GetUnitLevel_was_not_called()
        assert.spy(GLOBAL.GetUnitLevel).was_not.called()
    end
    -- }}}

    it("Query LEVEL of the non-veteran character from the cache",
    function()
        given_that_cached_character_level_is(char_lvl_c)
            and_GetUnitLevel_returns(char_lvl_s)
            and_is_character_veteran_returns(false)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(char_lvl_c)
            and_GetUnitLevel_was_not_called()
    end)

    -- {{{
    local function and_GetUnitVeteranRank_returns(lvl)
        mock_function(GLOBAL, "GetUnitVeteranRank", lvl)
    end

    local function and_GetUnitVeteranRank_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranRank).was_not.called()
    end
    -- }}}

    it("Query LEVEL of the veteran character from the cache",
    function()
        given_that_cached_character_level_is(char_lvl_c)
            and_GetUnitVeteranRank_returns(char_lvl_s)
            and_is_character_veteran_returns(true)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(char_lvl_c)
            and_GetUnitVeteranRank_was_not_called()
    end)
end)

-- vim:fdm=marker
