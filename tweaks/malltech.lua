require 'prelude'

local malltech = namespace 'tweaks.malltech'
malltech.enabled = true

function malltech.data_updates()
    if not malltech.enabled then return end

    malltech.tweak_recipes()
    malltech.tweak_technologies()
end

function malltech.tweak_technologies()
    local tech = data.raw.technology

    table.insert(tech['automation-2'].prerequisites, 'fast-inserter')

    -- Centrifuge requires electric-engine-unit and speed-module
    table.insert(tech['uranium-processing'].prerequisites, 'speed-module')
    table.insert(tech['uranium-processing'].prerequisites, 'electric-engine')

    -- Nuclear machines require electric-engine-unit
    table.insert(tech['nuclear-power'].prerequisites, 'electric-engine')
end

function malltech.tweak_recipes()

    malltech.assembling_machines()

    malltech.mining_drills()
    
    malltech.earlygame()

    malltech.misc()

    malltech.nuclear_machines()

    malltech.robotics()
    
    malltech.chemical()
    
    malltech.rail()
end

function malltech.earlygame()

    local recipe = data.raw.recipe

    if enabled('tweaks.earlygame') then

        recipe['gun-turret'].ingredients = {
            { type='item', name='electronic-circuit', amount=8 },
            { type='item', name='iron-plate', amount=4 },
            { type='item', name='submachine-gun', amount=2 },
            { type='item', name='iron-gear-wheel', amount=8 },
        }

        recipe['inserter'].ingredients = {
            { type='item', name='iron-stick', amount=2 },
            { type='item', name='iron-gear-wheel', amount=1 },
            { type='item', name='electronic-circuit', amount=1 },
        }

        recipe['long-handed-inserter'].ingredients = {
            { type='item', name='iron-stick', amount=2 },
            { type='item', name='iron-gear-wheel', amount=1 },
            { type='item', name='inserter', amount=1 },
        }

        recipe['fast-inserter'].ingredients = {
            { type='item', name='iron-gear-wheel', amount=1 },
            { type='item', name='electronic-circuit', amount=2 },
            { type='item', name='inserter', amount=1 },
        }

        if enabled('tweaks.batteries') then
            recipe['bulk-inserter'].ingredients = {
                { type='item', name='plastic-bar', amount=10 },
                { type='item', name='electronic-circuit', amount=10 },
                { type='item', name='fast-inserter', amount=1 },
            }
        end

        if enabled('tweaks.concrete') then
            table.insert(recipe['bulk-inserter'].ingredients,
            { type='item', name='hazard-concrete', amount=1})
        end

    else
        recipe['gun-turret'].ingredients = {
            { type='item', name='electronic-circuit', amount=8 },
            { type='item', name='iron-plate', amount=12 },
            { type='item', name='iron-gear-wheel', amount=10 },
        }
    end

    if enabled('tweaks.technologies') then
        recipe['lab'].ingredients = {
            { type='item', name='transport-belt', amount=3 },
            { type='item', name='inserter', amount=3 },
            { type='item', name='stone-brick', amount=3 },
            { type='item', name='electronic-circuit', amount=10 },
        }
    end
end

function malltech.misc()
    local recipe = data.raw.recipe

    recipe['beacon'].ingredients = {
        { type='item', name='efficiency-module', amount=1 },
        { type='item', name='advanced-circuit', amount=15 },
        { type='item', name='electronic-circuit', amount=15 },
        { type='item', name='steel-plate', amount=5 },
        { type='item', name='copper-cable', amount=5 },
        { type='item', name='hazard-concrete', amount=10 },
    }

    table.insert(data.raw.technology['effect-transmission'].prerequisites, 'efficiency-module')

    table.insert(recipe['substation'].ingredients,
        { type='item', name='iron-stick', amount=5 }
    )
end

