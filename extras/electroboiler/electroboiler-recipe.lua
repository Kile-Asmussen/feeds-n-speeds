require 'prelude'

local name = fns 'electroboiler'

return {
    type = 'recipe',
    name = name,
    enabled = false,
    ingredients = {
        { type = 'item', name = 'stone-furnace', amount = 1 },
        { type = 'item', name = 'pipe', amount = 4 },
        { type = 'item', name = 'electronic-circuit', amount = 2 },
    },
    results = {
        { type = 'item', name = name, amount = 1 },
    },
}
