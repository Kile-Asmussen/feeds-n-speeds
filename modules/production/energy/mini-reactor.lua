-- Draft: 1x1 electric reactor using iron chest graphics tinted red
-- NOTE: Reactors always output heat, so this still needs heat pipes to be useful.

local mini_reactor = {
    type = "reactor",
    name = "feeds-n-speeds-mini-reactor",
    icon = "__base__/graphics/icons/small-lamp.png",
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 0.5, result = "feeds-n-speeds-mini-reactor" },
    max_health = 200,
    collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },

    consumption = "1MW",

    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = "1MW",
    },

    heat_buffer = {
        max_temperature = 1000,
        specific_heat = "1MJ",
        max_transfer = "1MW",
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
}

local mini_reactor_item = {
    type = "item",
    name = "feeds-n-speeds-mini-reactor",
    icon = "__base__/graphics/icons/small-lamp.png",
    stack_size = 10,
    place_result = "feeds-n-speeds-mini-reactor",
}

local mini_reactor_recipe = {
    type = "recipe",
    name = "feeds-n-speeds-mini-reactor",
    ingredients = {
        { type = "item", name = "iron-plate", amount = 10 },
    },
    results = {
        { type = "item", name = "feeds-n-speeds-mini-reactor", amount = 1 },
    },
    energy_required = 1,
}

data:extend{ mini_reactor, mini_reactor_item, mini_reactor_recipe }
