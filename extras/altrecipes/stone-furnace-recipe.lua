require 'prelude'

return {
    enabled = true,
    order = 'a[stone-furnace]-b[raw-stone]',
    ingredients = {
        { amount = 20, name = 'stone', type = 'item' },
    },
    name = fns 'stone-furnace',
    results = {
        { amount = 1, name = 'stone-furnace', type = 'item' }
    },
    type = 'recipe'
}