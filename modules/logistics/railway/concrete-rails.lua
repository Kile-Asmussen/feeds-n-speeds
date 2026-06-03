--! data: extra better recipes for rails using concrete
local fns = require 'fns'
local table = fns.table
local puts = fns.gadgets.throughputs

local rails = {
    table.deepcopy(data.raw.recipe.rail),
    table.deepcopy(data.raw.recipe.rail),
    table.deepcopy(data.raw.recipe.rail)
}

data.raw.recipe.rail.ingredients = puts{
    ['stone'] = 8, ['iron-stick'] = 3, ['steel-plate'] = 1
}

local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

local function rail_icons(name)
    return {
        icon(data.raw['rail-planner'].rail.icon, 'recipe'),
        floating_icon('topleft', data.raw.item[name].icon),
    }
end

local merge = fns.table.merge

merge(rails, { __rec = true,
    {
        name = fns 'rail-1',
        order = 'a[rail]-a[rail]-b[stone-brick]',
        auto_unlocked_by = 'railway',
        ingredients = puts{ ['stone-brick'] = 4, ['iron-stick'] = 2, ['steel-plate'] = 1 },
        icons = rail_icons('stone-brick'),
    },
    { 
        name = fns 'rail-2',
        order = 'a[rail]-a[rail]-c[concrete]',
        auto_unlocked_by = fns 'concrete-rail',
        ingredients = puts{ ['concrete'] = 3, ['steel-plate'] = 1 },
        icons = rail_icons('concrete'),
    },
    { 
        name = fns 'rail-3',
        order = 'a[rail]-a[rail]-d[refined-concrete]',
        auto_unlocked_by = fns 'concrete-rail',
        ingredients = puts{ ['refined-concrete'] = 1, ['steel-plate'] = 1 },
        allow_productivity = true,
        icons = rail_icons('refined-concrete'),
    }
})

merge(rails, {
    __rec = true,
    [{1,2,3}] = {
        icon = fns.utils.null,
        allow_auto_recycle = false,
        localised_name = {"item-name.rail"}
    }
})

data:extend(rails)

data:extend{{
    type = 'technology',
    name = fns 'concrete-rail',
    icons = {
        icon('technology/railway.png', 'technology'),
        floating_icon('bottomleft', 'technology/concrete.png', 'technology'),
    },
    prerequisites = {
        'concrete',
        'railway',
    },
    effects = {},
    research_trigger = {
        type = 'craft-item',
        item = 'rail',
        count = 1000,
    },
}}
