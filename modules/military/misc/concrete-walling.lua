local fns = require 'fns'
local puts = fns.gadgets.throughputs
local icons = fns.gadgets.icons

data:extend{
    {
        type = 'recipe',
        name = fns 'concrete-wall',
        enabled = false,
        order = 'a[stone-wall]-b[concrete]',
        icons = icons{
            'icons/wall.png',
            { 'icons/concrete.png', size = 'small', scale = 0.25, dir = 'tr', },
        },
        auto_unlocked_by = fns 'concrete-wall',
        ingredients = puts{ ['concrete'] = 5 },
        results = puts{ ['stone-wall'] = 1 },
    },
    {
        type = 'technology',
        name = fns 'concrete-wall',
        icons = icons{
            type = 'technology',
            'technology/stone-wall.png',
            { 'technology/concrete.png', size = 'small', dir = 'br', },
        },
        prerequisites = { 'stone-wall', 'concrete', },
        effects = {},
        research_trigger = {
            type = 'craft-item',
            item = 'concrete',
            count = 100,
        },
    }
}