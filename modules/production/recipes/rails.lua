require 'prelude'

local rail1 = table.clone(data.raw.recipe.rail)
local rail2 = table.clone(data.raw.recipe.rail)
local rail3 = table.clone(data.raw.recipe.rail)

rail1.name = fns 'rail-1'
rail2.name = fns 'rail-2'
rail3.name = fns 'rail-3'

rail1.order = 'a[rail]-a[rail]-b[stone-brick]'
rail2.order = 'a[rail]-a[rail]-c[concrete]'
rail3.order = 'a[rail]-a[rail]-d[refined-concrete]'

rail1.allow_auto_recycle = false
rail2.allow_auto_recycle = false
rail3.allow_auto_recycle = false

rail1.localised_name = {"item-name.rail"}
rail2.localised_name = {"item-name.rail"}
rail3.localised_name = {"item-name.rail"}

rail1.hidden = not enabled('tweaks.concrete')
rail2.hidden = not enabled('tweaks.concrete')
rail3.hidden = not enabled('tweaks.concrete')

rail1.ingredients = {
    { amount = 4, name = 'stone-brick', type = 'item' },
    { amount = 2, name = 'iron-stick', type = 'item' },
    { amount = 1, name = 'steel-plate', type = 'item' }
}

rail2.ingredients = {
    { amount = 5, name = 'concrete', type = 'item' },
    { amount = 1, name = 'iron-stick', type = 'item' },
    { amount = 1, name = 'steel-plate', type = 'item' }
}

rail3.ingredients = {
    { amount = 2, name = 'refined-concrete', type = 'item' },
    { amount = 1, name = 'steel-plate', type = 'item' }
}
rail3.allow_productivity = true

local altrecipes = import 'extras.altrecipes'
rail1.icons = altrecipes.rail_icons('stone-brick')
rail2.icons = altrecipes.rail_icons('concrete')
rail3.icons = altrecipes.rail_icons('refined-concrete')


local tech = {
    type = 'technology',
    name = fns 'concrete-rail',
    icons = {
        {
            icon = '__base__/graphics/technology/railway.png',
            icon_size = 256,
        },
        {
            icon = '__base__/graphics/technology/concrete.png',
            icon_size = 256,
            scale = 0.33,
            shift = { 25, 25 },
        },
    },
    prerequisites = {
        'concrete',
        'railway',
    },
    effects = {
        { type = 'unlock-recipe', recipe = fns 'rail-2' },
        { type = 'unlock-recipe', recipe = fns 'rail-3' },
    },
    research_trigger = {
        type = 'craft-item',
        item = 'rail',
        count = 1000,
    },
}

prototype(
    rail1,
    rail2,
    rail3,
    tech
)