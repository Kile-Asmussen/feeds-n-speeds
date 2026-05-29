local fns = require 'fns'
local puts = fns.gadgets.throughputs
local icons = fns.gadgets.icons

data.raw.recipe['burner-mining-drill'].auto_unlocked_by = 'steam-power'

-- Copy burner mining burner_drill and add fluid input on south side (opposite output)
local burner_drill = table.clone(data.raw['mining-drill']['burner-mining-drill'])

local name = 'burner-mining-drill-fluid'

table.merge(burner_drill, {
    name = fns(name),
    minable = table.assign{ 'result', val = fns(name) },
    input_fluid_box = {
        volume = 50,
        filter = 'water',
        production_type = 'input',
        pipe_connections = {
            {
                direction = defines.direction.north,
                flow_direction = 'input',
                position = {0.5, -0.5},
            },
        },
        pipe_covers = pipecoverspictures(),
    },
    icon = utils.null,
    icons = icons{ type = 'entity',
        'icons/burner-mining-drill.png',
        { 'icons/water.png', size='small', dir='bl' },
    },
})

local burner_drill_item = table.clone(data.raw.item['burner-mining-drill'])

table.merge(burner_drill_item, {
    name = fns(name),
    place_result = name,
    icons = table.clone(burner_drill.icons),
    icon = utils.null,
    order = 'a[items]-a[burner-mining-drill]-b[fluid]',
})

local burner_drill_recipe = {
    type = 'recipe',
    name = fns(name),
    auto_unlocked_by = fns 'wet-drilling',
    enabled = false,
    energy_required = 2.0,
    ingredients = puts{ ['burner-mining-drill'] = 1, ['pipe'] = 1 },
    results = puts{ [name] = 1 },
}

local protos = {
    burner_drill,
    burner_drill_item,
    burner_drill_recipe,
}