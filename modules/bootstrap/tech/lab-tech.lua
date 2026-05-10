require 'prelude'

return assoc{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    icons = array{
        assoc{
            icon = '__base__/graphics/technology/research-speed.png',
            icon_size = 256
        },
    },
    prerequisites = array{ 'steam-power' },
    effects = array{
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
    research_trigger = assoc{
        type = 'craft-item',
        item = 'steam-engine',
        amount = 2
    },
}