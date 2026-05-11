require 'prelude'

return {
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
    effects = {
        { type = 'unlock-recipe', recipe = fns 'stone-furnace' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'stone-brick',
        count = 10,
    },
}
