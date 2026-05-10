require 'prelude'

return function()
    table.insert(
        data.raw['simple-entity']['huge-rock'].minable.results,
        {
            type = 'item', name = 'iron-ore',
            amount_min = 19, amount_max = 25
        }
    )

    table.insert(
        data.raw['simple-entity']['big-sand-rock'].minable.results,
        {
            type = 'item', name = 'copper-ore',
            amount_min = 5, amount_max = 8,
        }
    
    )
end