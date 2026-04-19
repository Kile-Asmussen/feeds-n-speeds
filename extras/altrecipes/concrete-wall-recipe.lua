require 'prelude'

return {
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
}
