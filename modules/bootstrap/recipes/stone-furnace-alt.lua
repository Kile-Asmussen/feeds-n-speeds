--! data: alternate recipe for stone furnaces
local fns = require 'fns'
local table = fns.table
local puts = fns.gadgets.throughputs
local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

local old_recipe = data.raw.recipe['stone-furnace']

table.merge(old_recipe, {
    ingredients = puts{ stone = 20 },
    __del = 'icon',
    icons = {
        icon('icons/stone-furnace.png', 'recipe'),
        floating_icon('topleft', 'icons/stone.png'),
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
    icons = {
        icon('icons/stone-furnace.png', 'recipe'),
        floating_icon('topleft', 'icons/stone-brick.png'),
    },
    ingredients = puts{ ['stone-brick'] = 5 },
    results = puts{ ['stone-furnace'] = 1 },
    allow_auto_recycle = false
}

local bmp = {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = {
        icon('entity/stone-furnace/stone-furnace.png', { icon_size = 146, scale=0.6 }),
        icon('technology/steel-axe.png', 'technology'),
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