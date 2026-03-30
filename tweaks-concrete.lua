require('utils')

tweaks = tweaks or {}
tweaks.concrete = tweaks.concrete or {}

function tweaks.concrete.data_update()

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
        { type = 'item', name = 'steel-plate', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    -- Next we alter research of concrete so we unlock
    -- the chemical plant to produce it in.

    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = 'chemical-plant'
    })

    table.insert(tech.concrete.prerequisites, 'fluid-handling')

    -- We also make sure to make oil processing depend on concrete


    table.insert(tech['oil-processing'].prerequisites, 'concrete')

    -- And remove that it unlocks the chemical plant, making concrete
    -- a mandatory technology! First we gotta find where it is in the list, though:
    
    table.remove_matching(tech['oil-processing'].effects,
        table.matches{ type = 'unlock-recipe', recipe = 'chemical-plant'}
    )

    -- Finally we make a few recipes dependent on concrete instead of bricks

    is_stone_brick = table.matches{ name = 'stone-brick', type = 'item' }

    table.find_matching(recipes['oil-refinery'].ingredients, is_stone_brick).name = 'concrete'

    -- Unfortunately to make electric furnaces depend on concrete, we gotta
    -- make the tech depend on it as well

    table.find_matching(recipes['electric-furnace'].ingredients, is_stone_brick).name = 'concrete'
    table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')

    -- And make the nuclear reactor dependent on refined concrete and a bit less on steel

    conc = table.find_matching(recipes['nuclear-reactor'].ingredients,
        table.matches{ name = 'concrete', type = 'item' }
    )
    conc.name = 'refined-concrete'
    conc.amount = 1000

    table.find_matching(recipes['nuclear-reactor'].ingredients,
        table.matches{ name = 'steel-plate', type = 'item' }
    ).amount = 200

end