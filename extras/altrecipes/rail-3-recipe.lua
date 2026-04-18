
require 'prelude'

return {
    enabled = false,
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