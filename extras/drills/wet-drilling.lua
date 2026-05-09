require 'prelude'

return {{
    type = 'technology',
    name = fns 'wet-drilling',
    order = 'a-b-b',  -- after steam-power (a-b-a)
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
    prerequisites = { 'steam-power' },
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
        type = 'craft-item',
        item = 'offshore-pump',
        amount = 1,
    },
}}
