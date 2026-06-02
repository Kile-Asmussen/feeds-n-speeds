--! data: tiny heat-producing machine that uses electricity

local fns = require 'fns'
local table = fns.table

local pipe = data.raw['heat-pipe']['heat-pipe']

local function sh(shift, tbl)
    tbl = table.deepcopy(tbl)
    tbl.shift = shift
    return tbl
end

local mini_reactor = table.merge(table.deepcopy(data.raw.reactor['heating-tower']), {
    name = fns 'electric-heater',

    connection_patches_connected = table.deepcopy{
        sh({ 0, -0.2 }, pipe.connection_sprites.straight_vertical[1]),
        sh({ 0.2, 0 }, pipe.connection_sprites.straight_horizontal[1]),
        sh({ 0, 0.2 }, pipe.connection_sprites.straight_vertical[2]),
        sh({ -0.2, 0 }, pipe.connection_sprites.straight_horizontal[2]),
    },
    connection_patches_disconnected = table.deepcopy{
        sh({ 0, -0.5 }, pipe.connection_sprites.ending_down[1]),
        sh({ 0.6, 0 }, pipe.connection_sprites.ending_left[1]),
        sh({ 0, 0.4 }, pipe.connection_sprites.ending_up[1]),
        sh({ -0.55, 0 }, pipe.connection_sprites.ending_right[1]),
    },
    auto_require_pavement = 'stone-path',

    icon = fns.utils.null,
    icons = fns.gadgets.icons{
        { "icons/small-lamp.png", tint_as_overlay = true, tint = { 1, 0.5, 0.5 } } ,
        { "icons/heat-pipe.png", size="large", dir="b" }
    },

    minable = { mining_time = 1.0, result = fns 'electric-heater' },
    max_health = 200,
    collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },

    surface_conditions = {
        {
            property = 'magnetic-field',
            min = 25,
        },
        {
            property = 'pressure',
            min = 500,
            max = 2000,
        }
    },

    corpse = 'heat-pipe-remnants',

    working_sound = fns.utils.null,

    consumption = "1MW",
    neighbour_bonus = 0,

    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = "10MW",
    },

    heat_buffer = {
        max_temperature = 300,
        specific_heat = "100kJ",
        max_transfer = "1GW",
        connections = {
            { position = { 0, 0 }, direction = defines.direction.north },
            { position = { 0, 0 }, direction = defines.direction.east },
            { position = { 0, 0 }, direction = defines.direction.south },
            { position = { 0, 0 }, direction = defines.direction.west },
        },
    },

    corpse = 'lamp-remnants',
    dying_explosion = 'lamp-explosion',

    meltdown_action = fns.utils.null, -- maybe a hand-grenade?

    working_light_picture = fns.utils.null,

    picture = {
        layers = {
            {
                filename = "__base__/graphics/entity/small-lamp/lamp.png",
                width = 83,
                height = 70,
                scale = 0.5,
                shift = { 0.0078125, 0.09375 - 0.1 }, -- shift up a little?
                priority = "high",
                tint = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
            },
            {
                filename = "__base__/graphics/entity/small-lamp/lamp-shadow.png",
                width = 76,
                height = 47,
                scale = 0.5,
                shift = { 0.125, 0.1484375 }, -- shift up a little?
                priority = "high",
                draw_as_shadow = true,
            },
        },
    },
})

local mini_reactor_item = table.merge(table.deepcopy(data.raw.item['small-lamp']), {
    type = "item",
    name = mini_reactor.name,
    icons =  table.deepcopy(mini_reactor.icons),
    stack_size = 10,
    place_result = mini_reactor.name,
})

local puts = fns.gadgets.throughputs

local mini_reactor_recipe = {
    type = "recipe",
    name = mini_reactor.name,
    auto_unlocked_by = mini_reactor.name,
    ingredients = puts{ ['refined-concrete'] = 5, ['copper-cable'] = 10, ['heat-pipe'] = 1 },
    results = puts{ [mini_reactor.name] = 1 },
    energy_required = 5,
}

