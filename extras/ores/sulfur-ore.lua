require 'prelude'

local resource_autoplace = require 'resource-autoplace'

local name = fns 'sulfur-ore'

return {
    type = 'resource',
    name = name,
    icon = '__base__/graphics/icons/sulfur.png',
    icon_size = 64,
    flags = { 'placeable-neutral' },
    order = 'a-b-f',
    minable = {
        mining_time = 1,
        required_fluid = 'steam',
        fluid_amount = 10,
        result = 'sulfur',
        mining_particle = 'stone-particle',
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    stage_counts = { 10000, 6330, 3670, 1930, 870, 270, 100, 50 },
    stages = {
        sheet = {
            filename = '__space-age__/graphics/entity/calcite/calcite.png',
            size = 128,
            frame_count = 8,
            variation_count = 8,
            scale = 0.5,
            priority = 'extra-high',
            tint = { r = 1.0, g = 0.95, b = 0.2 },  -- bright yellow
        },
    },
    map_color = { r = 0.9, g = 0.8, b = 0.1 },
    mining_visualisation_tint = { r = 0.9, g = 0.8, b = 0.1, a = 1 },
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 1024,
    autoplace = resource_autoplace.resource_autoplace_settings{
        name = name,
        order = 'c',
        base_density = 8,
        base_spots_per_km2 = 1.5,
        has_starting_area_placement = false,  -- updated dynamically in data_updates
        random_spot_size_minimum = 0.25,
        random_spot_size_maximum = 2,
        regular_rq_factor_multiplier = 1,
    },
}
