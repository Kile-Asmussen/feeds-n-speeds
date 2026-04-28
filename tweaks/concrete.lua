require 'prelude'

local concrete = namespace 'tweaks.concrete'

concrete.enabled = true

function concrete.data()
    if not concrete.enabled then return end

    data:extend{
        require 'tweaks.concrete.simple-concrete',
    }
end

function concrete.data_updates()

    if not concrete.enabled then return end

    local recipes = data.raw.recipe
    local tech = data.raw.technology


    recipes.concrete.category = 'chemistry'
    recipes.concrete.ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    recipes['refined-concrete'].category = 'chemistry'
    recipes['refined-concrete'].ingredients = {
        { type = 'item', name = 'concrete', amount = 20 },
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = 'chemical-plant'
    })

    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = fns 'simple-concrete'
    })

    tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }
    
    table.remove_matching(tech['oil-processing'].effects,
        table.matches{ type = 'unlock-recipe', recipe = 'chemical-plant'}
    )
    
    table.insert(tech['oil-processing'].prerequisites, 'concrete')

    table.insert(recipes['oil-refinery'].ingredients,
        { name = 'concrete', type = 'item', amount = 10 }
    )

    table.insert(recipes['electric-furnace'].ingredients,
        { name = 'concrete', type = 'item', amount = 10 }
    )
end

return concrete:__seal()