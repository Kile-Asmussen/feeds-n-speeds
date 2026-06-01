--! data: sulfur ore-related noise expressions and autoplace control
local fns = require 'fns'

local noise = {
    name = fns 'sulfur-ore',
    has_starting_area_placement = 1,
    base_density = 3,
    base_spots_per_km2 = 1.25,
    regular_patch_set_index = "var('" .. fns 'sulfur-ore-regular-index' .. "')",
    starting_patch_set_index = "var('" .. fns 'sulfur-ore-starting-index' .. "')",
    starting_blob_amplitude_multiplier = 0.125 / 1.5,
    starting_rq_factor=11/70,
}

data:extend{
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-patches',
        expression = fns.gadgets.resource_autoplace_all_patches(noise)
    },
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-regular-index',
        expression = -1,
    },
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-starting-index',
        expression = -1,
    },
    {
        type = 'autoplace-control',
        name = fns 'sulfur-ore',
        localised_name = {'', '[entity=' .. fns 'sulfur-ore' .. '] ',
            { fns.locale_key('entity-name', 'sulfur-ore')}},
        category = 'resource',
        richness = true,
        order = 'a-g',
    }
}