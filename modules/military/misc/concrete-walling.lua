
prototype(
    assoc{
        type = 'recipe',
        name = fns 'concrete-wall',
        enabled = false,
        order = 'a[stone-wall]-b[concrete]',
        icons = array{
            assoc{
                icon = '__base__/graphics/icons/wall.png',
                icon_size = 64,
            },
            assoc{
                icon = '__base__/graphics/icons/concrete.png',
                icon_size = 64,
                scale = 0.25,
                shift = {-8, -8},
            },
        },
        ingredients = array{
            assoc{ amount = 5, name = 'concrete', type = 'item' },
        },
        results = array{
            assoc{ amount = 1, name = 'stone-wall', type = 'item' }
        },
    },
    assoc{
        type = 'technology',
        name = fns 'concrete-wall',
        icons = array{
            assoc{
                icon = '__base__/graphics/technology/stone-wall.png',
                icon_size = 256,
            },
            assoc{
                icon = '__base__/graphics/technology/concrete.png',
                icon_size = 256,
                scale = 0.33,
                shift = {25, 25},
            },
        },
        prerequisites = array{
            'stone-wall',
            'concrete',
        },
        effects = array{
            assoc{ type = 'unlock-recipe', recipe = fns 'concrete-wall' },
        },
        research_trigger = assoc{
            type = 'craft-item',
            item = 'concrete',
            count = 100,
        },
    }
)