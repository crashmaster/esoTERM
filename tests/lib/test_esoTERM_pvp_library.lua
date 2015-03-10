local test_library = require("tests/lib/test_library")
local esoTERM_pvp = require("esoTERM_pvp")

test_esoTERM_pvp_library = {}

test_esoTERM_pvp_library.CACHE = esoTERM_pvp.cache
test_esoTERM_pvp_library.EVENT_REGISTER = esoTERM_pvp.event_register

test_esoTERM_pvp_library.AVA_POINTS_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_POINTS_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_SUB_RANK_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_SUB_RANK_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_NAME_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_NAME_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_MAX_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_MAX_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_LB_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_LB_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_UB_1 = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_UB_2 = test_library.B_INTEGER
test_esoTERM_pvp_library.AVA_RANK_POINTS_PERCENT = test_library.A_INTEGER
test_esoTERM_pvp_library.AVA_POINTS_GAIN = test_library.A_INTEGER
test_esoTERM_pvp_library.GENDER_1 = test_library.A_INTEGER

return test_esoTERM_pvp_library