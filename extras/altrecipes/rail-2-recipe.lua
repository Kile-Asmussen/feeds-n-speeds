

require 'prelude'

return {
    enabled = false,
    order = 'a[rail]-c[rail-2]',
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
