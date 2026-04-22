require 'prelude'

return {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = {
        {
            icon = '__base__/graphics/entity/stone-furnace/stone-furnace-shadow.png',
            icon_size = 64,
            scale = 0.40,
            shift = { -25, -20 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { -25, -20 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { 0, -15 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { 25 , -10 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { -25, 10 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { 0, 15 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.40,
            shift = { 25 , 20 }
        },
    },

    effects = {
        { type = 'unlock-recipe', recipe = fns 'stone-furnace' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'stone-brick',
        count = 10,
    },
}
