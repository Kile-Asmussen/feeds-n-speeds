require 'prelude'

return {
    type = 'technology',
    name = fns 'sulfur-drilling',
    icons = { 
        {
            icon = '__base__/graphics/technology/sulfur-processing.png',
            icon_size = 256,
            scale=0.5
        },
        {
            icon = '__base__/graphics/technology/mining-productivity.png',
            icon_size = 256,
            scale=0.5
        },
    },
    prerequisites = { 'sulfur-processing', 'electric-mining-drill' },
    effects = {
        {
            type = 'mining-with-fluid',
            modifier = true,
        },
    },
    unit = {
        count = 50,
        time = 30,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
        },
    },
}
