require 'prelude'

return {
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    icons = {
        {
            icon = '__base__/graphics/technology/research-speed.png',
            icon_size = 256
        },
    },
    prerequisites = { 'steam-power' },
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'lab',
        },
        {
            type = 'unlock-recipe',
            recipe = 'transport-belt',
        },
        {
            type = 'unlock-recipe',
            recipe = 'inserter',
        },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'steam-engine',
        amount = 2
    },
}