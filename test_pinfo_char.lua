local ut_helper = require("ut_helper")
local requires_for_tests = require("requires_for_tests")

local GLOBAL = _G

local PLAYER = "player"

local A_BOOL = true
local B_BOOL = false
local A_INTEGER = 1111
local B_INTEGER = 2222
local A_STRING = "aAaAa"
local B_STRING = "bBbBb"

local VETERANNESS_1 = A_BOOL
local VETERANNESS_2 = B_VALUE
local GENDER_1 = A_STRING
local GENDER_2 = B_STRING
local CLASS_1 = A_STRING
local CLASS_2 = B_STRING
local NAME_1 = A_STRING
local NAME_2 = B_STRING
local LEVEL_1 = A_INTEGER
local LEVEL_2 = B_INTEGER
local LEVEL_XP_1 = A_INTEGER
local LEVEL_XP_2 = B_INTEGER
local LEVEL_XP_MAX_1 = A_INTEGER
local LEVEL_XP_MAX_2 = B_INTEGER
local LEVEL_XP_PERCENT = A_INTEGER
local LEVEL_XP_GAIN = A_INTEGER
local AVA_POINTS_1 = A_INTEGER
local AVA_POINTS_2 = B_INTEGER
local AVA_RANK_1 = A_INTEGER
local AVA_RANK_2 = B_INTEGER
local AVA_SUB_RANK_1 = A_INTEGER
local AVA_SUB_RANK_2 = B_INTEGER
local AVA_RANK_NAME_1 = A_INTEGER
local AVA_RANK_NAME_2 = B_INTEGER
local AVA_RANK_POINTS_1 = A_INTEGER
local AVA_RANK_POINTS_2 = B_INTEGER
local AVA_RANK_POINTS_MAX_1 = A_INTEGER
local AVA_RANK_POINTS_MAX_2 = B_INTEGER
local AVA_RANK_POINTS_LB_1 = A_INTEGER
local AVA_RANK_POINTS_LB_2 = B_INTEGER
local AVA_RANK_POINTS_UB_1 = A_INTEGER
local AVA_RANK_POINTS_UB_2 = B_INTEGER
local AVA_RANK_POINTS_PERCENT = A_INTEGER
local AVA_POINTS_GAIN = A_INTEGER


describe("Test character information getters", function()
    local results = {}
    local cache = pinfo.CACHE
    local return_values_of_the_getter_stubs = {
        is_character_veteran = VETERANNESS_1,
        get_character_gender = GENDER_1,
        get_character_class = CLASS_1,
        get_character_name = NAME_1,
        get_character_level = LEVEL_1,
        get_character_level_xp = LEVEL_XP_1,
        get_character_level_xp_max = LEVEL_XP_MAX_1,
        get_character_level_xp_percent = LEVEL_XP_PERCENT,
        get_character_xp_gain = LEVEL_XP_GAIN,
        get_character_ava_points = AVA_RANK_1,
        get_character_ava_rank = AVA_RANK_1,
        get_character_ava_sub_rank = AVA_SUB_RANK_1,
        get_character_ava_rank_name = AVA_RANK_NAME_1,
        get_character_ava_rank_points_lb = AVA_RANK_POINTS_LB_1,
        get_character_ava_rank_points_ub = AVA_RANK_POINTS_UB_1,
        get_character_ava_rank_points = AVA_RANK_POINTS_1,
        get_character_ava_rank_points_max = AVA_RANK_POINTS_MAX_1,
        get_character_ava_rank_points_percent = AVA_RANK_POINTS_PERCENT,
        get_character_ava_points_gain = AVA_POINTS_GAIN
    }
    local expected_cached_values = {
        veteran = VETERANNESS_1,
        gender = GENDER_1,
        class = CLASS_1,
        name = NAME_1,
        level = LEVEL_1,
        level_xp = LEVEL_XP_1,
        level_xp_max = LEVEL_XP_MAX_1,
        level_xp_percent = LEVEL_XP_PERCENT,
        xp_gain = LEVEL_XP_GAIN,
        ava_points = AVA_POINTS_1,
        ava_rank = AVA_RANK_1,
        ava_sub_rank = AVA_SUB_RANK_1,
        ava_rank_name = AVA_RANK_NAME_1,
        ava_rank_points_lb = AVA_RANK_POINTS_LB_1,
        ava_rank_points_ub = AVA_RANK_POINTS_UB_1,
        ava_rank_points = AVA_RANK_POINTS_1,
        ava_rank_points_max = AVA_RANK_POINTS_MAX_1,
        ava_rank_points_percent = AVA_RANK_POINTS_PERCENT,
        ava_points_gain = AVA_POINTS_GAIN
    }

    local function setup_getter_stubs()
        for getter, return_value in pairs(return_values_of_the_getter_stubs) do
            ut_helper.stub_function(pinfo_char, getter, return_value)
        end
    end

    setup(function()
        setup_getter_stubs()
    end)

    teardown(function()
        results = nil
        ut_helper.restore_stubbed_functions()
    end)

    -- {{{
    local function given_that_cache_is_empty()
        assert.is.equal(0, ut_helper.table_size(cache))
    end

    local function when_initialize_is_called_with_cache()
        pinfo_char.initialize()
    end

    local function then_cache_is_no_longer_empty()
        assert.is_not.equal(0, ut_helper.table_size(cache))
    end

    local function and_cached_values_became_initialized()
        for cache_attribute, expected_value in pairs(expected_cached_values) do
            assert.is.equal(expected_value, cache[cache_attribute])
        end
    end

    local function and_getter_stubs_were_called_with(param)
        for getter, _ in pairs(return_values_of_the_getter_stubs) do
            assert.spy(pinfo_char[getter]).was.called_with(param)
        end
    end
    -- }}}

    it("Cached character info is updated",
    function()
        given_that_cache_is_empty()

        when_initialize_is_called_with_cache()

        then_cache_is_no_longer_empty()
            and_cached_values_became_initialized()
            and_getter_stubs_were_called_with(cache)
    end)
end)

