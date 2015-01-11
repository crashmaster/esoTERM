local test_library = require("tests/test_library")

test_esoTERM_char_library = {}

GENDER_1 = test_library.A_STRING
GENDER_2 = test_library.B_STRING
CLASS_1 = test_library.A_STRING
CLASS_2 = test_library.B_STRING
NAME_1 = test_library.A_STRING
NAME_2 = test_library.B_STRING
COMBAT_STATE_1 = test_library.A_BOOL
COMBAT_STATE_2 = test_library.B_BOOL
COMBAT_START_TIME = test_library.A_INTEGER
COMBAT_LENGHT = test_library.A_INTEGER
COMBAT_DAMAGE = test_library.A_INTEGER

CACHE = esoTERM_char.cache
EVENT_REGISTER = esoTERM_char.event_register

return test_esoTERM_char_library
