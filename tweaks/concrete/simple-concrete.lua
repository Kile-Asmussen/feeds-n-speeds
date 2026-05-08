require 'prelude'

-- Simple concrete: same inputs as vanilla, lower output (5 vs 10)
-- Assembly machine craftable (crafting-with-fluid)
-- No refined concrete equivalent in this recipe chain

return {
    type = 'recipe',
    name = fns 'simple-concrete',
    category = 'crafting-with-fluid',
    -- localised_description = {""},
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    },
    icons = {
        {
            icon = '__base__/graphics/icons/concrete.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/stone.png',
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    results = {
        { type = 'item', name = 'concrete', amount = 5 },
    },
    order = 'b[concrete]-a[simple]',
}