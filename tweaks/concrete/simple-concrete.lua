require 'prelude'

-- Simple concrete: same inputs as vanilla, lower output (5 vs 10)
-- Assembly machine craftable (crafting-with-fluid)
-- No refined concrete equivalent in this recipe chain

return {
    type = 'recipe',
    name = fns 'simple-concrete',
    category = 'crafting-with-fluid',
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = 'item', name = 'stone-brick', amount = 6 },
        { type = 'item', name = 'iron-stick', amount = 1 },
        { type = 'fluid', name = 'water', amount = 100 },
    },
    results = {
        { type = 'item', name = 'concrete', amount = 8 },
    },
    order = 'b[concrete]-a[simple]',
}