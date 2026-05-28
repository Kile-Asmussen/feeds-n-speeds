local fns = require 'fns'
local recipes = data.raw.recipe
local gadgets = require 'gadgets'
local tech = data.raw.technology
local puts = gadgets.throughputs

tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }

table.merge(recipes.concrete, {
    ingredients = puts{ ['stone-brick'] = 5, ['iron-stick'] = 2, ['water'] = 100 },
    category = 'chemistry',
    auto_recycle = false
})

table.merge(recipes['refined-concrete'], {
    ingredients = puts{ ['concrete'] = 20, ['steel-plate'] = 2, ['water'] = 100 },
    category = 'chemistry',
    auto_recycle = false
})

recipes['concrete-from-molten-iron'] = nil
gadgets.remove_unlocks{'concrete-from-molten-iron'}

-- recipes.concrete.auto_recycle = false
-- recipes.refined_concrete.auto_recycle = false

data:extend{
    {
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
        auto_unlocked_by = 'automation-2',
        ingredients = puts{ ['iron-ore'] = 1, ['copper-ore'] = 1, ['stone-brick'] = 3, ['water-barrel'] = 1 },
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
        results = puts{ ['concrete'] = 3, ['barrel'] = 1 },
        order = 'b[concrete]-a[simple]',
    },
    {
        type = 'recipe',
        name = fns 'mechanical-concrete',
        category = 'crafting-with-fluid',
        enabled = false,
        allow_auto_recycle = false,
        energy_required = 10,
        auto_recycle = false,
        auto_unlocked_by = 'automation-2',
        ingredients = puts{ ['iron-stick'] = 2, ['stone-brick'] = 5, ['water'] = 100 },
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
        results = puts{ ['concrete'] = 8 },
        order = 'b[concrete]-a[simple]',
    }
}
