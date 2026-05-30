-- data: major changes to robotics recipes
local fns = require 'fns'
local base = data.raw.roboport.roboport
local inputs = fns.gadgets.throughputs

base.charging_station_count_affected_by_quality = true

table.insert(data.raw.technology['robotics'].prerequisites, 'advanced-combinators')

local sleeper = table.clone(base)
local log_only = table.clone(base)
local cons_only = table.clone(base)

table.merge(sleeper, {
    material_slots_count = 0,
    robot_slots_count = 14,
    construction_radius = 5,
    logistics_radius = 3,
    radar_range = 1,
    energy_usage = "15kW",
    charging_energy = "750kW",
    charging_slots = 6,
    draw_construction_radius_visualization = false,
    draw_logistic_radius_visualization = false,
    name = fns 'sleeper-roboport',
    auto_unlocked_by = 'logistic-robotics',
    minable = table.assign{ 'result', val = fns 'sleeper-roboport' },
    base_animation = table.merge{
        animation_speed = 0.25,
        run_mode = 'backward',
        tint = { 1, 1, 0.0 },
    },
    icon = utils.null,
    icons = {
        { icon = data.raw.item.roboport.icon, icon_size = 64 },
        { 
            icon = data.raw.item['storage-chest'].icon,
            icon_size = 64,
            scale = 0.25,
            floating = true,
            shift = { -8, 8 }
        },
    },
})

table.merge(log_only, {
    material_slots_count = 0,
    construction_radius = 30,
    logistics_radius = 30,
    charging_energy = "750kW",
    draw_construction_radius_visualization = false,
    draw_logistic_radius_visualization = true,
    name = fns 'logistics-roboport',
    auto_unlocked_by = 'logistic-robotics',
    minable = table.assign{ 'result', val = fns 'logistics-roboport' },
    base_animation = table.merge{
        animation_speed =0.50,
        run_mode = 'backward',
        tint = { 1, 0.7, 0.0 },
    },
    icon = utils.null,
    icons = {
        { icon = data.raw.item.roboport.icon, icon_size = 64 },
        { 
            icon = data.raw.item['construction-robot'].icon,
            icon_size = 64,
            scale = 0.25,
            floating = true,
            shift = { 8, -8 },
        },
    },
})

table.merge(cons_only, {
    radar_range = 3,
    logistics_radius = 10,
    construction_radius = 65,
    logistics_connection_distance = 35,
    draw_logistic_radius_visualization = false,
    auto_unlocked_by = 'construction-robotics',
    name = fns 'construction-roboport',
    icon = utils.null,
    icons = {
        { icon = data.raw.item.roboport.icon, icon_size = 64 },
        {
            icon = data.raw.item['construction-robot'].icon,
            icon_size = 64,
            scale = 0.25,
            floating = true,
            shift = { 8, 8 },
        },
    },
    base_animation = table.merge{
        animation_speed = 0.75,
        tint = { 0.0, 1, 0.0 },
    }
})

local base_item = data.raw.item.roboport

base_item.order = 'c[signal]-a[roboport]-a[vanilla]'

local sleeper_item = table.clone(base_item)
local log_item = table.clone(base_item)
local cons_item = table.clone(base_item)

for _, val in ipairs{
    { sleeper_item, sleeper, 'b[sleeper]' },
    { cons_item, cons_only, 'c[construction]' },
    { log_item, log_only, 'd[logistic]' },
} do
    table.merge(val[1], {
        icon = utils.null,
        icons = table.clone(val[2].icons),
        name = val[2].name,
        place_result = val[2].name,
        order = 'c[signal]-a[roboport]-' .. val[3],
    })
end

local base_recipe = data.raw.recipe.roboport
local sleeper_recipe = table.clone(base_recipe)
local log_recipe = table.clone(base_recipe)
local cons_recipe = table.clone(base_recipe)


local function change_recipe(recipe, name, tech, ingredients)
    return table.merge(recipe, {
        name = name,
        main_product = name,
        auto_unlocked_by = tech,
        results = inputs{ [name] = 1 },
        ingredients = ingredients
    })
end

base_recipe.ingredients = inputs{
    ['steel-plate'] = 10,
    radar = 1,
    pipe = 7,
    ['electric-engine-unit'] = 7,
    ['selector-combinator'] = 2,
    accumulator = 2,
    ['passive-provider-chest'] = 1,
    ['storage-chest'] = 1,
}

-- {
--     { type='item', name='radar', amount=1 },
--     { type='item', name='pipe', amount=7 },
--     { type='item', name='electric-engine-unit', amount=7 },
--     { type='item', name='selector-combinator', amount=5 },
--     { type='item', name='accumulator', amount=2 },
--     { type='item', name='passive-provider-chest', amount=1 },
-- }

change_recipe(sleeper_recipe, sleeper.name, 'logistic-robotics',
    inputs{
        ['steel-plate'] = 10,
        pipe = 15,
        ['electric-engine-unit'] = 3,
        ['selector-combinator'] = 2,
        accumulator = 3,
        ['storage-chest'] = 1
    }
)
-- {
--     { type='item', name=fns 'small-radar', amount=1 },
--     { type='item', name='pipe', amount=14 },
--     { type='item', name='electric-engine-unit', amount=1 },
--     { type='item', name='selector-combinator', amount=5 },
--     { type='item', name='accumulator', amount=3 },
--     { type='item', name='storage-chest', amount=1 },
-- })

change_recipe(log_recipe, log_only.name, 'logistic-system',
    inputs{
        ['steel-plate'] = 10,
        ['radar'] = 1,
        pipe = 7,
        ['electric-engine-unit'] = 7,
        ['constant-combinator'] = 5,
        ['selector-combinator'] = 2,
        accumulator = 3,
        ['buffer-chest'] = 1,
    }
)

-- {
--     { type='item', name=fns 'small-radar', amount=2 },
--     { type='item', name='pipe', amount=7 },
--     { type='item', name='electric-engine-unit', amount=7 },
--     { type='item', name='selector-combinator', amount=5 },
--     { type='item', name='accumulator', amount=3 },
--     { type='item', name='requester-chest', amount=1 },
--     { type='item', name='bufffer-chest', amount=1 },
--     { type='item', name='active-provider-chest', amount=1 },
-- })

change_recipe(cons_recipe, cons_only.name, 'construction-robotics',
    inputs{
        ['steel-plate'] = 10,
        radar = 3,
        pipe = 7,
        ['electric-engine-unit'] = 7,
        ['arithmetic-combinator'] = 5,
        ['selector-combinator'] = 2,
        accumulator = 2,
        ['passive-provider-chest'] = 2,
    }
)
-- {
--     { type='item', name='radar', amount=2 },
--     { type='item', name='pipe', amount=7 },
--     { type='item', name='electric-engine-unit', amount=7 },
--     { type='item', name='arithmetic-combinator', amount=5 },
--     { type='item', name='selector-combinator', amount=5 },
--     { type='item', name='accumulator', amount=2 },
--     { type='item', name='storage-chest', amount=1 },
--     { type='item', name='passive-provider-chest', amount=1 },
-- })

data:extend{
    sleeper,
    log_only,
    cons_only,
    sleeper_item,
    log_item,
    cons_item,
    sleeper_recipe,
    log_recipe,
    cons_recipe,
}