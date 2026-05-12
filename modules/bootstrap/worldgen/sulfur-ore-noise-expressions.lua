-- Sulfur ore noise expression with parameterized builder
-- Placeholder registered in data stage; rebuilt with correct indices in data_updates
require 'prelude'

local tools = require 'tools'

local noise = assoc{
    name = fns 'sulfur-ore',
    has_starting_area_placement = 1,
    base_spots_per_km2 = 1.25,
    regular_patch_set_index = "var('" .. fns 'sulfur-ore-regular-index' .. "')",
    starting_patch_set_index = "var('" .. fns 'sulfur-ore-starting-index' .. "')",
    starting_rq_factor=11/70,
}

prototype(
    assoc{
        type = 'noise-expression',
        name = fns 'sulfur-ore-patches',
        expression = tools.resource_autoplace_all_patches(noise)
    },
    assoc{
        type = 'noise-expression',
        name = fns 'sulfur-ore-regular-index',
        expression = -1,
    },
    assoc{
        type = 'noise-expression',
        name = fns 'sulfur-ore-starting-index',
        expression = -1,
    },
    assoc{
        type = 'autoplace-control',
        name = fns 'sulfur-ore',
        localised_name = array{'', '[entity=' .. fns 'sulfur-ore' .. '] ',
            array{ fns_locale_key('entity-name', 'sulfur-ore')}},
        category = 'resource',
        richness = true,
        order = 'a-g',
    }
)