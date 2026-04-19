require 'prelude'

return {
    type = 'recipe',
    name = fns 'water-pump',
    enabled = true,
    category = 'crafting-with-fluid',
    energy_required = 1,
    ingredients = {
        { type = 'fluid', name = 'water', amount = 100 },
    },
    results = {
        { type = 'fluid', name = 'water', amount = 100 },
    },
}
