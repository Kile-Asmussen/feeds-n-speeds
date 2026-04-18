require 'prelude'

return {
    type = 'technology',
    name = fns 'concrete-rail',
    icon = '__base__/graphics/technology/railway.png',
    icon_size = 256,
    prerequisites = {
        'concrete',
        'railway',
    },
    effects = {
        { type = 'unlock-recipe', recipe = fns 'rail-1' },
        { type = 'unlock-recipe', recipe = fns 'rail-2' },
        { type = 'unlock-recipe', recipe = fns 'rail-3' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'refined-concrete',
        count = 100,
    },
}
