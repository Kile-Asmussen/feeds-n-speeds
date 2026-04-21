-- Sulfur ore noise expression with parameterized builder
-- Placeholder registered in data stage; rebuilt with correct indices in data_updates
require 'prelude'

local utilities = require 'extras.utilities'

return {
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-patches',
        expression = 
        utilities.resource_autoplace_all_patches{
            name = fns 'sulfur-ore',
            has_starting_area = enabled('extras.drills', 'tweaks.earlygame') and 1 or 0,
            regular_patch_set_index = "var('" .. fns 'sulfur-ore-regular-index' .. "')",
            starting_patch_set_index = "var('" .. fns 'sulfur-ore-starting-index' .. "')",
        }
    },
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-regular-index',
        expression = -1,  -- placeholder indices
    },
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-starting-index',
        expression = -1,  -- placeholder indices
    },
    {
        type = 'autoplace-control',
        name = fns 'sulfur-ore',
        localised_name = {'', '[entity=' .. fns 'sulfur-ore' .. '] ', {'entity-name.' .. fns 'sulfur-ore'}},
        category = 'resource',
        richness = true,
        order = 'a-g',
    }
}
