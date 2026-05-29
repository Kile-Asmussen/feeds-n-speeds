
local fns = require 'fns'
local puts = fns.gadgets.throughputs

local hopper =
table.merge(table.clone(data.raw.container['steel-chest']), {
    type = 'proxy-container',
    name = fns 'hopper',
    localised_name = nil,
    icon = '__FeedsNSpeeds__/graphics/icons/hopper.png',
    picture = table.assign{ 'layers', 1, 'filename',
        val = '__FeedsNSpeeds__/graphics/entity/hopper.png' },
})

local item =
table.merge(table.clone(data.raw.item['steel-chest']), {
    name = fns 'hopper',
    localised_name = nil,
    icon = '__FeedsNSpeeds__/graphics/icons/hopper.png',
    icons = nil,
    place_result = fns 'hopper',
})

local recipe = table.merge(table.clone(data.raw.recipe['steel-chest']), {
    name = fns 'hopper',
    auto_unlock_by = 'automation',
    ingredients = puts{ ['steel-chest'] = 1, ['long-handed-inserter'] = 1 },
    results = puts{ [fns 'hopper'] = 1 },
})

data:extend{ hopper, item, recipe }