require 'prelude'

return {
    {
        enabled = false,
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
    },
    {
        enabled = false,
        ingredients = {
            { amount = 2, name = 'concrete', type = 'item' },
            { amount = 1, name = 'steel-plate', type = 'item' }
        },
        name = fns 'rail-2',
        results = {
            { amount = 2, name = 'rail', type = 'item' }
        },
        type = 'recipe'
    },
    {
        enabled = false,
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
}