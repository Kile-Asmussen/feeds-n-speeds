require 'prelude'

return {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icons = {
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.50,
            shift = { -25, -10 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.50,
            shift = { 0, 0 }
        },
        {
            icon = '__base__/graphics/icons/stone-furnace.png',
            icon_size = 64,
            scale = 0.50,
            shift = { 25 , 10 }
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
