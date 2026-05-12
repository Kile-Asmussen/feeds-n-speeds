require 'prelude'

return {
    {
        type = 'recipe',
        name = fns 'concrete-wall',
        enabled = false,
        order = 'a[stone-wall]-b[concrete]',
        icons = {
            {
                icon = '__base__/graphics/icons/wall.png',
                icon_size = 64,
            },
            {
                icon = '__base__/graphics/icons/concrete.png',
                icon_size = 64,
                scale = 0.25,
                shift = {-8, -8},
            },
        },
        ingredients = {
            { amount = 5, name = 'concrete', type = 'item' },
        },
        results = {
            { amount = 1, name = 'stone-wall', type = 'item' }
        },
    },
    {
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
                shift = {25, 25},
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
}