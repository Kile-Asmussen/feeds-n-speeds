require 'prelude'

return {
    type = 'technology',
    name = fns 'sulfur-drilling',
    icon = '__base__/graphics/technology/sulfur-processing.png',
    icon_size = 256,
    prerequisites = { 'sulfur-processing' },
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
