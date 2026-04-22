require 'prelude'

return {
    {
        type = "technology",
        name = fns 'textplates-wood',
        effects = {
            { type='unlock-recipe', recipe='textplates-wood'}
        },
        research_trigger = {
            { type='mine-entity', entity='tree' }
        },
        icon = "__textplates__/graphics/entity/wood/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.wood-C"} }
    },

    {
        type = "technology",
        name = fns 'textplates-glass',
        effects = {
            { type='unlock-recipe', recipe='textplates-glass'}
        },
        research_trigger = {
            { type='mine-entity', entity='stone' }
        },
        icon = "__textplates__/graphics/entity/glass/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.glass-C"} }
    },

    {
        type = "technology",
        name = fns 'textplates-iron',
        effects = {
            { type='unlock-recipe', recipe='textplates-iron'}
        },
        research_trigger = {
            { type='craft-item', item='iron-plate', amount = 1 }
        },
        icon = "__textplates__/graphics/entity/iron/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.iron-C"} }
    },

    {
        type = "technology",
        name = fns 'textplates-copper',
        effects = {
            { type='unlock-recipe', recipe='textplates-copper'}
        },
        research_trigger = {
            { type='craft-item', item='copper-plate', amount = 1 }
        },
        icon = "__textplates__/graphics/entity/copper/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.copper-C"} }
    },

    {
        type = "technology",
        name = fns 'textplates-stone',
        effects = {
            { type='unlock-recipe', recipe='textplates-stone'}
        },
        research_trigger = {
            { type='craft-item', item='stone-brick', amount = 1 }
        },
        icon = "__textplates__/graphics/entity/stone/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.stone-C"} }
    }
}