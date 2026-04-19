

require 'prelude'

return {
    enabled = false,
    icons = {
        { icon = '__base__/graphics/icons/rail.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/concrete.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, 8 },
        },
    },
    order = 'a[rail]-a[rail]-c[concrete]',
    ingredients = {
        { amount = 2, name = 'concrete', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    },
    name = fns 'rail-2',
    results = {
        { amount = 2, name = 'rail', type = 'item' }
    },
    type = 'recipe'
}
