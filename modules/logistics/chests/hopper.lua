--! data: hopper that links to steel chests
local fns = require 'fns'
local table = fns.table
local puts = fns.gadgets.throughputs

local hopper =
table.merge(table.deepcopy(data.raw.container[fns 'steel-chest']), {
    __rec = true,
    type = 'proxy-container',
    name = fns 'hopper',
    icon_draw_specification = { scale = 0.4 },
    localised_name = fns.utils.null,
    draw_inventory_content = false,
    icon = '__FeedsNSpeeds__/graphics/icons/hopper.png',
    picture = table.assign{ 'layers', 1, 'filename',
        val = '__FeedsNSpeeds__/graphics/entity/hopper.png' },
    minable = { result = fns 'hopper' }
})

local item =
table.merge(table.deepcopy(data.raw.item['steel-chest']), {
    name = fns 'hopper',
    localised_name = fns.utils.null,
    icon = '__FeedsNSpeeds__/graphics/icons/hopper.png',
    icons = nil,
    place_result = fns 'hopper',
})

local recipe = table.merge(table.deepcopy(data.raw.recipe['steel-chest']), {
    name = fns 'hopper',
    localised_name = fns.utils.null,
    auto_require_pavement = 'stone-path',
    auto_unlock_by = 'automation',
    ingredients = puts{ ['steel-chest'] = 1, ['long-handed-inserter'] = 1 },
    results = puts{ [fns 'hopper'] = 1 },
})

data:extend{ hopper, item, recipe }