require 'prelude'

return {
    {
        type = "technology",
        name = fns 'textplates-glass',
        effects = {
            { type='unlock-recipe', recipe='textplate-small-glass' },
            { type='unlock-recipe', recipe='textplate-large-glass' },
        },
        research_trigger = { type='mine-entity', entity='stone' },
        icon = "__textplates__/graphics/entity/glass/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.glass-C"} },
        hidden = true,
    },

    {
        type = "technology",
        name = fns 'textplates-iron',
        effects = {
            { type='unlock-recipe', recipe='textplate-small-iron' },
            { type='unlock-recipe', recipe='textplate-large-iron' },
        },
        research_trigger = { type='craft-item', item='iron-plate', amount=1 },
        icon = "__textplates__/graphics/entity/iron/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.iron-C"} },
        hidden = true,
    },

    {
        type = "technology",
        name = fns 'textplates-copper',
        effects = {
            { type='unlock-recipe', recipe='textplate-small-copper' },
            { type='unlock-recipe', recipe='textplate-large-copper' },
        },
        research_trigger = { type='craft-item', item='copper-plate', amount=1 },
        icon = "__textplates__/graphics/entity/copper/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.copper-C"} },
        hidden = true,
    },

    {
        type = "technology",
        name = fns 'textplates-stone',
        effects = {
            { type='unlock-recipe', recipe='textplate-small-stone' },
            { type='unlock-recipe', recipe='textplate-large-stone' },
        },
        research_trigger = { type='craft-item', item='stone-brick', amount=1 },
        icon = "__textplates__/graphics/entity/stone/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.stone-C"} },
        hidden = true,
    }
}