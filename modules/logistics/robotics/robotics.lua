--! data: major changes to robotics recipes
local fns = require 'fns'
local table = fns.table
local utils = fns.utils
local base = data.raw.roboport.roboport
local inputs = fns.gadgets.throughputs

base.charging_station_count_affected_by_quality = true

table.append(data.raw.technology['robotics'].prerequisites, {
    'advanced-combinators', 'electric-energy-accumulators',
    'lubricant'
})

data.raw.recipe['flying-robot-frame'].ingredients = inputs{
    ['battery'] = 2,
    ['electric-engine-unit'] = 2,
    ['plastic-bar'] = 4,
    ['iron-stick'] = 4,
    ['lubricant'] = 10,
}

local floating_icon = fns.gadgets.floating_icon
local fixed_icon = fns.gadgets.icon

local sleeper = table.deepcopy(base)
local log_only = table.deepcopy(base)
local cons_only = table.deepcopy(base)
local network = table.deepcopy(base)

table.merge(base, {
    base_animation = {
        __merge = true,
        animation_speed = 0.40,
    }
})

table.merge(sleeper, {
    __del = 'icon',
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
    auto_unlocked_by = 'logistic-network',
    minable = table.assign{ 'result', val = fns 'sleeper-roboport' },
    base_animation = {
        __merge = true,
        animation_speed = 0.30,
        run_mode = 'backward',
        tint = { 1, 1, 0.0 },
    },
    icons = {
        fixed_icon('icons/roboport.png'),
        floating_icon('bottomleft', 'icons/storage-chest.png', { scale = 0.30, tint = { 0, 0, 0, 0 } }),
        floating_icon('bottomleft', 'icons/storage-chest.png'),
    },
})

table.merge(log_only, {
    __del = 'icon',
    material_slots_count = 0,
    construction_radius = 32,
    logistics_radius = 30,
    draw_construction_radius_visualization = false,
    draw_logistic_radius_visualization = true,
    name = fns 'logistics-roboport',
    auto_unlocked_by = 'logistic-robotics',
    minable = table.assign{ 'result', val = fns 'logistics-roboport' },
    base_animation = {
        __merge = true,
        animation_speed =0.50,
        run_mode = 'backward',
        tint = { 1, 0.7, 0.0 },
    },
    icons = {
        fixed_icon('icons/roboport.png'),
        floating_icon('topright', 'icons/logistic-robot.png', { scale = 0.30, tint = { 0, 0, 0, 0 } }),
        floating_icon('topright', 'icons/logistic-robot.png'),
    },
})

table.merge(cons_only, {
    __del = 'icon',
    radar_range = 3,
    logistics_radius = 10,
    construction_radius = 65,
    logistics_connection_distance = 35,
    draw_logistic_radius_visualization = false,
    auto_unlocked_by = 'construction-robotics',
    name = fns 'construction-roboport',
    minable = table.assign{ 'result', val = fns 'construction-roboport' },
    icons = {
        fixed_icon('icons/roboport.png'),
        floating_icon('topright', 'icons/construction-robot.png', { scale = 0.30, tint = { 0, 0, 0, 0 } }),
        floating_icon('topright', 'icons/construction-robot.png'),
    },
    base_animation = {
        __merge = true,
        animation_speed = 0.5,
        tint = { 0.0, 1, 0.0 },
    }
})

table.merge(network, {
    __del = 'icon',
    material_slots_count = 0,
    radar_range = 2,
    logistics_radius = 3,
    construction_radius = 5,
    energy_usage = "15kW",
    charging_energy = "750kW",
    logistics_connection_distance = 55,
    draw_logistic_radius_visualization = false,
    minable = table.assign{ 'result', val = fns 'network-roboport' },
    auto_unlocked_by = 'logistic-network',
    name = fns 'network-roboport',
    icons = {
        fixed_icon('icons/roboport.png'),
        floating_icon('bottomleft', 'icons/requester-chest.png', { scale = 0.30, tint = { 0, 0, 0, 0 } }),
        floating_icon('bottomleft', 'icons/requester-chest.png'),
    },
    base_animation = {
        __merge = true,
        run_mode = 'backward',
        animation_speed = 0.30,
        tint = { 0.3, 0.3, 1.0 },
    }
})

local base_item = data.raw.item.roboport

base_item.order = 'c[signal]-a[roboport]-a[vanilla]'

local sleeper_item = table.deepcopy(base_item)
local log_item = table.deepcopy(base_item)
local cons_item = table.deepcopy(base_item)
local network_item = table.deepcopy(base_item)

for _, val in ipairs{
    { sleeper_item, sleeper, 'b[sleeper]' },
    { cons_item, cons_only, 'c[construction]' },
    { log_item, log_only, 'd[logistic]' },
    { network_item, network, 'e[network]' },
} do
    table.merge(val[1], {
        __del = 'icon',
        icons = table.deepcopy(val[2].icons),
        name = val[2].name,
        place_result = val[2].name,
        order = 'c[signal]-a[roboport]-' .. val[3],
    })
end

local base_recipe = data.raw.recipe.roboport
local sleeper_recipe = table.deepcopy(base_recipe)
local log_recipe = table.deepcopy(base_recipe)
local cons_recipe = table.deepcopy(base_recipe)
local network_recipe = table.deepcopy(base_recipe)


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
    ['electric-engine-unit'] = 5,
    ['steel-plate'] = 10,
    radar = 2,
    ['selector-combinator'] = 2,
    accumulator = 2,
    ['passive-provider-chest'] = 1,
    ['storage-chest'] = 1,
}

change_recipe(sleeper_recipe, sleeper.name, 'logistic-system',
    inputs{
        ['electric-engine-unit'] = 5,
        ['steel-plate'] = 10,
        ['selector-combinator'] = 1,
        accumulator = 3,
        ['steel-chest'] = 1
    }
)

change_recipe(log_recipe, log_only.name, 'logistic-robotics',
    inputs{
        ['electric-engine-unit'] = 5,
        ['steel-plate'] = 10,
        radar = 1,
        ['selector-combinator'] = 3,
        accumulator = 2,
        ['storage-chest'] = 1,
    }
)


change_recipe(cons_recipe, cons_only.name, 'construction-robotics',
    inputs{
        ['electric-engine-unit'] = 5,
        ['steel-plate'] = 10,
        radar = 2,
        ['selector-combinator'] = 2,
        accumulator = 2,
        ['passive-provider-chest'] = 2,
    }
)


change_recipe(network_recipe, network.name, 'logistic-system',
    inputs{
        ['steel-plate'] = 10,
        radar = 2,
        ['selector-combinator'] = 3,
        accumulator = 3,
        ['requester-chest'] = 2,
    }
)

data:extend{
    sleeper,
    log_only,
    cons_only,
    network,
    sleeper_item,
    log_item,
    cons_item,
    network_item,
    sleeper_recipe,
    log_recipe,
    cons_recipe,
    network_recipe,
}