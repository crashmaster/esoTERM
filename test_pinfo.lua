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

local function mock_function(scope, function_name, ...)
    local return_value = {...}
    local function_object = function(arg) return unpack(return_value) end
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

    setup(function()
        character_info = {}
        results = {}
    end)

    after_each(function()
        restore_fake_functions()
    end)

    teardown(function()
        character_info = nil
        results = nil
    end)

    -- {{{
    local function given_that_GetUnitName_returns(name)
        mock_function(GLOBAL, "GetUnitName", name)
    end

    local function and_cached_character_name_is_not_set()
        character_info.name = nil
    end

    local function when_get_character_name_is_called_with_character_info()
        results.name = pinfo.get_character_name(character_info)
    end

    local function then_the_returned_character_name_was(name)
        assert.is.equal(name, results.name)
    end

    local function and_GetUnitName_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitName).was.called_with("player")
    end

    local function and_the_cached_character_name_became(name)
        assert.is.equal(name, character_info.name)
    end
    -- }}}

    it("Query CHARACTER NAME from the SYSTEM, when not cached",
    function()
        given_that_GetUnitName_returns("Hank")
            and_cached_character_name_is_not_set()

        when_get_character_name_is_called_with_character_info()

        then_the_returned_character_name_was("Hank")
            and_GetUnitName_was_called_once_with_player()
            and_the_cached_character_name_became("Hank")
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        character_info.name = name
    end

    local function and_GetUnitName_returns(name)
        mock_function(GLOBAL, "GetUnitName", name)
    end

    local function and_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Query CHARACTER NAME from the CACHE",
    function()
        given_that_cached_character_name_is("Jeff")
            and_GetUnitName_returns("Hank")

        when_get_character_name_is_called_with_character_info()

        then_the_returned_character_name_was("Jeff")
            and_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_IsUnitVeteran_returns(veteranness)
        mock_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_cached_character_veteranness_is_not_set()
        character_info.veteran = nil
    end

    local function when_is_character_veteran_is_called_with_character_info()
        results.veteran = pinfo.is_character_veteran(character_info)
    end

    local function then_the_returned_character_veteranness_was(veteranness)
        assert.is.equal(veteranness, results.veteran)
    end

    local function and_IsUnitVeteran_was_called_once_with_player()
        assert.spy(GLOBAL.IsUnitVeteran).was.called_with("player")
    end

    local function and_the_cached_character_veteranness_became(veteranness)
        assert.is.equal(veteranness, character_info.veteran)
    end
    -- }}}

    it("Query CHARACTER VETERAN-NESS from the SYSTEM, when not cached",
    function()
        given_that_IsUnitVeteran_returns(true)
            and_cached_character_veteranness_is_not_set()

        when_is_character_veteran_is_called_with_character_info()

        then_the_returned_character_veteranness_was(true)
            and_IsUnitVeteran_was_called_once_with_player()
            and_the_cached_character_veteranness_became(true)
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is(veteranness)
        character_info.veteran = veteranness
    end

    local function and_IsUnitVeteran_returns(veteranness)
        mock_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_IsUnitVeteran_was_not_called()
        assert.spy(GLOBAL.IsUnitVeteran).was_not.called()
    end
    -- }}}

    it("Query CHARACTER VETERAN-NESS from the CACHE",
    function()
        given_that_cached_character_veteranness_is(false)
            and_IsUnitVeteran_returns(true)

        when_is_character_veteran_is_called_with_character_info()

        then_the_returned_character_veteranness_was(false)
            and_IsUnitVeteran_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitXP_returns(level_xp)
        mock_function(GLOBAL, "GetUnitXP", level_xp)
    end

    local function and_cached_character_level_xp_is_not_set()
        character_info.level_xp = nil
    end

    local function and_is_character_veteran_returns(veteranness)
        mock_function(pinfo, "is_character_veteran", veteranness)
    end

    local function when_get_character_level_xp_is_called_with_character_info()
        results.level_xp = pinfo.get_character_level_xp(character_info)
    end

    local function then_the_returned_level_xp_was(level_xp)
        assert.is.equal(level_xp, results.level_xp)
    end

    local function and_is_character_veteran_was_called_with_character_info()
        assert.spy(pinfo.is_character_veteran).was.called_with(character_info)
    end

    local function and_GetUnitXP_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXP).was.called_with("player")
    end

    local function and_the_cached_character_level_xp_became(level_xp)
        assert.is.equal(level_xp, character_info.level_xp)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the SYSTEM, when not cached",
    function()
        given_that_GetUnitXP_returns(1)
            and_cached_character_level_xp_is_not_set()
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(1)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitXP_was_called_once_with_player()
            and_the_cached_character_level_xp_became(1)
    end)

    -- {{{
    local function given_that_GetUnitVeteranPoints_returns(level_xp)
        mock_function(GLOBAL, "GetUnitVeteranPoints", level_xp)
    end

    local function and_GetUnitVeteranPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was.called_with("player")
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the SYSTEM, when not cached",
    function()
        given_that_GetUnitVeteranPoints_returns(1)
            and_cached_character_level_xp_is_not_set()
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(1)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitVeteranPoints_was_called_once_with_player()
            and_the_cached_character_level_xp_became(1)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is(level_xp)
        character_info.level_xp = level_xp
    end

    local function and_GetUnitXP_returns(level_xp)
        mock_function(GLOBAL, "GetUnitXP", level_xp)
    end

    local function and_is_character_veteran_was_not_called()
        assert.spy(pinfo.is_character_veteran).was_not.called()
    end

    local function and_GetUnitXP_was_not_called()
        assert.spy(GLOBAL.GetUnitXP).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_is(0)
            and_GetUnitXP_returns(1)
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(0)
            and_is_character_veteran_was_not_called()
            and_GetUnitXP_was_not_called()
    end)

    -- {{{
    local function and_GetUnitVeteranPoints_returns(level_xp)
        mock_function(GLOBAL, "GetUnitVeteranPoints", level_xp)
    end

    local function and_GetUnitVeteranPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_is(0)
            and_GetUnitVeteranPoints_returns(1)
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_is_called_with_character_info()

        then_the_returned_level_xp_was(0)
            and_is_character_veteran_was_not_called()
            and_GetUnitVeteranPoints_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitLevel_returns(level)
        mock_function(GLOBAL, "GetUnitLevel", level)
    end

    local function and_cached_character_level_is_not_set()
        character_info.level = nil
    end

    local function when_get_character_level_is_called_with_character_info()
        results.level = pinfo.get_character_level(character_info)
    end

    local function then_the_returned_level_was(level)
        assert.is.equal(level, results.level)
    end

    local function and_GetUnitLevel_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitLevel).was.called_with("player")
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL from the SYSTEM, when not cached",
    function()
        given_that_GetUnitLevel_returns(1)
            and_cached_character_level_is_not_set()
            and_is_character_veteran_returns(false)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(1)
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

    it("Query VETERAN CHARACTER LEVEL from the SYSTEM, when not cached",
    function()
        given_that_GetUnitVeteranRank_returns(1)
            and_cached_character_level_is_not_set()
            and_is_character_veteran_returns(true)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(1)
            and_GetUnitVeteranRank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_is(lvl)
        character_info.level = lvl
    end

    local function and_GetUnitLevel_returns(lvl)
        mock_function(GLOBAL, "GetUnitLevel", lvl)
    end

    local function and_GetUnitLevel_was_not_called()
        assert.spy(GLOBAL.GetUnitLevel).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL from the CACHE",
    function()
        given_that_cached_character_level_is(0)
            and_GetUnitLevel_returns(1)
            and_is_character_veteran_returns(false)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(0)
            and_is_character_veteran_was_not_called()
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

    it("Query VETERAN CHARACTER LEVEL from the CACHE",
    function()
        given_that_cached_character_level_is(0)
            and_GetUnitVeteranRank_returns(1)
            and_is_character_veteran_returns(true)

        when_get_character_level_is_called_with_character_info()

        then_the_returned_level_was(0)
            and_is_character_veteran_was_not_called()
            and_GetUnitVeteranRank_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitGender_returns(gender)
        mock_function(GLOBAL, "GetUnitGender", gender)
    end

    local function and_cached_character_gender_is_not_set()
        character_info.gender = nil
    end

    local function when_get_character_gender_is_called_with_character_info()
        results.gender = pinfo.get_character_gender(character_info)
    end

    local function then_the_returned_character_gender_was(gender)
        assert.is.equal(gender, results.gender)
    end

    local function and_GetUnitGender_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitGender).was.called_with("player")
    end

    local function and_the_cached_character_gender_became(gender)
        assert.is.equal(gender, character_info.gender)
    end
    -- }}}

    it("Query CHARACTER GENDER from the SYSTEM, when not cached",
    function()
        given_that_GetUnitGender_returns(1)
            and_cached_character_gender_is_not_set()

        when_get_character_gender_is_called_with_character_info()

        then_the_returned_character_gender_was(1)
            and_GetUnitGender_was_called_once_with_player()
            and_the_cached_character_gender_became(1)
    end)

    -- {{{
    local function given_that_cached_character_gender_is(gender)
        character_info.gender = gender
    end

    local function and_GetUnitGender_returns(gender)
        mock_function(GLOBAL, "GetUnitGender", gender)
    end

    local function and_GetUnitGender_was_not_called()
        assert.spy(GLOBAL.GetUnitGender).was_not.called()
    end
    -- }}}

    it("Query CHARACTER GENDER from the CACHE",
    function()
        given_that_cached_character_gender_is(0)
            and_GetUnitGender_returns(1)

        when_get_character_gender_is_called_with_character_info()

        then_the_returned_character_gender_was(0)
            and_GetUnitGender_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitAvARank_returns(rank, sub_rank)
        mock_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_cached_character_ava_rank_is_not_set()
        character_info.ava_rank = nil
        character_info.ava_sub_rank = nil
    end

    local function when_get_character_ava_rank_is_called_with_character_info()
        results.ava_rank, results.ava_sub_rank = pinfo.get_character_ava_rank(character_info)
    end

    local function then_the_returned_character_ava_rank_was(rank, sub_rank)
        assert.is.equal(rank, results.ava_rank)
        assert.is.equal(sub_rank, results.ava_sub_rank)
    end

    local function and_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with("player")
    end

    local function and_the_cached_character_ava_rank_became(rank, sub_rank)
        assert.is.equal(rank, character_info.ava_rank)
        assert.is.equal(sub_rank, character_info.ava_sub_rank)
    end
    -- }}}

    it("Query CHARACTER AvA RANK from the SYSTEM, when not cached",
    function()
        given_that_GetUnitAvARank_returns(1, 1)
            and_cached_character_ava_rank_is_not_set()

        when_get_character_ava_rank_is_called_with_character_info()

        then_the_returned_character_ava_rank_was(1, 1)
            and_GetUnitAvARank_was_called_once_with_player()
            and_the_cached_character_ava_rank_became(1, 1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is(rank, sub_rank)
        character_info.ava_rank = rank
        character_info.ava_sub_rank = sub_rank
    end

    local function and_GetUnitAvARank_returns(rank, sub_rank)
        mock_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA RANK from the CACHE",
    function()
        given_that_cached_character_ava_rank_is(0)
            and_GetUnitAvARank_returns(1, 1)

        when_get_character_ava_rank_is_called_with_character_info()

        then_the_returned_character_ava_rank_was(0)
            and_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_GetAvARankName_returns(name)
        mock_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_cached_character_ava_rank_name_is_not_set()
        character_info.ava_rank_name = nil
    end

    local function and_get_character_gender_returns(gender)
        mock_function(pinfo, "get_character_gender", gender)
    end

    local function and_get_character_ava_rank_returns(rank, sub_rank)
        mock_function(pinfo, "get_character_ava_rank", rank, sub_rank)
    end

    local function when_get_character_ava_rank_name_is_called_with_character_info()
        results.ava_rank_name = pinfo.get_character_ava_rank_name(character_info)
    end

    local function then_the_returned_character_ava_rank_name_was(rank, sub_rank)
        assert.is.equal(rank, results.ava_rank_name)
    end

    local function and_GetAvARankName_was_called_once_with(gender, rank)
        assert.spy(GLOBAL.GetAvARankName).was.called_with(gender, rank)
    end

    local function and_get_character_gender_was_called_once_with_character_info()
        assert.spy(pinfo.get_character_gender).was.called_with(character_info)
    end

    local function and_get_character_ava_rank_was_called_once_with_character_info()
        assert.spy(pinfo.get_character_ava_rank).was.called_with(character_info)
    end

    local function and_the_cached_character_ava_rank_name_became(name)
        assert.is.equal(name, character_info.ava_rank_name)
    end
    -- }}}

    it("Query CHARACHER AvA RANK-NAME from the SYSTEM, when not cached",
    function()
        given_that_GetAvARankName_returns("General")
            and_cached_character_ava_rank_name_is_not_set()
            and_get_character_gender_returns(0)
            and_get_character_ava_rank_returns(0, 0)

        when_get_character_ava_rank_name_is_called_with_character_info()

        then_the_returned_character_ava_rank_name_was("General")
            and_GetAvARankName_was_called_once_with(0, 0)
            and_get_character_gender_was_called_once_with_character_info()
            and_get_character_ava_rank_was_called_once_with_character_info()
            and_the_cached_character_ava_rank_name_became("General")
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is(name)
        character_info.ava_rank_name = name
    end

    local function and_GetAvARankName_returns(name)
        mock_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_GetAvARankName_was_not_called()
        assert.spy(GLOBAL.GetAvARankName).was_not.called()
    end

    local function and_get_character_gender_was_not_called()
        assert.spy(pinfo.get_character_gender).was_not.called()
    end

    local function and_get_character_ava_rank_was_not_called()
        assert.spy(pinfo.get_character_ava_rank).was_not.called()
    end
    -- }}}

    it("Query CHARACHER AvA RANK-NAME from the CACHE",
    function()
        given_that_cached_character_ava_rank_name_is("Novice")
            and_GetAvARankName_returns("General")
            and_get_character_gender_returns(0)
            and_get_character_ava_rank_returns(0, 0)

        when_get_character_ava_rank_name_is_called_with_character_info()

        then_the_returned_character_ava_rank_name_was("Novice")
            and_GetAvARankName_was_not_called()
            and_get_character_gender_was_not_called()
            and_get_character_ava_rank_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitClass_returns(class)
        mock_function(GLOBAL, "GetUnitClass", class)
    end

    local function and_cached_character_class_is_not_set()
        character_info.class = nil
    end

    local function when_get_character_class_is_called_with_character_info()
        results.class = pinfo.get_character_class(character_info)
    end

    local function then_the_returned_character_class_was(class)
        assert.is.equal(class, results.class)
    end

    local function and_GetUnitClass_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitClass).was.called_with("player")
    end

    local function and_the_cached_character_class_became(class)
        assert.is.equal(class, character_info.class)
    end
    -- }}}

    it("Query CHARACTER CLASS from the SYSTEM, when not cached",
    function()
        given_that_GetUnitClass_returns("Mage")
            and_cached_character_class_is_not_set()

        when_get_character_class_is_called_with_character_info()

        then_the_returned_character_class_was("Mage")
            and_GetUnitClass_was_called_once_with_player()
            and_the_cached_character_class_became("Mage")
    end)

    -- {{{
    local function given_that_cached_character_class_is(class)
        character_info.class = class
    end

    local function and_GetUnitClass_returns(class)
        mock_function(GLOBAL, "GetUnitClass", class)
    end

    local function and_GetUnitClass_was_not_called()
        assert.spy(GLOBAL.GetUnitClass).was_not.called()
    end
    -- }}}

    it("Query CHARACTER CLASS from the CACHE",
    function()
        given_that_cached_character_class_is("Warrior")
            and_GetUnitClass_returns("Mage")

        when_get_character_class_is_called_with_character_info()

        then_the_returned_character_class_was("Warrior")
            and_GetUnitClass_was_not_called()
    end)

    -- {{{
    local function given_that_GetUnitXPMax_returns(level_xp_max)
        mock_function(GLOBAL, "GetUnitXPMax", level_xp_max)
    end

    local function and_cached_character_level_xp_max_is_not_set()
        character_info.level_xp_max = nil
    end

    local function when_get_character_level_xp_max_is_called_with_character_info()
        results.level_xp_max = pinfo.get_character_level_xp_max(character_info)
    end

    local function then_the_returned_level_xp_max_was(level_xp_max)
        assert.is.equal(level_xp_max, results.level_xp_max)
    end

    local function and_is_character_veteran_was_called_with_character_info()
        assert.spy(pinfo.is_character_veteran).was.called_with(character_info)
    end

    local function and_GetUnitXPMax_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXPMax).was.called_with("player")
    end

    local function and_the_cached_character_level_xp_max_became(level_xp_max)
        assert.is.equal(level_xp_max, character_info.level_xp_max)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the SYSTEM, when not cached",
    function()
        given_that_GetUnitXPMax_returns(1)
            and_cached_character_level_xp_max_is_not_set()
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_max_is_called_with_character_info()

        then_the_returned_level_xp_max_was(1)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitXPMax_was_called_once_with_player()
            and_the_cached_character_level_xp_max_became(1)
    end)

    -- {{{
    local function given_that_GetUnitVeteranPointsMax_returns(level_xp_max)
        mock_function(GLOBAL, "GetUnitVeteranPointsMax", level_xp_max)
    end

    local function and_GetUnitVeteranPointsMax_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranPointsMax).was.called_with("player")
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the SYSTEM, when not cached",
    function()
        given_that_GetUnitVeteranPointsMax_returns(1)
            and_cached_character_level_xp_max_is_not_set()
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_max_is_called_with_character_info()

        then_the_returned_level_xp_max_was(1)
            and_is_character_veteran_was_called_with_character_info()
            and_GetUnitVeteranPointsMax_was_called_once_with_player()
            and_the_cached_character_level_xp_max_became(1)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is(level_xp_max)
        character_info.level_xp_max = level_xp_max
    end

    local function and_GetUnitXPMax_returns(level_xp_max)
        mock_function(GLOBAL, "GetUnitXPMax", level_xp_max)
    end

    local function and_GetUnitXPMax_was_not_called()
        assert.spy(GLOBAL.GetUnitXPMax).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_max_is(0)
            and_GetUnitXPMax_returns(1)
            and_is_character_veteran_returns(false)

        when_get_character_level_xp_max_is_called_with_character_info()

        then_the_returned_level_xp_max_was(0)
            and_is_character_veteran_was_not_called()
            and_GetUnitXPMax_was_not_called()
    end)

    -- {{{
    local function and_GetUnitVeteranPointsMax_returns(level_xp_max)
        mock_function(GLOBAL, "GetUnitVeteranPointsMax", level_xp_max)
    end

    local function and_GetUnitVeteranPointsMax_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPointsMax).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_max_is(0)
            and_GetUnitVeteranPointsMax_returns(1)
            and_is_character_veteran_returns(true)

        when_get_character_level_xp_max_is_called_with_character_info()

        then_the_returned_level_xp_max_was(0)
            and_is_character_veteran_was_not_called()
            and_GetUnitVeteranPointsMax_was_not_called()
    end)

    -- {{{
    local function given_that_get_character_level_xp_returns(level_xp)
        mock_function(pinfo, "get_character_level_xp", level_xp)
    end

    local function and_that_get_character_level_xp_max_returns(level_xp_max)
        mock_function(pinfo, "get_character_level_xp_max", level_xp_max)
    end

    local function when_get_character_level_xp_percent_is_called_with_character_info()
        results.level_xp_percent = pinfo.get_character_level_xp_percent(character_info)
    end

    local function then_the_returned_level_xp_percent_was(level_xp_percent)
        assert.is.equal(level_xp_percent, results.level_xp_percent)
    end

    local function and_get_character_level_xp_was_called_with_character_info()
        assert.spy(pinfo.get_character_level_xp).was.called_with(character_info)
    end

    local function and_get_character_level_xp_max_was_called_with_character_info()
        assert.spy(pinfo.get_character_level_xp_max).was.called_with(character_info)
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT",
    function()
        given_that_get_character_level_xp_returns(82)
            and_that_get_character_level_xp_max_returns(500)

        when_get_character_level_xp_percent_is_called_with_character_info()

        then_the_returned_level_xp_percent_was(16.4)
            and_get_character_level_xp_was_called_with_character_info()
            and_get_character_level_xp_max_was_called_with_character_info()
    end)
end)

-- vim:fdm=marker