function malltech.mining_drills()
    local recipe = data.raw.recipe

    recipe['burner-mining-drill'].ingredients = {
        { type='item', name='stone-brick', amount=6 },
        { type='item', name='iron-gear-wheel', amount=4 },
        { type='item', name='iron-plate', amount=2 },
    }

    recipe['electric-mining-drill'].ingredients = {
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='iron-gear-wheel', amount=5 },
        { type='item', name='iron-plate', amount=5 },
        { type='item', name='steel-plate', amount=1 },
    }

    table.insert(
        data.raw.technology['electric-mining-drill'].prerequisites,
        'steel-processing'
    )

    recipe['boiler'].ingredients = {
        { type='item', name='stone-brick', amount=8 },
        { type='item', name='pipe', amount=4 },
        { type='item', name='copper-plate', amount=2 },
    }

    recipe['steam-engine'].ingredients = {
        { type='item', name='copper-cable', amount=6 },
        { type='item', name='iron-gear-wheel', amount=4 },
        { type='item', name='pipe', amount=10 },
    }

    recipe['offshore-pump'].ingredients = {
        { type='item', name='iron-gear-wheel', amount=4 },
        { type='item', name='pipe', amount=3 },
        { type='item', name='electronic-circuit', amount=2 },
    }

    if enabled('tweaks.earlygame') then
        recipe['burner-mining-drill'].ingredients[3]  = { type='item', name='steel-plate', amount=1 }
        recipe['electric-mining-drill'].ingredients[4]  = { type='item', name='steel-plate', amount=2 }

        table.insert(
            recipe['steam-engine'].ingredients,
            { type='item', name='steel-plate', amount=1 }
        )
        table.insert(
            recipe['offshore-pump'].ingredients,
            { type='item', name='steel-plate', amount=1 }
        )
    end
end

function malltech.assembling_machines()
    local recipe = data.raw.recipe

    recipe['assembling-machine-1'].ingredients = {
        { type='item', name='inserter', amount=3 },
        { type='item', name='iron-chest', amount=1 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='iron-plate', amount=4 },
    }

    recipe['assembling-machine-2'].ingredients = {
        { type='item', name='fast-inserter', amount=4 },
        { type='item', name='splitter', amount=1 },
        { type='item', name='pipe', amount=2 },
        { type='item', name='steel-plate', amount=4 },
    }

    recipe['assembling-machine-3'].ingredients = {
        { type='item', name='fast-inserter', amount=6 },
        { type='item', name='speed-module', amount=3 },
        { type='item', name='steel-plate', amount=4 },
        { type='item', name='pump', amount=2 },
        { type='item', name='refined-hazard-concrete', amount=10 },
    }

    if enabled('tweaks.batteries') then
        table.insert(recipe['assembling-machine-3'].ingredients,
        { type='item', name='plastic-bar', amount=4 })
    end
end

function malltech.chemical()
    local recipe = data.raw.recipe

    recipe['chemical-plant'].ingredients = {
        { type='item', name='pump', amount=3 },
        { type='item', name='storage-tank', amount=1 },
        { type='item', name='pipe', amount=10 },
        { type='item', name='electronic-circuit', amount=10 },
        { type='item', name='copper-plate', amount=20 },
    }

    recipe['oil-refinery'].ingredients = {
        { type='item', name='pump', amount=5 },
        { type='item', name='pipe', amount=20 },
        { type='item', name='steel-furnace', amount=2 },
        { type='item', name='electronic-circuit', amount=10 },
    }

    recipe['pumpjack'].ingredients = {
        { type='item', name='engine-unit', amount=5 },
        { type='item', name='underground-pipe', amount=4 },
        { type='item', name='electronic-circuit', amount=5 },
        { type='item', name='steel-plate', amount=5 },
    }

    if enabled('tweaks.concrete') then
        table.insert(recipe['oil-refinery'].ingredients,
            { type='item', name='hazard-concrete', amount=20 }
        )
    end
end

