--! data: tiny heat-producing machine that uses electricity

local fns = require 'fns'

local mini_reactor = table.merge(table.clone(data.raw.reactor['nuclear-reactor']), {
    name = fns 'electric-heater',

    icon = fns.utils.null,
    icons = fns.gadgets.icons{
        { "icons/small-lamp.png", tint = { 1, 0, 0 } } ,
        { "icons/heat-pipe.png", size="medium", dir="b" }
    },

    minable = { mining_time = 1.0, result = fns 'electric-heater' },
    max_health = 200,
    collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },

    surface_conditions = {
        {
            property = 'magenetic-field',
            min = 25,
        },
        {
            property = 'pressure-field',
            min = 500,
            max = 2000,
        }
    },

    corpse = 'heat-pipe-remnants',

    working_sound = fns.utils.null,

    consumption = "10MW",

    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = "10MW",
    },

    heat_buffer = {
        max_temperature = 500,
        specific_heat = "4MJ",
        max_transfer = "4GW",
        connections = {
            { position = { 0, -0.5 }, direction = defines.direction.north },
            { position = { 0.5,  0 }, direction = defines.direction.east },
            { position = { 0,  0.5 }, direction = defines.direction.south },
            { position = { -0.5, 0 }, direction = defines.direction.west },
        },
    },

    picture = {
        layers = {
            {
                filename = "__base__/graphics/entity/small-lamp/lamp.png",
                width = 83,
                height = 70,
                scale = 0.5,
                shift = { 0.0078125, 0.09375 },
                priority = "high",
                tint = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
            },
            {
                filename = "__base__/graphics/entity/small-lamp/lamp-shadow.png",
                width = 76,
                height = 47,
                scale = 0.5,
                shift = { 0.125, 0.1484375 },
                priority = "high",
                draw_as_shadow = true,
            },
        },
    },
})

local mini_reactor_item = table.merge(table.clone(data.raw.item['small-lamp']), {
    type = "item",
    name = mini_reactor.name,
    icons =  table.clone(mini_reactor.icons),
    stack_size = 10,
    place_result = mini_reactor.name,
})

local puts = fns.gadgets.throughputs

local mini_reactor_recipe = {
    type = "recipe",
    name = mini_reactor.name,
    auto_unlocked_by = mini_reactor.name,
    ingredients = puts{ ['refined-concrete'] = 10, ['heat-pipe'] = 4 },
    results = puts{ [mini_reactor.name] = 1 },
    energy_required = 5,
}

local mini_reactor_tech = {
    type = 'technology',
    name = mini_reactor.name,
    prerequisites = { 'electric-energy-accumulators', 'advanced-material-processing-2' },
    unit = {
        count = 200,
        ingredients = { 
            { 'automation-science-pack', 1 }, 
            { 'logistic-science-pack', 1 }, 
            { 'chemical-science-pack', 1 }, 
        },
    },
    icons = fns.gadgets.icons{
        type = 'technology',
        'technology/steam-power.png',
        'technology/electric-energy-distribution-1.png',
    }
}

data.raw.recipe['heat-pipe'].auto_unlocked_by = mini_reactor.name

local boiler = data.raw.boiler.boiler

local heat_boiler = table.merge(table.clone(data.raw.boiler['heat-exchanger']), {
    name = fns 'heat-boiler',
    energy_consumption = boiler.energy_consumption,
    target_temperature = boiler.target_temperature,
    icon = utils.null,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__core__/graphics/arrows/heat-exchange-indicator.png',
            floating = true,
            icon_size = 48,
            scale = 0.5,
            shift = { -6, 6 },
            tint = { r = 0, g = 1, b = 0 },
        }
    },
})

local heat_boiler_item = table.merge(table.clone(data.raw.item.boiler), {
    type = "item",
    name = heat_boiler.name,
    icons = table.clone(heat_boiler.icons),
    stack_size = 10,
    place_result = heat_boiler.name,
})

local heat_boiler_recipe = {
    type = "recipe",
    name = heat_boiler.name,
    auto_unlocked_by = mini_reactor_tech.name,
    ingredients = puts{ ['boiler'] = 1, ['heat-pipe'] = 1 },
    results = puts{ [mini_reactor.name] = 1 },
    energy_required = 2,
}


data:extend{ mini_reactor, mini_reactor_item, mini_reactor_recipe, mini_reactor_tech, heat_boiler, heat_boiler_item, heat_boiler_recipe }
