require 'prelude'

return {
    type = 'recipe',
    name = fns 'burner-mining-drill-fluid',
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = 'item', name = 'burner-mining-drill', amount = 1 },
        { type = 'item', name = 'pipe', amount = 1 },
    },
    results = {
        { type = 'item', name = fns 'burner-mining-drill-fluid', amount = 1 },
    },
}
