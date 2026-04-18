require 'prelude'

return {
    type = 'technology',
    name = fns 'wet-drilling',
    icons = {
        {
            icon = '__base__/graphics/technology/steam-power.png',
            icon_size = 256,
        },
        {
            icon = '__base__/graphics/technology/mining-productivity.png',
            icon_size = 256,
        },
    },
    effects = {
        {
            type = 'mining-with-fluid',
            modifier = true,
        },
        {
            type = 'unlock-recipe',
            recipe = fns 'burner-mining-drill-fluid',
        },
    },
    research_trigger = {
        type = 'craft-fluid',
        fluid = 'water',
        count = 100,
    },
}
