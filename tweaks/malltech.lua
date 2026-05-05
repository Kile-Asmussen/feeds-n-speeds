require 'prelude'

local malltech = namespace 'tweaks.malltech'
malltech.enabled = true

function malltech.data2()
    malltech.assembling_machines()

    malltech.mining_drills()
    
    malltech.inserters()

    malltech.misc()

    malltech.nuclear_machines()

    malltech.robotics()
    
    malltech.chemical()

    malltech.rail()

    malltech.energy()
end

function malltech.inserters()

    local recipe = data.raw.recipe

    recipe['inserter'].ingredients = {
        { type='item', name='iron-stick', amount=2 },
        { type='item', name='iron-gear-wheel', amount=1 },
        { type='item', name='electronic-circuit', amount=1 },
    }

    recipe['long-handed-inserter'].ingredients = {
        { type='item', name='iron-stick', amount=2 },
        { type='item', name='iron-gear-wheel', amount=1 },
        { type='item', name='electronic-circuit', amount=1 },
        { type='item', name='inserter', amount=1 },
    }

    recipe['fast-inserter'].ingredients = {
        { type='item', name='iron-stick', amount=2 },
        { type='item', name='iron-gear-wheel', amount=1 },
        { type='item', name='electronic-circuit', amount=1 },
        { type='item', name='inserter', amount=1 },
    }

    recipe['lab'].ingredients = {
        { type='item', name='transport-belt', amount=3 },
        { type='item', name='inserter', amount=3 },
        { type='item', name='copper-plate', amount=10 },
        { type='item', name='electronic-circuit', amount=10 },
    }

    recipe['bulk-inserter'].category = 'advanced-crafting'
    recipe['bulk-inserter'].ingredients = {
        { type='item', name='steel-plate', amount=2 },
        { type='item', name='advanced-circuit', amount=2 },
        { type='item', name='engine-unit', amount=2 },
        { type='item', name='fast-inserter', amount=4 },
    }

    recipe['stack-inserter'].category = 'advanced-crafting'
    recipe['stack-inserter'].ingredients = {
        { type='item', name='carbon-fiber', amount=2 },
        { type='item', name='processing-unit', amount=1 },
        { type='item', name='electric-engine-unit', amount=2 },
        { type='item', name='bulk-inserter', amount=2 },
    }
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


    if not enabled('tweaks.military') then
        recipe['gun-turret'].ingredients = {
            { type='item', name='electronic-circuit', amount=8 },
            { type='item', name='iron-plate', amount=12 },
            { type='item', name='iron-gear-wheel', amount=10 },
        }
    end

    table.insert(data.raw.technology['effect-transmission'].prerequisites, 'efficiency-module')

    recipe['display-panel'].ingredients = table.clone(recipe['small-lamp'].ingredients)

    recipe['car'].ingredients = {
        { type='item', name='engine-unit', amount=8 },
        { type='item', name='steel-plate', amount=8 },
        { type='item', name='pipe', amount=2 },
        { type='item', name='electronic-circuit', amount=5 },
        { type='item', name='iron-gear-wheel', amount=10 },
        { type='item', name='small-lamp', amount=2 },
    }
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
    local tech = data.raw.technology

    table.append(tech['automation-2'].prerequisites, {'fast-inserter', 'engine'})
    table.append(tech['automation-3'].prerequisites, {'bulk-inserter', 'logistic-robotics'})

    if not enabled('tweaks.earlygame') then
        table.append(tech['automation'].prerequisites, {'steel-processing'})
        tech['steel-processing'].unit.count = 10
        tech['steel-processing'].unit.time = 10
    end

    recipe['assembling-machine-1'].ingredients = {
        { type='item', name='inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='steel-plate', amount=2 },
        { type='item', name='iron-chest', amount=1 },
    }

    recipe['assembling-machine-2'].ingredients = {
        { type='item', name='fast-inserter', amount=4 },
        { type='item', name='engine-unit', amount=2 },
        { type='item', name='electronic-circuit', amount=6 },
        { type='item', name='pipe', amount=2 },
        { type='item', name='steel-chest', amount=1 },
    }

    recipe['assembling-machine-3'].ingredients = {
        { type='item', name='bulk-inserter', amount=5 },
        { type='item', name='speed-module', amount=3 },
        { type='item', name='electric-engine-unit', amount=10 },
        { type='item', name='storage-chest', amount=1 },
        { type='item', name='pump', amount=2 },
        { type='item', name='refined-concrete', amount=10 },
    }

    if enabled('tweaks.concrete') then
        recipe['assembling-machine-3'].ingredients[6].name = 'refined-hazard-concrete'
    end
end

function malltech.chemical()
    local recipe = data.raw.recipe

    recipe['storage-tank'].ingredients = {
        { type='item', name='steel-plate', amount=10 }
    }

    recipe['chemical-plant'].ingredients = {
        { type='item', name='pump', amount=2 },
        { type='item', name='storage-tank', amount=1 },
        { type='item', name='pipe', amount=10 },
        { type='item', name='electronic-circuit', amount=10 },
        { type='item', name='copper-plate', amount=10 },
    }

    recipe['oil-refinery'].ingredients = {
        { type='item', name='pump', amount=5 },
        { type='item', name='pipe', amount=20 },
        { type='item', name='steel-furnace', amount=1 },
        { type='item', name='storage-tank', amount=1 },
        { type='item', name='electronic-circuit', amount=10 },
    }

    recipe['pumpjack'].ingredients = {
        { type='item', name='pump', amount=1 },
        { type='item', name='pipe-to-ground', amount=4 },
        { type='item', name='electronic-circuit', amount=5 },
        { type='item', name='steel-plate', amount=5 },
    }

    if enabled('tweaks.concrete') then
        recipe['oil-refinery'].ingredients[5] = { type='item', name='hazard-concrete', amount=20 }

        table.insert(recipe['electric-furnace'].ingredients,
            { name = 'hazard-concrete', type = 'item', amount = 10 }
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
        { type='item', name='small-lamp', amount=3 },
    }

    recipe['rail-chain-signal'].ingredients = {
        { type='item', name='decider-combinator', amount=1 },
        { type='item', name='arithmetic-combinator', amount=1 },
        { type='item', name='small-lamp', amount=1 },
    }

    recipe['rail-signal'].ingredients = {
        { type='item', name='decider-combinator', amount=1 },
        { type='item', name='arithmetic-combinator', amount=1 },
        { type='item', name='small-lamp', amount=3 },
    }

    recipe['train-stop'].ingredients = {
        { type='item', name='radar', amount=1 },
        { type='item', name='steel-plate', amount=3 },
        { type='item', name='small-lamp', amount=2 },
        { type='item', name='arithmetic-combinator', amount=3 },
    }

    if enabled('extras.radars') then
        recipe['train-stop'].ingredients[1] = { type='item', name=fns 'small-radar', amount=1 }
        recipe.locomotive.ingredients[1] = { type='item', name=fns 'small-radar', amount=1 }
    end

    recipe['artillery-wagon'].ingredients = {
        { type='item', name='locomotive', amount=1 },
        { type='item', name='artillery-turret', amount=1 },
    }

end

function malltech.nuclear_machines()
    if not enabled('tweaks.nuclear') then return end

    local recipe = data.raw.recipe
    local tech = data.raw.technology

    table.insert(tech['uranium-processing'].prerequisites, 'speed-module')
    table.insert(tech['uranium-processing'].prerequisites, 'electric-engine')

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
        { type='item', name='copper-cable', amount=3 },
        { type='item', name='electronic-circuit', amount=1 },
        { type='item', name='iron-plate', amount=2 },
    }

    data.raw.recipe['substation'].ingredients = {
        { type='item', name='big-electric-pole', amount=1 },
        { type='item', name='accumulator', amount=1 },
        { type='item', name='advanced-circuit', amount=5 },
        { type='item', name='hazard-concrete', amount=10 }
    }

    table.insert(
        data.raw.technology['electric-energy-distribution-2'].prerequisites,
        'electric-energy-accumulators'
    )

    if enabled('tweaks.electric') then
        data.raw.recipe['power-switch'].ingredients = {
            { type='item', name='advanced-circuit', amount=2 },
            { type='item', name='copper-cable', amount=10 },
            { type='item', name='iron-gear-wheel', amount=5 },
            { type='item', name='steel-plate', amount=5 },
        }
        if enabled('tweaks.concrete') then
            table.insert(
                data.raw.recipe['power-switch'].ingredients,
                { type='item', name='hazard-concrete', amount=5 }
            )
        end

        table.insert(data.raw.technology['electric-energy-distribution-2'].effects,
            table.remove_matching( data.raw.technology['circuit-network'].effects, { recipe = 'power-switch' } )
        )
    else
        data.raw.recipe['power-switch'].ingredients = {
            { type='item', name='electronic-circuit', amount=5 },
            { type='item', name='copper-cable', amount=10 },
            { type='item', name='iron-gear-wheel', amount=5 },
            { type='item', name='steel-plate', amount=5 },
        }
    end
end

return seal_namespace(malltech)