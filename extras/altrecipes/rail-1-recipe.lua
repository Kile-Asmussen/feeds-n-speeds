require 'prelude'

return {
    enabled = false,
    icons = {
        { icon = '__base__/graphics/icons/rail.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/stone-brick.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, 8 },
        },
    },
    order = 'a[rail]-b[rail-1]',
    ingredients = {
        { amount = 1, name = 'stone-brick', type = 'item' },
        { amount = 1, name = 'iron-stick', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    },
    name = fns 'rail-1',
    results = {
        { amount = 2, name = 'rail', type = 'item' }
    },
    type = 'recipe'
}