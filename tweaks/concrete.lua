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

    -- In real life, production of concrete is a delicate operation with
    -- a lot of fine chemistry going into it. To reflect this, let's change
    -- the recipe a bit, and also get rid of that pesky iron ore that's here
    -- for no reason. Iron sticks will serve as the reinforcement.

    recipes.concrete.category = 'chemistry'
    recipes.concrete.ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    -- Refined concrete is then reinforced with additional steel for strength.
    
    recipes['refined-concrete'].category = 'chemistry'
    recipes['refined-concrete'].ingredients = {
        { type = 'item', name = 'concrete', amount = 20 },
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    -- Next we alter research of concrete so we unlock
    -- the chemical plant to produce it in.

    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = 'chemical-plant'
    })

    -- Simple concrete: assembly machine alternative with lower output
    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = fns 'simple-concrete'
    })

    -- Also concrete now requires fluid handling, because that's fun.

    tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }

    -- We also make sure to make oil processing depend on concrete
    -- And remove that it unlocks the chemical plant, making concrete
    -- a truly mandatory technology, and also we make oil refinery
    -- require concrete
    
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