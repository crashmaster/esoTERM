local test_library = require("tests/test_library")

test_esoTERM_char_library = {}

VETERANNESS_1 = test_library.A_BOOL
VETERANNESS_2 = test_library.B_BOOL
LEVEL_1 = test_library.A_INTEGER
LEVEL_2 = test_library.B_INTEGER
LEVEL_XP_1 = test_library.A_INTEGER
LEVEL_XP_2 = test_library.B_INTEGER
LEVEL_XP_MAX_1 = test_library.A_INTEGER
LEVEL_XP_MAX_2 = test_library.B_INTEGER
LEVEL_XP_PERCENT = test_library.A_INTEGER
LEVEL_XP_GAIN = test_library.A_INTEGER

CACHE = esoTERM_pve.cache
EVENT_REGISTER = esoTERM_pve.event_register

return test_esoTERM_char_library
