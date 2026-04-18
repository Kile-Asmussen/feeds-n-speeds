
require 'prelude'

return {
    enabled = false,
    icons = {
        { icon = '__base__/graphics/icons/rail.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/refined-concrete.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, 8 },
        },
    },
    order = 'a[rail]-d[rail-3]',
    ingredients = {
        { amount = 1, name = 'refined-concrete', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    },
    name = fns 'rail-3',
    results = {
        { amount = 3, name = 'rail', type = 'item' }
    },
    type = 'recipe'
}