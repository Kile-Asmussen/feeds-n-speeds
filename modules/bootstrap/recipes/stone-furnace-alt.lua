-- data: alternate recipe for stone furnaces
local fns = require 'fns'
local puts = fns.gadgets.throughputs
local icons = fns.gadgets.icons

local old_recipe = data.raw.recipe['stone-furnace']

table.merge(old_recipe, {
    ingredients = puts{ stone = 20 },
    icon = fns.utils.null,
    icons = icons{
        type = 'recipe',
        'icons/stone-furnace.png',
        { 'icons/stone.png', size = 'tiny', dir = 'tl' },
    },
    energy_required = 6.0,
})

local recipes = data.raw.recipe

recipes['stone-brick'].auto_unlocked_by = fns 'basic-materials-processing'


local new_recipe = {
    type = 'recipe',
    name = fns 'stone-furnace',
    auto_unlocked_by = fns 'basic-materials-processing',
    localised_name = {"entity-name.stone-furnace"},
    order = 'a[stone-furnace]-b[stone-brick]',
    energy_required = 3.0,
    icons = icons{
        type = 'recipe',
        'icons/stone-furnace.png',
        { 'icons/stone-brick.png', size = 'tiny', dir = 'tl' },
    },
    ingredients = puts{ ['stone-brick'] = 5 },
    results = puts{ ['stone-furnace'] = 1 },
    allow_auto_recycle = false
}

local bmp = {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = icons{
        type = 'technology',
        { 'entity/stone-furnace/stone-furnace.png', icon_size = 146 },
        'technology/steel-axe.png',
    },
    research_trigger = {
        type = 'craft-item',
        item = 'stone-furnace',
        count = 3,
    }
}

data:extend{
    new_recipe,
    bmp,
}