function malltech.rail()
    local recipe = data.raw.recipe

    table.insert(data.raw.technology.railway.prerequisites, 'circuit-network')

    recipe.locomotive.ingredients = {
        { type='item', name='radar', amount=1 },
        { type='item', name='decider-combinator', amount=3 },
        { type='item', name='engine-unit', amount=20 },
        { type='item', name='steel-plate', amount=20 },
        { type='item', name='lamp', amount=3 },
    }

    recipe['rail-chain-signal'].ingredients = {
        { type='item', name='decider-combinator', amount=1 },
        { type='item', name='arithmetic-combinator', amount=1 },
        { type='item', name='display-panel', amount=1 },
    }

    recipe['rail-signal'].ingredients = {
        { type='item', name='decider-combinator', amount=1 },
        { type='item', name='arithmetic-combinator', amount=1 },
        { type='item', name='display-panel', amount=1 },
    }

    recipe['train-stop'].ingredients = {
        { type='item', name='radar', amount=1 },
        { type='item', name='steel-plate', amount=3 },
        { type='item', name='lamp', amount=1 },
        { type='item', name='arithmetic-combinator', amount=3 },
    }

    if enabled('extras.radars') then
        recipe['train-stop'].ingredients[1] = { type='item', name=fns 'small-radar', amount=1 }
        recipe.locomotive.ingredients[1] = { type='item', name=fns 'small-radar', amount=1 }
    end

end

function malltech.nuclear_machines()
    if not enabled('tweaks.nuclear') then return end

    local recipe = data.raw.recipe

    recipe['steam-turbine'].ingredients = {
        { type='item', name='electric-engine-unit', amount=10 },
        { type='item', name='steel-plate', amount=20 },
        { type='item', name='pipe', amount=50 },
    }

    recipe['heat-exchanger'].ingredients = {
        { type='item', name='heat-pipe', amount=10 },
        { type='item', name='engine-unit', amount=20 },
        { type='item', name='pipe', amount=50 },
    }

    recipe['nuclear-reactor'].ingredients = {
        { type='item', name='concrete', amount=500 },
        { type='item', name='uranium-238', amount=100 },
        { type='item', name='advanced-circuit', amount=500 },
        { type='item', name='steel-plate', amount=250 },
        { type='item', name='electric-engine-unit', amount=100 },
        { type='item', name='heat-pipe', amount=100 },
    }

    recipe.centrifuge.ingredients = {
        { type='item', name='electric-engine-unit', amount=20 },
        { type='item', name='speed-module', amount=5 },
        { type='item', name='steel-plate', amount=50 },
        { type='item', name='iron-gear-wheel', amount=100 },
        { type='item', name='concrete', amount=100 },
    }

    if enabled('tweaks.concrete') then
        table.find_matching(recipe['nuclear-reactor'].ingredients,
            table.matches{ name = 'concrete', type = 'item' }
        ).name = 'refined-hazard-concrete'

        table.find_matching(recipe['centrifuge'].ingredients,
            table.matches{ name = 'concrete', type = 'item' }
        ).name = 'hazard-concrete'
    end
end

function malltech.robotics()
    data.raw.recipe['roboport'].ingredients = {
        { type='item', name='battery', amount=30 },
        { type='item', name='steel-plate', amount=20 },
        { type='item', name='advanced-circuit', amount=45 },
        { type='item', name='radar', amount=1 },
    }

    if enabled('extras.radars') then
        data.raw.recipe['roboport'].ingredients[4] = {  type='item', name=fns 'small-radar', amount=2 }
    end

    if enabled('tweaks.concrete') then
        table.insert(data.raw.recipe['roboport'].ingredients,
            {  type='item', name='hazard-concrete', amount=20 }
        )
    end

    if enabled('extras.roboports') then
        data.raw.recipe[fns 'sleeper-roboport'].ingredients = {
            { type = 'item', amount = 1, name='roboport' },
            { type = 'item', amount = 5, name='constant-combinator' },
        }
        data.raw.recipe[fns 'logistics-roboport'].ingredients = {
            { type = 'item', amount = 1, name='roboport' },
            { type = 'item', amount = 5, name='arithmetic-combinator' },
        }
        data.raw.recipe[fns 'construction-roboport'].ingredients = {
            { type = 'item', amount = 1, name='roboport' },
            { type = 'item', amount = 5, name='decider-combinator' },
        }
    end
end

function malltech.energy()
    data.raw.recipe['accumulator'].ingredients = {
        { type='item', name='battery', amount=5 },
        { type='item', name='steel-plate', amount=2 },
        { type='item', name='electronic-circuit', amount=5 },
    }
end

return malltech:__seal()