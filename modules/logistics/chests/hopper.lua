
local fns = require 'fns'
local gadgets = require 'gadgets'

local hopper = 
table.merge(table.clone(data.raw.container['steel-chest']), {
    type = 'proxy-container',
    name = fns 'hopper',
    icon = '__FeedsNSpeeds__/graphics/icons/hopper.png',
    picture = table.assign{ 'layers', 1, 'filename',
        val = '__FeedsNSpeeds__/graphics/entity/hopper.png' },
})

local item =
table.merge(table.clone(data.raw.item['steel-chest']), {
    name = fns 'hopper',
    place_result = fns 'hopper',
})

local recipe =
table.merge(table.clone(data.raw.recipe['steel-chest']), {
    name = fns 'hopper',
    auto_unlock_by = 'automation-1',
    ingredients = gadgets.throughputs{ ['steel-chest'] = 1, ['long-handed-inserter'] = 1 },
    results = table.assign{ 1, 'name', val = fns 'hopper' },
})

data:extend{ hopper, item, recipe }