require 'prelude'

return {
    type = 'technology',
    name = fns 'concrete-wall',
    icons = {
        {
            icon = '__base__/graphics/technology/stone-wall.png',
            icon_size = 256,
        },
        {
            icon = '__base__/graphics/technology/concrete.png',
            icon_size = 256,
            scale = 0.33,
            shift = {35, 35},
        },
    },
    prerequisites = {
        'stone-wall',
        'concrete',
    },
    effects = {
        { type = 'unlock-recipe', recipe = fns 'concrete-wall' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'concrete',
        count = 100,
    },
}
