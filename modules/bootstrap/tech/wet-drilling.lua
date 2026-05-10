require 'prelude'

return assoc{
    type = 'technology',
    name = fns 'wet-drilling',
    order = 'a-b-b',  -- after steam-power (a-b-a)
    icons = array{
        assoc{
            icon = '__base__/graphics/technology/steam-power.png',
            icon_size = 256,
        },
        assoc{
            icon = '__base__/graphics/technology/mining-productivity.png',
            icon_size = 256,
        },
    },
    prerequisites = array{ 'steam-power' },
    effects = array{
        assoc{
            type = 'mining-with-fluid',
            modifier = true,
        },
        assoc{
            type = 'unlock-recipe',
            recipe = fns 'burner-mining-drill-fluid',
        },
    },
    research_trigger = assoc{
        type = 'craft-item',
        item = 'offshore-pump',
        amount = 1,
    },
}
