require 'prelude'

return {
    type = 'recipe',
    name = fns 'electric-mining-drill-fluid',
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = 'item', name = 'electric-mining-drill', amount = 1 },
        { type = 'item', name = 'pipe', amount = 3 },
    },
    results = {
        { type = 'item', name = fns 'electric-mining-drill-fluid', amount = 1 },
    },
}
