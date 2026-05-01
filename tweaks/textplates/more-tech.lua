require 'prelude'

return {
    {
        type = "technology",
        name = fns 'textplates-wood',
        effects = {
            { type='unlock-recipe', recipe='textplate-small-wood' },
            { type='unlock-recipe', recipe='textplate-large-wood' },
        },
        research_trigger = { type='craft-item', item='wooden-chest', amount=1 },
        icon = "__even-more-text-plates-2_0__/graphics/entity/wood/t.png",
        icon_size = 128,
        localised_name = { "technology-name.textplate", {"textplates.wood-C"} },
        hidden = true,
    }
}