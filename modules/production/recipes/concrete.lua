
local recipes = data.raw.recipe
local tech = data.raw.technology

table.insert(tech['oil-processing'].prerequisites, 'concrete')
table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')

tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }

table.merge(recipes.concrete, {
    ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    },
    category = 'chemistry',
    auto_recycle = false
})

table.merge(recipes['refined-concrete'], {
    ingredients = {
        { type = 'item', name = 'concrete', amount = 20 },
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'fluid', name = 'water', amount = 100 },
    },
    category = 'chemistry',
    auto_recycle = false
})


-- recipes.concrete.ingredients = {
--     { type = 'item', name = 'stone-brick', amount = 5 },
--     { type = 'item', name = 'iron-stick', amount = 2 },
--     { type = 'fluid', name = 'water', amount = 100 },
-- }
-- recipes.concrete.category = 'chemistry'

-- recipes['refined-concrete'].ingredients = {
--     { type = 'item', name = 'concrete', amount = 20 },
--     { type = 'item', name = 'steel-plate', amount = 1 },
--     { type = 'fluid', name = 'water', amount = 100 },
-- }
-- recipes['refined-concrete'].category = 'chemistry'

recipes['concrete-from-molten-iron'] = nil

table.append(tech['automation-2'].effects, {
    { type='unlock-recipe', recipe=fns 'simple-concrete' },
    { type='unlock-recipe', recipe=fns 'mechanical-concrete' },
    { type='unlock-recipe', recipe='barrel' },
    { type='unlock-recipe', recipe=fns 'barrel-tapper' },
})

-- recipes.concrete.auto_recycle = false
-- recipes.refined_concrete.auto_recycle = false

prototype{
    type = 'recipe',
    name = fns 'simple-concrete',
    enabled = false,
    allow_auto_recycle = false,
    energy_required = 10,
    allow_speed = false,
    allow_pollution = false,
    allow_productivity = false,
    allow_quality = false,
    allow_consumption = false,
    auto_recycle = false,
    ingredients = {
        { type = 'item', name = 'iron-ore', amount = 1 },
        { type = 'item', name = 'stone-brick', amount = 3 },
        { type = 'item', name = 'water-barrel', amount = 1 },
    },
    icons = {
        {
            icon = data.raw.item['concrete'].icon,
            icon_size = 64,
        },
        {
            icon = data.raw.item['barrel'].icon,
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    main_product = 'concrete',
    results = {
        { type = 'item', name = 'concrete', amount = 3 },
        { type = 'item', name = 'barrel', amount = 1 },
    },
    order = 'b[concrete]-a[simple]',
}

prototype{
    type = 'recipe',
    name = fns 'mechanical-concrete',
    category = 'crafting-with-fluid',
    enabled = false,
    allow_auto_recycle = false,
    energy_required = 10,
    auto_recycle = false,
    ingredients = {
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'fluid', name = 'water', amount = 100 },
    },
    icons = {
        {
            icon = data.raw.item['concrete'].icon,
            icon_size = 64,
        },
        {
            icon = data.raw.item['stone'].icon,
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    main_product = 'concrete',
    results = {
        { type = 'item', name = 'concrete', amount = 8 },
    },
    order = 'b[concrete]-a[simple]',
}
