local test_library = require("tests/test_library")

test_esoTERM_char_library = {}

CACHE = esoTERM_char.cache
EVENT_REGISTER = esoTERM_char.event_register

test_esoTERM_char_library.GENDER_1 = test_library.A_STRING
test_esoTERM_char_library.GENDER_2 = test_library.B_STRING
test_esoTERM_char_library.CLASS_1 = test_library.A_STRING
test_esoTERM_char_library.CLASS_2 = test_library.B_STRING
test_esoTERM_char_library.NAME_1 = test_library.A_STRING
test_esoTERM_char_library.NAME_2 = test_library.B_STRING
test_esoTERM_char_library.COMBAT_STATE_1 = test_library.A_BOOL
test_esoTERM_char_library.COMBAT_STATE_2 = test_library.B_BOOL
test_esoTERM_char_library.COMBAT_START_TIME = test_library.A_INTEGER
test_esoTERM_char_library.COMBAT_LENGHT = test_library.A_INTEGER
test_esoTERM_char_library.COMBAT_DAMAGE = test_library.A_INTEGER

return test_esoTERM_char_library
