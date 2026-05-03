require 'prelude'

-- Better recipe using bricks (enabled state set by coordinator based on earlygame)
return {
    type = 'recipe',
    name = fns 'stone-furnace',
    localised_name = {"", {"item-name.stone-furnace"}},
    order = 'a[stone-furnace]-b[stone-brick]',
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
}