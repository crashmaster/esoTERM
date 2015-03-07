this = {}

local MODULE_NAME = "esoTERM-champion"

-- module_name {{{
function this.verify_that_the_module_name_is_the_expected_one()
    assert.is.equal(MODULE_NAME, esoTERM_champ.module_name)
end
-- }}}

return this

-- vim:fdm=marker
