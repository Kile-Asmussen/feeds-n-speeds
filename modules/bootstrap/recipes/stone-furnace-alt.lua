
local old_recipe = data.raw.recipe['stone-furnace']

old_recipe.energy_required = 6.0
old_recipe.icons = {
    {
        icon = '__base__/graphics/icons/stone-furnace.png',
        icon_size = 64,
    },
    {
        icon = '__base__/graphics/icons/stone.png',
        icon_size = 64,
        scale = 0.25,
        shift = {-8, -8},
    },
}

old_recipe.ingredients = {
    { amount = 10, name = 'stone', type = 'item' }
}

data.raw.recipe['stone-brick'].auto_unlocked_by = fns 'basic-materials-processing'

local new_recipe = {
    type = 'recipe',
    name = fns 'stone-furnace',
    auto_unlocked_by = fns 'basic-materials-processing',
    localised_name = {"entity-name.stone-furnace"},
    order = 'a[stone-furnace]-b[stone-brick]',
    energy_required = 3.0,
    icons = {
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/stone-brick.png',
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    ingredients = {
        { amount = 5, name = 'stone-brick', type = 'item' },
    },
    results = {
        { amount = 1, name = 'stone-furnace', type = 'item' }
    },
    allow_auto_recycle = false
}


local bmp = {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = {
        {
            icon = '__base__/graphics/entity/stone-furnace/stone-furnace.png',
            icon_size = 146,
            float=true,
            scale = 0.5,
            shift = { 0, -20 }
        },
        {
            icon = '__base__/graphics/technology/steel-axe.png',
            icon_size = 256,
            float=true,
            scale = 0.33,
            shift = { 0, 5 }
        },        
    },
    research_trigger = {
        type = 'craft-item',
        item = 'stone-furnace',
        count = 3,
    }
}

data:extend{new_recipe, bmp}