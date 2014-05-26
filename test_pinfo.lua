pinfo = require("pinfo")

local GLOBAL = _G
local ORIGINAL_FUNCTIONS = {}

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

local function recall_spy_from_function(scope, function_name)
    scope[function_name]:revert()
end

local function restore_fake_functions(fake_functions)
    for scope, function_name in pairs(fake_functions) do
        recall_spy_from_function(scope, function_name)
        restore_function(scope, function_name)
    end
end

describe("Test character information getters", function()
    local character_info = nil
    local results = nil
    local fake_functions = nil

    before_each(function()
        character_info = {}
        results = {}
        fake_functions = {}
    end)

    after_each(function()
        character_info = nil
        results = nil
        restore_fake_functions(fake_functions)
    end)

    -- {{{
    local function given_that_GetUnitName_returns(name)
        local function_name = "GetUnitName"
        local function_object = function(tag) return name end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function when_get_character_name_is_called()
        results["character_name"] = pinfo.get_character_name(character_info)
    end

    local function then_GetUnitName_was_called_once_with(parameter)
        assert.spy(GLOBAL.GetUnitName).was.called_with(parameter)
    end

    local function and_the_returned_character_name_was(name)
        assert.is.equal(name, results["character_name"])
    end

    local function and_the_cached_character_name_became(name)
        assert.is.equal(name, character_info["name"])
    end
    -- }}}

    it("Get name of the character, value not cached", function()
        given_that_GetUnitName_returns("foobar")
        when_get_character_name_is_called()
        then_GetUnitName_was_called_once_with("player")
        and_the_returned_character_name_was("foobar")
        and_the_cached_character_name_became("foobar")
    end)

    -- {{{
    local function and_cached_character_name_is(name)
        character_info["name"] = name
    end

    local function then_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Get name of the character, value cached", function()
        given_that_GetUnitName_returns("foobar")
        and_cached_character_name_is("John")
        when_get_character_name_is_called()
        then_GetUnitName_was_not_called()
        and_the_returned_character_name_was("John")
    end)

    -- {{{
    local function given_that_IsUnitVeteran_returns(veteranness)
        local function_name = "IsUnitVeteran"
        local function_object = function(tag) return veteranness end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function when_is_character_veteran_is_called()
        results["veteranness"] = pinfo.is_character_veteran(character_info)
    end

    local function then_IsUnitVeteran_was_called_once_with(parameter)
        assert.spy(GLOBAL.IsUnitVeteran).was.called_with(parameter)
    end

    local function and_the_returned_character_veteranness_was(veteranness)
        assert.is.equal(veteranness, results["veteranness"])
    end

    local function and_the_cached_character_veteranness_became(veteranness)
        assert.is.equal(veteranness, character_info["veteran"])
    end
    -- }}}

    it("Get veteran-ness of the character, value not cached", function()
        given_that_IsUnitVeteran_returns(false)
        when_is_character_veteran_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_the_returned_character_veteranness_was(false)
        and_the_cached_character_veteranness_became(false)
    end)

    -- {{{
    local function and_cached_character_veteranness_is(veteranness)
        character_info["veteran"] = false
    end

    local function then_IsUnitVeteran_was_not_called()
        assert.spy(GLOBAL.IsUnitVeteran).was_not.called()
    end
    -- }}}

    it("Get veteran-ness of the character, value cached", function()
        given_that_IsUnitVeteran_returns(false)
        and_cached_character_veteranness_is(false)
        when_is_character_veteran_is_called()
        then_IsUnitVeteran_was_not_called()
        and_the_returned_character_veteranness_was(false)
    end)

    -- {{{
    local function and_GetUnitXP_returns(level_xp)
        local function_name = "GetUnitXP"
        local function_object = function(tag) return level_xp end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function when_get_character_level_xp_is_called()
        results["level_xp"] = pinfo.get_character_level_xp(character_info)
    end

    local function then_is_character_veteran_was_called_once_with(parameter)
        assert.spy(pinfo.is_character_veteran).was.called_with(parameter)
    end

    local function and_GetUnitXP_was_called_once_with(parameter)
        assert.spy(GLOBAL.GetUnitXP).was.called_with(parameter)
    end

    local function and_the_returned_level_xp_was(level_xp)
        assert.is.equal(level_xp, results["level_xp"])
    end

    local function and_the_cached_character_level_xp_became(xp)
        assert.is.equal(xp, character_info["level_xp"])
    end
    -- }}}

    it("Get level XP for non-veteran character, value not cached", function()
        given_that_IsUnitVeteran_returns(false)
        and_GetUnitXP_returns(123)
        when_get_character_level_xp_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_GetUnitXP_was_called_once_with("player")
        and_the_returned_level_xp_was(123)
        and_the_cached_character_level_xp_became(123)
    end)

    -- {{{
    local function and_GetUnitVeteranPoints_returns(level_xp)
        local function_name = "GetUnitVeteranPoints"
        local function_object = function(tag) return level_xp end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function and_GetUnitVeteranPoints_was_called_once_with(parameter)
        assert.spy(GLOBAL.GetUnitVeteranPoints).was.called_with(parameter)
    end
    -- }}}

    it("Get level XP for veteran character, value not cached", function()
        given_that_IsUnitVeteran_returns(true)
        and_GetUnitVeteranPoints_returns(321)
        when_get_character_level_xp_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_GetUnitVeteranPoints_was_called_once_with("player")
        and_the_returned_level_xp_was(321)
    end)

    -- {{{
    local function and_cached_character_level_xp_is(xp)
        character_info["level_xp"] = xp
    end

    local function then_is_character_veteran_was_not_called()
        assert.spy(pinfo.is_character_veteran).was_not.called()
    end

    local function and_GetUnitXP_was_not_called()
        assert.spy(GLOBAL.GetUnitXP).was_not.called()
    end
    -- }}}

    it("Get level XP for non-veteran character, value cached", function()
        given_that_IsUnitVeteran_returns(false)
        and_GetUnitXP_returns(2222)
        and_cached_character_level_xp_is(1111)
        when_get_character_level_xp_is_called()
        then_IsUnitVeteran_was_not_called()
        and_GetUnitXP_was_not_called()
        and_the_returned_level_xp_was(1111)
    end)

    -- {{{
    local function and_GetUnitVeteranPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was_not.called()
    end
    -- }}}

    it("Get level XP for veteran character, value cached", function()
        given_that_IsUnitVeteran_returns(true)
        and_GetUnitVeteranPoints_returns(2222)
        and_cached_character_level_xp_is(1111)
        when_get_character_level_xp_is_called()
        then_IsUnitVeteran_was_not_called()
        and_GetUnitVeteranPoints_was_not_called()
        and_the_returned_level_xp_was(1111)
    end)

    it("Get level XP for any character, reissue IsUnitVeteran", function()
        given_that_IsUnitVeteran_returns(false)
        and_GetUnitXP_returns(123)
        and_cached_character_veteranness_is(false)
        when_get_character_level_xp_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_GetUnitXP_was_called_once_with("player")
        and_the_cached_character_veteranness_became(false)
        and_the_returned_level_xp_was(123)
        and_the_cached_character_level_xp_became(123)
    end)

    -- {{{
    local function and_GetUnitLevel_returns(level)
        local function_name = "GetUnitLevel"
        local function_object = function(tag) return level end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function when_get_character_level_is_called()
        results["level"] = pinfo.get_character_level(character_info)
    end

    local function and_GetUnitLevel_was_called_once_with(parameter)
        assert.spy(GLOBAL.GetUnitLevel).was.called_with(parameter)
    end

    local function and_the_returned_level_was(level)
        assert.is.equal(level, results["level"])
    end
    -- }}}

    it("Get level of non-veteran character, value not cached", function()
        given_that_IsUnitVeteran_returns(false)
        and_GetUnitLevel_returns(19)
        when_get_character_level_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_GetUnitLevel_was_called_once_with("player")
        and_the_returned_level_was(19)
    end)

    -- {{{
    local function and_GetUnitVeteranRank_returns(level)
        local function_name = "GetUnitVeteranRank"
        local function_object = function(tag) return level end
        update_function(GLOBAL, function_name, function_object)
        engage_spy_on_function(GLOBAL, function_name)
        fake_functions[GLOBAL] = function_name
    end

    local function and_GetUnitVeteranRank_was_called_once_with(parameter)
        assert.spy(GLOBAL.GetUnitVeteranRank).was.called_with(parameter)
    end
    -- }}}

    it("Get level of veteran character, value not cached", function()
        given_that_IsUnitVeteran_returns(true)
        and_GetUnitVeteranRank_returns(2)
        when_get_character_level_is_called()
        then_IsUnitVeteran_was_called_once_with("player")
        and_GetUnitVeteranRank_was_called_once_with("player")
        and_the_returned_level_was(2)
    end)
end)

-- vim:fdm=marker
