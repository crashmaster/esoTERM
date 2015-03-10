local test_library = require("tests/lib/test_library")
local esoTERM_pve = require("esoTERM_pve")

test_esoTERM_pve_library = {}

test_esoTERM_pve_library.CACHE = esoTERM_pve.cache
test_esoTERM_pve_library.EVENT_REGISTER = esoTERM_pve.event_register

test_esoTERM_pve_library.VETERANNESS_1 = test_library.A_BOOL
test_esoTERM_pve_library.VETERANNESS_2 = test_library.B_BOOL
test_esoTERM_pve_library.LEVEL_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_1 = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_MAX_2 = test_library.B_INTEGER
test_esoTERM_pve_library.LEVEL_XP_PERCENT = test_library.A_INTEGER
test_esoTERM_pve_library.LEVEL_XP_GAIN = test_library.A_INTEGER

return test_esoTERM_pve_library
