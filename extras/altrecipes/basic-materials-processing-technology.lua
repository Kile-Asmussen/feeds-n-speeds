require 'prelude'

return {
    type = 'technology',
    name = fns 'basic-materials-processing',
    icon = '__base__/graphics/icons/stone-furnace.png',
    icon_size = 64,
    effects = {
        { type = 'unlock-recipe', recipe = fns 'stone-furnace' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'stone-brick',
        count = 10,
    },
}
