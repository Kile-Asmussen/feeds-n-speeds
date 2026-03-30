require('table-upgrades')

tweaks = tweaks or {}
tweaks.concrete = tweaks.concrete or {}

tweaks.concrete.toggle = 'feeds-n-speeds-tweaks-concrete-enable'

function tweaks.concrete.data_updates()

    if not tweaks.concrete.enabled then return end

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

    -- Also concrete now requires fluid handling, because that's fun.

    table.insert(tech.concrete.prerequisites, 'fluid-handling')

    -- We also make sure to make oil processing depend on concrete
    -- And remove that it unlocks the chemical plant, making concrete
    -- a truly mandatory technology, and also we make oil refinery
    -- require concrete
    
    table.remove_matching(tech['oil-processing'].effects,
        table.matches{ type = 'unlock-recipe', recipe = 'chemical-plant'}
    )
    
    table.insert(tech['oil-processing'].prerequisites, 'concrete')

    table.find_matching(recipes['oil-refinery'].ingredients,
        table.matches{ name = 'stone-brick', type = 'item' }
    ).name = 'concrete'

    -- Next, we make electrical energy distribution 1 depend on concrete,
    -- and make all the electric poles require it, too, and remove iron
    -- sticks from its recipes

    table.insert(tech['electric-energy-distribution-1'].prerequisites, 'concrete')

    table.remove_matching(tech['electric-energy-distribution-1'].effects, 
        table.matches{ type = 'unlock-recipe', recipe = 'iron-stick'}
    )

    table.remove_matching(recipes['medium-electric-pole'].ingredients,
        table.matches{ type = "item", name = "iron-stick" }
    )

    table.remove_matching(recipes['big-electric-pole'].ingredients,
        table.matches{ type = "item", name = "iron-stick" }
    )

    table.insert(recipes['medium-electric-pole'].ingredients,
        { type = "item", name = "concrete", amount = 2 }
    )

    table.insert(recipes['big-electric-pole'].ingredients,
        { type = "item", name = "concrete", amount = 5 }
    )

    table.insert(recipes['substation'].ingredients,
        { type = "item", name = "concrete", amount = 10 }
    )
    
    -- Unfortunately to make electric furnaces depend on concrete, we gotta
    -- make the tech depend on it as well

    table.find_matching(recipes['electric-furnace'].ingredients,
        table.matches{ name = 'stone-brick', type = 'item' }
    ).name = 'concrete'
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