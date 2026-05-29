local fns = require 'fns'
local puts = fns.gadgets.throughputs

local rails = {
    table.clone(data.raw.recipe.rail),
    table.clone(data.raw.recipe.rail),
    table.clone(data.raw.recipe.rail)
}

data.raw.recipe.rail.ingredients = puts{
    ['stone'] = 8, ['iron-stick'] = 3, ['steel-plate'] = 1
}

local function rail_icons(name)
    return fns.gadgets.icons{
        type = 'recipe',
        { data.raw['rail-planner'].rail.icon },
        { data.raw.item[name].icon, size='small', dir='tl' },
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
        icons = rail_icons('stone-brick'),
    },
    { 
        name = fns 'rail-3',
        order = 'a[rail]-a[rail]-d[refined-concrete]',
        auto_unlocked_by = fns 'concrete-rail',
        ingredients = puts{ ['refined-concrete'] = 1, ['steel-plate'] = 1 },
        allow_productivity = true,
        icons = rail_icons('stone-brick'),
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
        {
            icon = '__base__/graphics/technology/railway.png',
            icon_size = 256,
        },
        {
            icon = '__base__/graphics/technology/concrete.png',
            icon_size = 256,
            scale = 0.33,
            shift = { 25, 25 },
        },
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
