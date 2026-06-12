--! data: alternate higher-yield recipe for walls
local fns = require 'fns'
local puts = fns.gadgets.throughputs
local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

data:extend{
    {
        type = 'recipe',
        name = fns 'concrete-wall',
        enabled = false,
        order = 'a[stone-wall]-b[concrete]',
        icons = {
            icon('icons/wall.png'),
            floating_icon('topright', 'icons/concrete.png', { scale = 0.30, tint = { 0, 0, 0, 0.6 } }),
            floating_icon('topright', 'icons/concrete.png'),
        },
        auto_unlocked_by = fns 'concrete-wall',
        ingredients = puts{ ['concrete'] = 5 },
        results = puts{ ['stone-wall'] = 1 },
    },
    {
        type = 'technology',
        name = fns 'concrete-wall',
        icons = {
            icon('technology/stone-wall.png', 'technology'),
            floating_icon('bottomleft', 'technology/concrete.png', 'technology'),
        },
        prerequisites = { 'stone-wall', 'concrete', },
        effects = {},
        research_trigger = {
            type = 'craft-item',
            item = 'stone-wall',
            count = 100,
        },
    }
}