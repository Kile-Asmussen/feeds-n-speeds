require 'prelude'

local name = fns 'sulfur-ore'
local patches_var = fns 'default-sulfur-ore-patches'

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
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    stage_counts = { 10000, 6330, 3670, 1930, 870, 270, 100, 50 },
    stages = {
        sheet = {
            filename = '__base__/graphics/entity/uranium-ore/uranium-ore.png',  -- placeholder
            width = 128,
            height = 128,
            frame_count = 8,
            variation_count = 8,
            scale = 0.5,
        },
    },
    map_color = { r = 0.9, g = 0.8, b = 0.1 },
    mining_visualisation_tint = { r = 0.9, g = 0.8, b = 0.1, a = 1 },
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 1024,
    autoplace = {
        order = 'c',
        probability_expression = "(var('control:" .. name .. ":size') > 0) * (clamp(var('" .. patches_var .. "'), 0, 1))",
        richness_expression = "(var('control:" .. name .. ":size') > 0) * (1*var('control:" .. name .. ":richness')*(var('" .. patches_var .. "'))*max((1000+distance)/2600,1))",
    },
}