local mini_reactor_tech = {
    type = 'technology',
    name = mini_reactor.name,
    prerequisites = { 'electric-energy-accumulators', 'advanced-material-processing-2' },
    unit = {
        time = 20,
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

data:extend{ mini_reactor, mini_reactor_item, mini_reactor_recipe, mini_reactor_tech }
data.raw.recipe['heat-pipe'].auto_unlocked_by = mini_reactor.name



local boiler = data.raw.boiler.boiler
local heat_boiler = table.merge(table.deepcopy(data.raw.boiler['heat-exchanger']), {
    name = fns 'heat-boiler',
    energy_consumption = boiler.energy_consumption,
    target_temperature = boiler.target_temperature,
    energy_source = {
        __merge = true,
        max_temperature = 300,
        min_working_temperature = boiler.target_temperature,
        specific_heat = "100kJ",
        max_transfer = "1GW",
    },
    auto_require_pavement = 'stone-path',
    energy_consumption = "3.6MW",
    icon = fns.utils.null,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__core__/graphics/arrows/heat-exchange-indication.png',
            floating = true,
            icon_size = 48,
            scale = 0.5,
            shift = { -6, 6 },
        }
    },
    pictures = table.deepcopy(data.raw.boiler[fns 'electroboiler'].pictures),
    working_light_picture = fns.utils.null,
})

local heat_boiler_item = table.merge(table.deepcopy(data.raw.item.boiler), {
    type = "item",
    name = heat_boiler.name,
    icons = table.deepcopy(heat_boiler.icons),
    stack_size = 10,
    place_result = heat_boiler.name,
})

local heat_boiler_recipe = {
    type = "recipe",
    name = heat_boiler.name,
    auto_unlocked_by = mini_reactor_tech.name,
    ingredients = puts{ ['boiler'] = 1, ['heat-pipe'] = 1 },
    results = puts{ [heat_boiler.name] = 1 },
    energy_required = 2,
}

data:extend{ heat_boiler, heat_boiler_item, heat_boiler_recipe }

local tank = data.raw['storage-tank']['storage-tank']

local tank_o_sand = table.merge(table.deepcopy(data.raw.reactor['heating-tower']), {
    name = fns 'tank-o-sand',
    minable = table.merge(table.deepcopy(tank.minable), { result = fns 'tank-o-sand' }),
    energy_source = { type = "void" },
    consumption = "0.001W",
    heat_buffer = {
        __merge = true,
        max_temperature = 1000,
        specific_heat = "5MJ",
        max_transfer = "1GW",
        heat_picture = fns.utils.null,
    },
    auto_require_pavement = 'stone-path',
    working_light_picture = fns.utils.null,
    icon = fns.utils.null,
    picture = { layers = {} },
    icons = fns.gadgets.icons{
        { "icons/storage-tank.png" } ,
        { "icons/heat-pipe.png", size="large", dir="b" }
    },
    working_sound = fns.utils.null,
})

tank_o_sand.picture.layers = {
    table.merge(table.deepcopy(tank.pictures.window_background), { shift = { 0, 1 } }),
    tank.pictures.picture.sheets[1],
    tank.pictures.picture.sheets[2],
}

local function pipe_cover(direction, shift)
    local pipes = tank.fluid_box.pipe_covers[direction].layers
    return {
        table.merge(table.deepcopy(pipes[1]), { shift = shift }),
        table.merge(table.deepcopy(pipes[2]), { shift = shift }),
    }
end

table.append(tank_o_sand.picture.layers, pipe_cover('north', { -1, -2 }))
table.append(tank_o_sand.picture.layers, pipe_cover('west', { -2, -1 }))
table.append(tank_o_sand.picture.layers, pipe_cover('east', { 2, 1 }))
table.append(tank_o_sand.picture.layers, pipe_cover('south', { 1, 2 }))

local tank_o_sand_item = table.merge(table.deepcopy(data.raw.item['storage-tank']), {
    type = "item",
    name = tank_o_sand.name,
    icons =  table.deepcopy(tank_o_sand.icons),
    stack_size = 5,
    place_result = tank_o_sand.name,
})

local tank_o_sand_recipe = {
    type = "recipe",
    name = tank_o_sand.name,
    auto_unlocked_by = mini_reactor_tech.name,
    ingredients = puts{ ['storage-tank'] = 1, ['stone'] = 100 },
    results = puts{ [tank_o_sand.name] = 1 },
    energy_required = 5,
}

data:extend{ tank_o_sand, tank_o_sand_item, tank_o_sand_recipe }