describe("Test character information getters", function()
    local results = {}
    local cache = pinfo.CACHE

    after_each(function()
        ut_helper.restore_stubbed_functions()
    end)

    teardown(function()
        results = nil
    end)

    -- {{{
    local function given_that_cached_character_name_is_not_set()
        cache.name = nil
    end

    local function and_that_eso_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function when_get_character_name_is_called_with_cache()
        results.name = pinfo_char.get_character_name(cache)
    end

    local function then_the_returned_character_name_was(name)
        assert.is.equal(name, results.name)
    end

    local function and_eso_GetUnitName_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitName).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER NAME from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_name_is_not_set()
            and_that_eso_GetUnitName_returns(NAME_1)

        when_get_character_name_is_called_with_cache()

        then_the_returned_character_name_was(NAME_1)
            and_eso_GetUnitName_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_name_is(name)
        cache.name = name
    end

    local function and_that_eso_GetUnitName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetUnitName", name)
    end

    local function and_eso_GetUnitName_was_not_called()
        assert.spy(GLOBAL.GetUnitName).was_not.called()
    end
    -- }}}

    it("Query CHARACTER NAME from the CACHE",
    function()
        given_that_cached_character_name_is(NAME_1)
            and_that_eso_GetUnitName_returns(NAME_2)

        when_get_character_name_is_called_with_cache()

        then_the_returned_character_name_was(NAME_1)
            and_eso_GetUnitName_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is_not_set()
        cache.veteran = nil
    end

    local function and_that_IsUnitVeteran_returns(veteranness)
        ut_helper.stub_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function when_is_character_veteran_is_called_with_cache()
        results.veteran = pinfo_char.is_character_veteran(cache)
    end

    local function then_the_returned_character_veteranness_was(veteranness)
        assert.is.equal(veteranness, results.veteran)
    end

    local function and_IsUnitVeteran_was_called_once_with_player()
        assert.spy(GLOBAL.IsUnitVeteran).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER VETERAN-NESS from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_veteranness_is_not_set()
            and_that_IsUnitVeteran_returns(VETERANNESS_1)

        when_is_character_veteran_is_called_with_cache()

        then_the_returned_character_veteranness_was(VETERANNESS_1)
            and_IsUnitVeteran_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_veteranness_is(veteranness)
        cache.veteran = veteranness
    end

    local function and_that_IsUnitVeteran_returns(veteranness)
        ut_helper.stub_function(GLOBAL, "IsUnitVeteran", veteranness)
    end

    local function and_IsUnitVeteran_was_not_called()
        assert.spy(GLOBAL.IsUnitVeteran).was_not.called()
    end
    -- }}}

    it("Query CHARACTER VETERAN-NESS from the CACHE",
    function()
        given_that_cached_character_veteranness_is(VETERANNESS_1)
            and_that_IsUnitVeteran_returns(VETERANNESS_2)

        when_is_character_veteran_is_called_with_cache()

        then_the_returned_character_veteranness_was(VETERANNESS_1)
            and_IsUnitVeteran_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is_not_set()
        cache.level_xp = nil
    end

    local function and_that_eso_GetUnitXP_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXP", xp)
    end

    local function and_character_is_not_veteran()
        ut_helper.stub_function(pinfo_char, "is_character_veteran", false)
    end

    local function when_get_character_level_xp_is_called_with_cache()
        results.level_xp = pinfo_char.get_character_level_xp(cache)
    end

    local function then_the_returned_level_xp_was(xp)
        assert.is.equal(xp, results.level_xp)
    end

    local function and_is_character_veteran_was_called_with_cache()
        assert.spy(pinfo_char.is_character_veteran).was.called_with(cache)
    end

    local function and_eso_GetUnitXP_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXP).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_is_not_set()
            and_that_eso_GetUnitXP_returns(LEVEL_XP_1)
            and_character_is_not_veteran()

        when_get_character_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_is_character_veteran_was_called_with_cache()
            and_eso_GetUnitXP_was_called_once_with_player()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranPoints_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranPoints", xp)
    end

    local function and_character_is_veteran()
        ut_helper.stub_function(pinfo_char, "is_character_veteran", true)
    end

    local function and_eso_GetUnitVeteranPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was.called_with(PLAYER)
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_is_not_set()
            and_that_eso_GetUnitVeteranPoints_returns(LEVEL_XP_1)
            and_character_is_veteran()

        when_get_character_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_is_character_veteran_was_called_with_cache()
            and_eso_GetUnitVeteranPoints_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_is(xp)
        cache.level_xp = xp
    end

    local function and_that_eso_GetUnitXP_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXP", xp)
    end

    local function and_is_character_veteran_was_not_called()
        assert.spy(pinfo_char.is_character_veteran).was_not.called()
    end

    local function and_eso_GetUnitXP_was_not_called()
        assert.spy(GLOBAL.GetUnitXP).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_is(LEVEL_XP_1)
            and_that_eso_GetUnitXP_returns(LEVEL_XP_2)
            and_character_is_not_veteran()

        when_get_character_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitXP_was_not_called()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranPoints_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranPoints", xp)
    end

    local function and_eso_GetUnitVeteranPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPoints).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP from the CACHE",
    function()
        given_that_cached_character_level_xp_is(LEVEL_XP_1)
            and_that_eso_GetUnitVeteranPoints_returns(LEVEL_XP_2)
            and_character_is_veteran()

        when_get_character_level_xp_is_called_with_cache()

        then_the_returned_level_xp_was(LEVEL_XP_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitVeteranPoints_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_is_not_set()
        cache.level = nil
    end

    local function and_that_eso_GetUnitLevel_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitLevel", level)
    end

    local function when_get_character_level_is_called_with_cache()
        results.level = pinfo_char.get_character_level(cache)
    end

    local function then_the_returned_level_was(level)
        assert.is.equal(level, results.level)
    end

    local function and_eso_GetUnitLevel_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitLevel).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_is_not_set()
            and_that_eso_GetUnitLevel_returns(LEVEL_1)
            and_character_is_not_veteran()

        when_get_character_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_eso_GetUnitLevel_was_called_once_with_player()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranRank_returns(level)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranRank", level)
    end

    local function and_eso_GetUnitVeteranRank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranRank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_is_not_set()
            and_that_eso_GetUnitVeteranRank_returns(LEVEL_1)
            and_character_is_veteran()

        when_get_character_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_eso_GetUnitVeteranRank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_is(lvl)
        cache.level = lvl
    end

    local function and_that_eso_GetUnitLevel_returns(lvl)
        ut_helper.stub_function(GLOBAL, "GetUnitLevel", lvl)
    end

    local function and_eso_GetUnitLevel_was_not_called()
        assert.spy(GLOBAL.GetUnitLevel).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL from the CACHE",
    function()
        given_that_cached_character_level_is(LEVEL_1)
            and_that_eso_GetUnitLevel_returns(LEVEL_2)
            and_character_is_not_veteran()

        when_get_character_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitLevel_was_not_called()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranRank_returns(lvl)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranRank", lvl)
    end

    local function and_eso_GetUnitVeteranRank_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranRank).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL from the CACHE",
    function()
        given_that_cached_character_level_is(LEVEL_1)
            and_that_eso_GetUnitVeteranRank_returns(LEVEL_2)
            and_character_is_veteran()

        when_get_character_level_is_called_with_cache()

        then_the_returned_level_was(LEVEL_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitVeteranRank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_gender_is_not_set()
        cache.gender = nil
    end

    local function and_that_eso_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function when_get_character_gender_is_called_with_cache()
        results.gender = pinfo_char.get_character_gender(cache)
    end

    local function then_the_returned_character_gender_was(gender)
        assert.is.equal(gender, results.gender)
    end

    local function and_eso_GetUnitGender_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitGender).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER GENDER from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_gender_is_not_set()
            and_that_eso_GetUnitGender_returns(GENDER_1)

        when_get_character_gender_is_called_with_cache()

        then_the_returned_character_gender_was(GENDER_1)
            and_eso_GetUnitGender_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_gender_is(gender)
        cache.gender = gender
    end

    local function and_that_eso_GetUnitGender_returns(gender)
        ut_helper.stub_function(GLOBAL, "GetUnitGender", gender)
    end

    local function and_eso_GetUnitGender_was_not_called()
        assert.spy(GLOBAL.GetUnitGender).was_not.called()
    end
    -- }}}

    it("Query CHARACTER GENDER from the CACHE",
    function()
        given_that_cached_character_gender_is(GENDER_1)
            and_that_eso_GetUnitGender_returns(GENDER_2)

        when_get_character_gender_is_called_with_cache()

        then_the_returned_character_gender_was(GENDER_1)
            and_eso_GetUnitGender_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_is_not_set()
        cache.ava_points = nil
    end

    local function and_that_eso_GetUnitAvARankPoints_returns(points)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARankPoints", points)
    end

    local function when_get_character_ava_points_is_called_with_cache()
        results.ava_points = pinfo_char.get_character_ava_points(cache)
    end

    local function then_the_returned_character_ava_points_was(points)
        assert.is.equal(points, results.ava_points)
    end

    local function and_eso_GetUnitAvARankPoints_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA POINTS from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_points_is_not_set()
            and_that_eso_GetUnitAvARankPoints_returns(AVA_POINTS_1)

        when_get_character_ava_points_is_called_with_cache()

        then_the_returned_character_ava_points_was(AVA_POINTS_1)
            and_eso_GetUnitAvARankPoints_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_is(points)
        cache.ava_points = points
    end

    local function and_eso_GetUnitAvARankPoints_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARankPoints).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA POINTS from the CACHE",
    function()
        given_that_cached_character_ava_points_is(AVA_POINTS_1)
            and_that_eso_GetUnitAvARankPoints_returns(AVA_POINTS_2)

        when_get_character_ava_points_is_called_with_cache()

        then_the_returned_character_ava_points_was(AVA_POINTS_1)
            and_eso_GetUnitAvARankPoints_was_not_called()
    end)



    -- {{{
    local function given_that_cached_character_ava_rank_is_not_set()
        cache.ava_rank = nil
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_character_ava_rank_is_called_with_cache()
        results.ava_rank = pinfo_char.get_character_ava_rank(cache)
    end

    local function then_the_returned_character_ava_rank_was(rank)
        assert.is.equal(rank, results.ava_rank)
    end

    local function and_eso_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA RANK from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_is_not_set()
            and_that_eso_GetUnitAvARank_returns(AVA_RANK_1, AVA_SUB_RANK_1)

        when_get_character_ava_rank_is_called_with_cache()

        then_the_returned_character_ava_rank_was(AVA_RANK_1)
            and_eso_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_is(rank)
        cache.ava_rank = rank
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA RANK from the CACHE",
    function()
        given_that_cached_character_ava_rank_is(AVA_RANK_1)
            and_that_eso_GetUnitAvARank_returns(AVA_RANK_2, AVA_SUB_RANK_2)

        when_get_character_ava_rank_is_called_with_cache()

        then_the_returned_character_ava_rank_was(AVA_RANK_1)
            and_eso_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is_not_set()
        cache.ava_sub_rank = nil
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function when_get_character_ava_sub_rank_is_called_with_cache()
        results.ava_sub_rank = pinfo_char.get_character_ava_sub_rank(cache)
    end

    local function then_the_returned_character_ava_sub_rank_was(sub_rank)
        assert.is.equal(sub_rank, results.ava_sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitAvARank).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER AvA SUB-RANK from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_sub_rank_is_not_set()
            and_that_eso_GetUnitAvARank_returns(AVA_RANK_1, AVA_SUB_RANK_1)

        when_get_character_ava_sub_rank_is_called_with_cache()

        then_the_returned_character_ava_sub_rank_was(AVA_SUB_RANK_1)
            and_eso_GetUnitAvARank_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_ava_sub_rank_is(sub_rank)
        cache.ava_sub_rank = sub_rank
    end

    local function and_that_eso_GetUnitAvARank_returns(rank, sub_rank)
        ut_helper.stub_function(GLOBAL, "GetUnitAvARank", rank, sub_rank)
    end

    local function and_eso_GetUnitAvARank_was_not_called()
        assert.spy(GLOBAL.GetUnitAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA SUB-RANK from the CACHE",
    function()
        given_that_cached_character_ava_sub_rank_is(AVA_SUB_RANK_1)
            and_that_eso_GetUnitAvARank_returns(AVA_RANK_2, AVA_SUB_RANK_2)

        when_get_character_ava_sub_rank_is_called_with_cache()

        then_the_returned_character_ava_sub_rank_was(AVA_SUB_RANK_1)
            and_eso_GetUnitAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is_not_set()
        cache.ava_rank_name = nil
    end

    local function and_that_eso_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_that_get_character_gender_returns(gender)
        ut_helper.stub_function(pinfo_char, "get_character_gender", gender)
    end

    local function and_that_get_character_ava_rank_returns(rank)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank", rank)
    end

    local function when_get_character_ava_rank_name_is_called_with_cache()
        results.ava_rank_name = pinfo_char.get_character_ava_rank_name(cache)
    end

    local function then_the_returned_character_ava_rank_name_was(rank)
        assert.is.equal(rank, results.ava_rank_name)
    end

    local function and_eso_GetAvARankName_was_called_once_with(gender, rank)
        assert.spy(GLOBAL.GetAvARankName).was.called_with(gender, rank)
    end

    local function and_get_character_gender_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_gender).was.called_with(cache)
    end

    local function and_get_character_ava_rank_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank).was.called_with(cache)
    end
    -- }}}

    it("Query CHARACTER AvA RANK-NAME from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_name_is_not_set()
            and_that_eso_GetAvARankName_returns(AVA_RANK_NAME_1)
            and_that_get_character_gender_returns(GENDER_1)
            and_that_get_character_ava_rank_returns(AVA_RANK_1)

        when_get_character_ava_rank_name_is_called_with_cache()

        then_the_returned_character_ava_rank_name_was(AVA_RANK_NAME_1)
            and_eso_GetAvARankName_was_called_once_with(GENDER_1, AVA_RANK_1)
            and_get_character_gender_was_called_once_with_cache()
            and_get_character_ava_rank_was_called_once_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_name_is(name)
        cache.ava_rank_name = name
    end

    local function and_that_eso_GetAvARankName_returns(name)
        ut_helper.stub_function(GLOBAL, "GetAvARankName", name)
    end

    local function and_eso_GetAvARankName_was_not_called()
        assert.spy(GLOBAL.GetAvARankName).was_not.called()
    end

    local function and_get_character_gender_was_not_called()
        assert.spy(pinfo_char.get_character_gender).was_not.called()
    end

    local function and_get_character_ava_rank_was_not_called()
        assert.spy(pinfo_char.get_character_ava_rank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA RANK-NAME from the CACHE",
    function()
        given_that_cached_character_ava_rank_name_is(AVA_RANK_NAME_1)
            and_that_eso_GetAvARankName_returns(AVA_RANK_NAME_2)
            and_that_get_character_gender_returns(GENDER_1)
            and_that_get_character_ava_rank_returns(AVA_RANK_1)

        when_get_character_ava_rank_name_is_called_with_cache()

        then_the_returned_character_ava_rank_name_was(AVA_RANK_NAME_1)
            and_eso_GetAvARankName_was_not_called()
            and_get_character_gender_was_not_called()
            and_get_character_ava_rank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_class_is_not_set()
        cache.class = nil
    end

    local function and_that_eso_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function when_get_character_class_is_called_with_cache()
        results.class = pinfo_char.get_character_class(cache)
    end

    local function then_the_returned_character_class_was(class)
        assert.is.equal(class, results.class)
    end

    local function and_eso_GetUnitClass_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitClass).was.called_with(PLAYER)
    end
    -- }}}

    it("Query CHARACTER CLASS from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_class_is_not_set()
            and_that_eso_GetUnitClass_returns(CLASS_1)

        when_get_character_class_is_called_with_cache()

        then_the_returned_character_class_was(CLASS_1)
            and_eso_GetUnitClass_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_class_is(class)
        cache.class = class
    end

    local function and_that_eso_GetUnitClass_returns(class)
        ut_helper.stub_function(GLOBAL, "GetUnitClass", class)
    end

    local function and_eso_GetUnitClass_was_not_called()
        assert.spy(GLOBAL.GetUnitClass).was_not.called()
    end
    -- }}}

    it("Query CHARACTER CLASS from the CACHE",
    function()
        given_that_cached_character_class_is(CLASS_1)
            and_that_eso_GetUnitClass_returns(CLASS_2)

        when_get_character_class_is_called_with_cache()

        then_the_returned_character_class_was(CLASS_1)
            and_eso_GetUnitClass_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is_not_set()
        cache.level_xp_max = nil
    end

    local function and_that_eso_GetUnitXPMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXPMax", xp)
    end

    local function when_get_character_level_xp_max_is_called_with_cache()
        results.level_xp_max = pinfo_char.get_character_level_xp_max(cache)
    end

    local function then_the_returned_level_xp_max_was(xp)
        assert.is.equal(xp, results.level_xp_max)
    end

    local function and_is_character_veteran_was_called_with_cache()
        assert.spy(pinfo_char.is_character_veteran).was.called_with(cache)
    end

    local function and_eso_GetUnitXPMax_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitXPMax).was.called_with(PLAYER)
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_max_is_not_set()
            and_that_eso_GetUnitXPMax_returns(LEVEL_XP_MAX_1)
            and_character_is_not_veteran()

        when_get_character_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_is_character_veteran_was_called_with_cache()
            and_eso_GetUnitXPMax_was_called_once_with_player()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranPointsMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranPointsMax", xp)
    end

    local function and_eso_GetUnitVeteranPointsMax_was_called_once_with_player()
        assert.spy(GLOBAL.GetUnitVeteranPointsMax).was.called_with(PLAYER)
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP MAX from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_max_is_not_set()
            and_that_eso_GetUnitVeteranPointsMax_returns(LEVEL_XP_MAX_1)
            and_character_is_veteran()

        when_get_character_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_is_character_veteran_was_called_with_cache()
            and_eso_GetUnitVeteranPointsMax_was_called_once_with_player()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_max_is(xp)
        cache.level_xp_max = xp
    end

    local function and_that_eso_GetUnitXPMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitXPMax", xp)
    end

    local function and_eso_GetUnitXPMax_was_not_called()
        assert.spy(GLOBAL.GetUnitXPMax).was_not.called()
    end
    -- }}}

    it("Query NON-VETERAN CHARACTER LEVEL-XP MAX from the CACHE",
    function()
        given_that_cached_character_level_xp_max_is(LEVEL_XP_MAX_1)
            and_that_eso_GetUnitXPMax_returns(LEVEL_XP_MAX_2)
            and_character_is_not_veteran()

        when_get_character_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitXPMax_was_not_called()
    end)

    -- {{{
    local function and_that_eso_GetUnitVeteranPointsMax_returns(xp)
        ut_helper.stub_function(GLOBAL, "GetUnitVeteranPointsMax", xp)
    end

    local function and_eso_GetUnitVeteranPointsMax_was_not_called()
        assert.spy(GLOBAL.GetUnitVeteranPointsMax).was_not.called()
    end
    -- }}}

    it("Query VETERAN CHARACTER LEVEL-XP MAX from the CACHE",
    function()
        given_that_cached_character_level_xp_max_is(LEVEL_XP_MAX_1)
            and_that_eso_GetUnitVeteranPointsMax_returns(LEVEL_XP_MAX_2)
            and_character_is_veteran()

        when_get_character_level_xp_max_is_called_with_cache()

        then_the_returned_level_xp_max_was(LEVEL_XP_MAX_1)
            and_is_character_veteran_was_not_called()
            and_eso_GetUnitVeteranPointsMax_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is_not_set()
        cache.level_xp_percent = nil
    end

    local function and_that_get_character_level_xp_returns(xp)
        ut_helper.stub_function(pinfo_char, "get_character_level_xp", xp)
    end

    local function and_that_get_character_level_xp_max_returns(xp)
        ut_helper.stub_function(pinfo_char, "get_character_level_xp_max", xp)
    end

    local function when_get_character_level_xp_percent_is_called_with_cache()
        results.level_xp_percent = pinfo_char.get_character_level_xp_percent(cache)
    end

    local function then_the_returned_level_xp_percent_was(level_xp_percent)
        assert.is.equal(level_xp_percent, results.level_xp_percent)
    end

    local function and_get_character_level_xp_was_called_with_cache()
        assert.spy(pinfo_char.get_character_level_xp).was.called_with(cache)
    end

    local function and_get_character_level_xp_max_was_called_with_cache()
        assert.spy(pinfo_char.get_character_level_xp_max).was.called_with(cache)
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_character_level_xp_returns(82)
            and_that_get_character_level_xp_max_returns(500)

        when_get_character_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(16.4)
            and_get_character_level_xp_was_called_with_cache()
            and_get_character_level_xp_max_was_called_with_cache()
    end)

    it("Query CHARACTER LEVEL-XP PERCENT, when NOT CACHED and LEVEL-XP MAX is 0",
    function()
        given_that_cached_character_level_xp_percent_is_not_set()
            and_that_get_character_level_xp_returns(100)
            and_that_get_character_level_xp_max_returns(0)

        when_get_character_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(0)
            and_get_character_level_xp_was_called_with_cache()
            and_get_character_level_xp_max_was_called_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_percent_is(percent)
        cache.level_xp_percent = percent
    end

    local function and_that_get_character_level_xp_max_returns(xp)
        ut_helper.stub_function(pinfo_char, "get_character_level_xp_max", xp)
    end

    local function and_that_get_character_level_xp_returns(xp)
        ut_helper.stub_function(pinfo_char, "get_character_level_xp", xp)
    end

    local function and_get_character_level_xp_max_was_not_called()
        assert.spy(pinfo_char.get_character_level_xp_max).was_not.called()
    end

    local function and_get_character_level_xp_was_not_called()
        assert.spy(pinfo_char.get_character_level_xp).was_not.called()
    end
    -- }}}

    it("Query CHARACTER LEVEL-XP PERCENT from the CACHE",
    function()
        given_that_cached_character_level_xp_percent_is(LEVEL_XP_PERCENT)
            and_that_get_character_level_xp_max_returns(LEVEL_XP_MAX_1)
            and_that_get_character_level_xp_returns(LEVEL_XP_1)

        when_get_character_level_xp_percent_is_called_with_cache()

        then_the_returned_level_xp_percent_was(LEVEL_XP_PERCENT)
            and_get_character_level_xp_max_was_not_called()
            and_get_character_level_xp_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is_not_set()
        cache.xp_gain = nil
    end

    local function when_get_character_xp_gain_is_called_with_cache()
        results.xp_gain = pinfo_char.get_character_xp_gain(cache)
    end

    local function then_the_returned_level_xp_gain_was(gain)
        assert.is.equal(gain, results.xp_gain)
    end
    -- }}}

    it("Query CHARACTER XP-GAIN, when NOT CACHED",
    function()
        given_that_cached_character_level_xp_gain_is_not_set()

        when_get_character_xp_gain_is_called_with_cache()

        then_the_returned_level_xp_gain_was(0)
    end)

    -- {{{
    local function given_that_cached_character_level_xp_gain_is(gain)
        cache.xp_gain = gain
    end
    -- }}}

    it("Query CHARACTER XP-GAIN from the CACHE",
    function()
        given_that_cached_character_level_xp_gain_is(LEVEL_XP_GAIN)

        when_get_character_xp_gain_is_called_with_cache()

        then_the_returned_level_xp_gain_was(LEVEL_XP_GAIN)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_is_not_set()
        cache.ava_rank_points = nil
    end

    local function and_that_get_character_ava_rank_points_lb_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_lb", points)
    end

    local function and_that_get_character_ava_points_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_points", points)
    end

    local function when_get_character_ava_rank_points_is_called_with_cache()
        results.ava_rank_points = pinfo_char.get_character_ava_rank_points(cache)
    end

    local function then_the_returned_character_ava_rank_points_was(points)
        assert.is.equal(points, results.ava_rank_points)
    end

    local function and_get_character_ava_rank_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank).was.called_with(cache)
    end

    local function and_get_character_ava_points_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_points).was.called_with(cache)
    end

    local function and_get_character_ava_rank_points_lb_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_points_lb).was.called_with(cache)
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_points_is_not_set()
            and_that_get_character_ava_points_returns(150)
            and_that_get_character_ava_rank_points_lb_returns(100)

        when_get_character_ava_rank_points_is_called_with_cache()

        then_the_returned_character_ava_rank_points_was(50)
            and_get_character_ava_points_was_called_once_with_cache()
            and_get_character_ava_rank_points_lb_was_called_once_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_is(points)
        cache.ava_rank_points = points
    end

    local function and_get_character_ava_points_was_not_called()
        assert.spy(pinfo_char.get_character_ava_points).was_not.called()
    end

    local function and_get_character_ava_rank_points_lb_was_not_called()
        assert.spy(pinfo_char.get_character_ava_rank_points_lb).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS from the cache",
    function()
        given_that_cached_character_ava_rank_points_is(AVA_RANK_POINTS_1)
            and_that_get_character_ava_points_returns(AVA_POINTS_1)
            and_that_get_character_ava_rank_points_lb_returns(AVA_RANK_POINTS_LB_1)

        when_get_character_ava_rank_points_is_called_with_cache()

        then_the_returned_character_ava_rank_points_was(AVA_RANK_POINTS_1)
            and_get_character_ava_points_was_not_called()
            and_get_character_ava_rank_points_lb_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_max_is_not_set()
        cache.ava_rank_points_max = nil
    end

    local function and_that_get_character_ava_rank_points_lb_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_lb", points)
    end

    local function and_that_get_character_ava_rank_points_ub_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_ub", points)
    end

    local function when_get_character_ava_rank_points_max_is_called_with_cache()
        results.ava_rank_points_max = pinfo_char.get_character_ava_rank_points_max(cache)
    end

    local function then_the_returned_character_ava_rank_points_max_was(points)
        assert.is.equal(points, results.ava_rank_points_max)
    end

    local function and_get_character_ava_rank_points_ub_was_called_once_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_points_ub).was.called_with(cache)
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS MAX from the SYSTEM, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_points_max_is_not_set()
            and_that_get_character_ava_rank_returns(AVA_RANK_1)
            and_that_get_character_ava_rank_points_lb_returns(AVA_RANK_POINTS_LB_1)
            and_that_get_character_ava_rank_points_ub_returns(AVA_RANK_POINTS_UB_1)

        when_get_character_ava_rank_points_max_is_called_with_cache()

        then_the_returned_character_ava_rank_points_max_was(
                                AVA_RANK_POINTS_UB_1 - AVA_RANK_POINTS_LB_1)
            and_get_character_ava_rank_points_lb_was_called_once_with_cache()
            and_get_character_ava_rank_points_ub_was_called_once_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_max_is(points)
        cache.ava_rank_points_max = points
    end

    local function and_get_character_ava_rank_points_ub_was_not_called()
        assert.spy(pinfo_char.get_character_ava_rank_points_ub).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS MAX from the cache",
    function()
        given_that_cached_character_ava_rank_points_max_is(AVA_RANK_POINTS_MAX_1)
            and_that_get_character_ava_rank_points_lb_returns(AVA_RANK_POINTS_LB_1)
            and_that_get_character_ava_rank_points_ub_returns(AVA_RANK_POINTS_UB_1)

        when_get_character_ava_rank_points_max_is_called_with_cache()

        then_the_returned_character_ava_rank_points_max_was(AVA_RANK_POINTS_MAX_1)
            and_get_character_ava_rank_points_lb_was_not_called()
            and_get_character_ava_rank_points_ub_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_percent_is_not_set()
        cache.ava_rank_points_percent = nil
    end

    local function and_that_get_character_ava_rank_points_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points", points)
    end

    local function and_that_get_character_ava_rank_points_max_returns(points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_max", points)
    end

    local function when_get_character_ava_rank_points_percent_is_called_with_cache()
        results.rank_points_percent = pinfo_char.get_character_ava_rank_points_percent(cache)
    end

    local function then_the_returned_ava_rank_points_percent_was(rank_points_percent)
        assert.is.equal(rank_points_percent, results.rank_points_percent)
    end

    local function and_get_character_ava_rank_points_was_called_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_points).was.called_with(cache)
    end

    local function and_get_character_ava_rank_points_max_was_called_with_cache()
        assert.spy(pinfo_char.get_character_ava_rank_points_max).was.called_with(cache)
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS PERCENT, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_points_percent_is_not_set()
            and_that_get_character_ava_rank_points_returns(82)
            and_that_get_character_ava_rank_points_max_returns(500)

        when_get_character_ava_rank_points_percent_is_called_with_cache()

        then_the_returned_ava_rank_points_percent_was(16.4)
            and_get_character_ava_rank_points_was_called_with_cache()
            and_get_character_ava_rank_points_max_was_called_with_cache()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_percent_is(percent)
        cache.ava_rank_points_percent = percent
    end

    local function and_that_get_character_ava_rank_points_max_returns(rank_points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points_max", rank_points)
    end

    local function and_that_get_character_ava_rank_points_returns(rank_points)
        ut_helper.stub_function(pinfo_char, "get_character_ava_rank_points", rank_points)
    end

    local function and_get_character_ava_rank_points_max_was_not_called()
        assert.spy(pinfo_char.get_character_ava_rank_points_max).was_not.called()
    end

    local function and_get_character_ava_rank_points_was_not_called()
        assert.spy(pinfo_char.get_character_ava_rank_points).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AvA-RANK POINTS PERCENT from the CACHE",
    function()
        given_that_cached_character_ava_rank_points_percent_is(AVA_RANK_POINTS_PERCENT)
            and_that_get_character_ava_rank_points_max_returns(AVA_RANK_POINTS_MAX_1)
            and_that_get_character_ava_rank_points_returns(AVA_RANK_POINTS_1)

        when_get_character_ava_rank_points_percent_is_called_with_cache()

        then_the_returned_ava_rank_points_percent_was(AVA_RANK_POINTS_PERCENT)
            and_get_character_ava_rank_points_max_was_not_called()
            and_get_character_ava_rank_points_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_points_gain_is_not_set()
        cache.ava_points_gain = nil
    end

    local function when_get_character_ava_points_gain_is_called_with_cache()
        results.ava_points_gain = pinfo_char.get_character_ava_points_gain(cache)
    end

    local function then_the_returned_ava_points_gain_was(gain)
        assert.is.equal(gain, results.ava_points_gain)
    end
    -- }}}

    it("Query CHARACTER AVA-POINTS GAIN, when NOT CACHED",
    function()
        given_that_cached_character_ava_points_gain_is_not_set()

        when_get_character_ava_points_gain_is_called_with_cache()

        then_the_returned_ava_points_gain_was(0)
    end)

    -- {{{
    local function given_that_cached_character_ava_points_gain_is(gain)
        cache.ava_points_gain = gain
    end
    -- }}}

    it("Query CHARACTER AVA-POINTS GAIN from the CACHE",
    function()
        given_that_cached_character_ava_points_gain_is(AVA_POINTS_GAIN)

        when_get_character_ava_points_gain_is_called_with_cache()

        then_the_returned_ava_points_gain_was(AVA_POINTS_GAIN)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is_not_set()
        cache.ava_rank_points_lb = nil
    end

    local function and_that_eso_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_character_ava_rank_points_lb_is_called_with_cache()
        results.ava_rank_points_lb = pinfo_char.get_character_ava_rank_points_lb(cache)
    end

    local function then_the_returned_character_ava_rank_points_lb_was(point)
        assert.is.equal(point, results.ava_rank_points_lb)
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_points_lb_is_not_set()
            and_that_get_character_ava_rank_returns(AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(AVA_RANK_POINTS_LB_1)

        when_get_character_ava_rank_points_lb_is_called_with_cache()

        then_the_returned_character_ava_rank_points_lb_was(AVA_RANK_POINTS_LB_1)
            and_get_character_ava_rank_was_called_once_with_cache()
            and_eso_GetNumPointsNeededForAvARank_was_called_once_with(AVA_RANK_1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_lb_is(point)
        cache.ava_rank_points_lb = point
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK LOWER BOUND POINTS from the CACHE",
    function()
        given_that_cached_character_ava_rank_points_lb_is(AVA_RANK_POINTS_LB_1)
            and_that_get_character_ava_rank_returns(AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(AVA_RANK_POINTS_LB_2)

        when_get_character_ava_rank_points_lb_is_called_with_cache()

        then_the_returned_character_ava_rank_points_lb_was(AVA_RANK_POINTS_LB_1)
            and_get_character_ava_rank_was_not_called()
            and_eso_GetNumPointsNeededForAvARank_was_not_called()
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is_not_set()
        cache.ava_rank_points_ub = nil
    end

    local function and_that_eso_GetNumPointsNeededForAvARank_returns(point)
        ut_helper.stub_function(GLOBAL, "GetNumPointsNeededForAvARank", point)
    end

    local function when_get_character_ava_rank_points_ub_is_called_with_cache()
        results.ava_rank_points_ub = pinfo_char.get_character_ava_rank_points_ub(cache)
    end

    local function then_the_returned_character_ava_rank_points_ub_was(point)
        assert.is.equal(point, results.ava_rank_points_ub)
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_called_once_with(rank)
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was.called_with(rank)
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS, when NOT CACHED",
    function()
        given_that_cached_character_ava_rank_points_ub_is_not_set()
            and_that_get_character_ava_rank_returns(AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(AVA_RANK_POINTS_UB_1)

        when_get_character_ava_rank_points_ub_is_called_with_cache()

        then_the_returned_character_ava_rank_points_ub_was(AVA_RANK_POINTS_UB_1)
            and_get_character_ava_rank_was_called_once_with_cache()
            and_eso_GetNumPointsNeededForAvARank_was_called_once_with(AVA_RANK_1 + 1)
    end)

    -- {{{
    local function given_that_cached_character_ava_rank_points_ub_is(point)
        cache.ava_rank_points_ub = point
    end

    local function and_eso_GetNumPointsNeededForAvARank_was_not_called()
        assert.spy(GLOBAL.GetNumPointsNeededForAvARank).was_not.called()
    end
    -- }}}

    it("Query CHARACTER AVA-RANK UPPER BOUND POINTS from the CACHE",
    function()
        given_that_cached_character_ava_rank_points_ub_is(AVA_RANK_POINTS_UB_1)
            and_that_get_character_ava_rank_returns(AVA_RANK_1)
            and_that_eso_GetNumPointsNeededForAvARank_returns(AVA_RANK_POINTS_UB_2)

        when_get_character_ava_rank_points_ub_is_called_with_cache()

        then_the_returned_character_ava_rank_points_ub_was(AVA_RANK_POINTS_UB_1)
            and_get_character_ava_rank_was_not_called()
            and_eso_GetNumPointsNeededForAvARank_was_not_called()
    end)
end)

-- vim:fdm=marker
