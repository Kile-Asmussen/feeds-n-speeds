require 'prelude'

local old_recipe = data.raw.recipe['stone-furnace']

old_recipe.energy_required = 6.0
old_recipe.icons = array{
    assoc{
        icon = '__base__/graphics/icons/stone-furnace.png',
        icon_size = 64,
    },
    assoc{
        icon = '__base__/graphics/icons/stone.png',
        icon_size = 64,
        scale = 0.25,
        shift = {-8, -8},
    },
}

old_recipe.ingredients = {
    { amount = 10, name = 'stone', type = 'item' }
}


local new_recipe = assoc{
    type = 'recipe',
    name = fns 'stone-furnace',
    unlocked_by = fns 'basic-materials-processing',
    localised_name = array{"entity-name.stone-furnace"},
    order = 'a[stone-furnace]-b[stone-brick]',
    energy_required = 3.0,
    icons = array{
        assoc{
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
        },
        assoc{
            icon = '__base__/graphics/icons/stone-brick.png',
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    ingredients = array{
        assoc{ amount = 5, name = 'stone-brick', type = 'item' },
    },
    results = array{
        assoc{ amount = 1, name = 'stone-furnace', type = 'item' }
    },
    allow_auto_recycle = false
}


local bmp = assoc{
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = array{
        assoc{
            icon = '__base__/graphics/entity/stone-furnace/stone-furnace.png',
            icon_size = 146,
            float=true,
            scale = 0.5,
            shift = array{ 0, -20 }
        },
        assoc{
            icon = '__base__/graphics/technology/steel-axe.png',
            icon_size = 256,
            float=true,
            scale = 0.33,
            shift = array{ 0, 5 }
        },        
    },
    effects = array{
        assoc{ type = 'unlock-recipe', recipe = fns 'stone-furnace' },
        assoc{ type = 'unlock-recipe', recipe = 'stone-brick' },
    },
    research_trigger = assoc{
        type = 'craft-item',
        item = 'stone-furnace',
        count = 3,
    }
}

prototype(new_recipe, bmp)