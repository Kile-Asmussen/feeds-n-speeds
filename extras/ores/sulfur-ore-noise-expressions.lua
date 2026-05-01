-- Sulfur ore noise expression with parameterized builder
-- Placeholder registered in data stage; rebuilt with correct indices in data_updates
require 'prelude'

local utilities = require 'extras.utilities'

local noise = {
    name = fns 'sulfur-ore',
    has_starting_area_placement = enabled('extras.drills', 'tweaks.earlygame') and 1 or 0,
    base_density = 0.9,
    base_spots_per_km2 = 1.25,
    has_starting_area_placement = 0,
    random_spot_size_minimum = 1,
    random_spot_size_maximum = 3,
    random_spot_size_maximum = 3,

    regular_patch_set_index = "var('" .. fns 'sulfur-ore-regular-index' .. "')",
    starting_rq_factor=10/70,
    regular_rq_factor=0.1,
}

if enabled('extras.drills', 'tweaks.earlygame') then
    noise.has_starting_area_placement = 1
    
    noise.starting_patch_set_index = "var('" .. fns 'sulfur-ore-starting-index' .. "')"
end

return {
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-patches',
        expression = utilities.resource_autoplace_all_patches(noise)
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
        localised_name = {'', '[entity=' .. fns 'sulfur-ore' .. '] ', { fns('entity-name', 'sulfur-ore')}},
        category = 'resource',
        richness = true,
        order = 'a-g',
    }
}
