require 'prelude'

return assoc{
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
    },
    research_trigger = assoc{
        type = 'craft-item',
        item = 'stone-furnace',
        count = 3,
    }
}

