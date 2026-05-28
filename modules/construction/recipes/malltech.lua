local fns = require 'fns'
local recipe = data.raw.recipe
local tech = data.raw.technology

-- Inserters

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

recipe['bulk-inserter'].ingredients = {
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='advanced-circuit', amount=1 },
    { type='item', name='engine-unit', amount=2 },
    { type='item', name='fast-inserter', amount=4 },
}

recipe['stack-inserter'].ingredients = {
    { type='item', name='carbon-fiber', amount=2 },
    { type='item', name='efficiency-module', amount=1 },
    { type='item', name='electric-engine-unit', amount=4 },
    { type='item', name='bulk-inserter', amount=2 },
}

-- Belts

recipe['splitter'].ingredients = {
    { type='item', name='transport-belt', amount=4 },
    { type='item', name='electronic-circuit', amount=4 },
    { type='item', name='iron-plate', amount=2 },
}

recipe['underground-belt'].ingredients = {
    { type='item', name='iron-plate', amount=10 },
    { type='item', name='transport-belt', amount=6 },
}

tech['logistics-2'].prerequisites = { 'circuit-network', 'engine' }

recipe['fast-transport-belt'].ingredients = {
    { type='item', name='copper-plate', amount=4 },
    { type='item', name='engine-unit', amount=2 },
    { type='item', name='iron-gear-wheel', amount=6 },
}
recipe['fast-transport-belt'].results[1].amount = 2

recipe['fast-underground-belt'].ingredients = {
    { type='item', name='fast-transport-belt', amount=8 },
    { type='item', name='steel-plate', amount=5 },
    { type='item', name='copper-plate', amount=10 },
}

recipe['fast-splitter'].ingredients = {
    { type='item', name='fast-transport-belt', amount=4 },
    { type='item', name='decider-combinator', amount=2 },
    { type='item', name='steel-plate', amount=2 },
}

tech['logistics-3'].prerequisites = { 'production-science-pack', 'electric-engine', 'nuclear-power', 'advanced-combinators' }

recipe['express-transport-belt'].results[1].amount = 2
recipe['express-transport-belt'].ingredients = {
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='iron-gear-wheel', amount=10 },
    { type='item', name='electric-engine-unit', amount=4 },
    { type='fluid', name='lubricant', amount=20 },
}

recipe['express-underground-belt'].ingredients = {
    { type='item', name='express-transport-belt', amount=10 },
    { type='item', name='concrete', amount=20 },
    { type='item', name='pump', amount=1 },
    { type='fluid', name='water', amount=200 },
}

recipe['express-splitter'].ingredients = {
    { type='item', name='express-transport-belt', amount=4 },
    { type='item', name='selector-combinator', amount=2 },
    { type='item', name='steel-plate', amount=5 },
}

recipe['turbo-transport-belt'].surface_conditions = nil
recipe['turbo-splitter'].surface_conditions = nil
recipe['turbo-underground-belt'].surface_conditions = nil

recipe['turbo-transport-belt'].results[1].amount = 2
recipe['turbo-transport-belt'].ingredients = {
    { type='item', name='tungsten-plate', amount=4 },
    { type='item', name='iron-gear-wheel', amount=20 },
    { type='item', name='electric-engine-unit', amount=10 },
    { type='fluid', name='lubricant', amount=100 },
}

recipe['turbo-underground-belt'].ingredients = {
    { type='item', name='turbo-transport-belt', amount=12 },
    { type='item', name='heat-pipe', amount=4 },
    { type='item', name='refined-concrete', amount=50 },
    { type='fluid', name='lubricant', amount=500 },
}

recipe['turbo-splitter'].ingredients = {
    { type='item', name='turbo-transport-belt', amount=4 },
    { type='item', name='speed-module', amount=4 },
    { type='item', name='processing-unit', amount=1 },
    { type='item', name='low-density-structure', amount=10 },
}

-- Misc

recipe['lab'].ingredients = {
    { type='item', name='transport-belt', amount=3 },
    { type='item', name='inserter', amount=3 },
    { type='item', name='copper-plate', amount=10 },
    { type='item', name='electronic-circuit', amount=10 },
}

recipe['beacon'].ingredients = {
    { type='item', name='efficiency-module', amount=1 },
    { type='item', name='advanced-circuit', amount=15 },
    { type='item', name='electronic-circuit', amount=15 },
    { type='item', name='steel-plate', amount=5 },
    { type='item', name='copper-cable', amount=5 },
}

recipe['electric-furnace'].ingredients = {
    { type='item', name='advanced-circuit', amount=5 },
    { type='item', name='engine-unit', amount=2 },
    { type='item', name='steel-furnace', amount=2 },
    { type='item', name='copper-plate', amount=10 },
}

table.insert(tech['effect-transmission'].prerequisites, 'efficiency-module')

recipe['display-panel'].ingredients = table.clone(recipe['small-lamp'].ingredients)

recipe['car'].ingredients = {
    { type='item', name='engine-unit', amount=8 },
    { type='item', name='steel-plate', amount=8 },
    { type='item', name='pipe', amount=2 },
    { type='item', name='electronic-circuit', amount=5 },
    { type='item', name='iron-gear-wheel', amount=10 },
    { type='item', name='small-lamp', amount=2 },
}

-- Mining drills

recipe['burner-mining-drill'].ingredients = {
    { type='item', name='stone-brick', amount=6 },
    { type='item', name='iron-gear-wheel', amount=4 },
    { type='item', name='steel-plate', amount=1 },
}

recipe['electric-mining-drill'].ingredients = {
    { type='item', name='electronic-circuit', amount=3 },
    { type='item', name='iron-gear-wheel', amount=5 },
    { type='item', name='steel-plate', amount=2 },
}

recipe['big-mining-drill'].ingredients = {
    { type='item', name='processing-unit', amount=1 },
    { type='item', name='productivity-module', amount=2 },
    { type='item', name='electric-engine-unit', amount=10 },
    { type='item', name='tungsten-carbide', amount=20 },
    { type='fluid', name='molten-iron', amount=100 },
    { type='fluid', name='molten-copper', amount=100 },
}

-- Steam

recipe['boiler'].ingredients = {
    { type='item', name='stone-brick', amount=8 },
    { type='item', name='pipe', amount=4 },
    { type='item', name='copper-plate', amount=2 },
}

recipe['steam-engine'].ingredients = {
    { type='item', name='copper-cable', amount=6 },
    { type='item', name='iron-gear-wheel', amount=4 },
    { type='item', name='pipe', amount=10 },
    { type='item', name='steel-plate', amount=1 },
}

recipe['offshore-pump'].ingredients = {
    { type='item', name='iron-gear-wheel', amount=4 },
    { type='item', name='pipe', amount=3 },
    { type='item', name='electronic-circuit', amount=2 },
    { type='item', name='steel-plate', amount=1 },
}

-- Assembling machines

table.append(tech['automation-2'].prerequisites, {'fast-inserter', 'engine'})
table.append(tech['automation-3'].prerequisites, {'bulk-inserter', 'logistic-robotics'})

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
}

-- Chemical

recipe['storage-tank'].ingredients = {
    { type='item', name='steel-plate', amount=10 },
    { type='item', name='pipe', amount=4 },
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

-- Rail

tech.railway.prerequisites = { 'circuit-network', 'engine', 'radar' }

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

recipe['artillery-wagon'].ingredients = {
    { type='item', name='locomotive', amount=1 },
    { type='item', name='artillery-turret', amount=1 },
}

-- Nuclear machines

table.merge(tech['uranium-processing'], {
    prerequisites = { fns 'wet-drilling', 'concrete', 'chemical-science-pack', 'speed-module', 'electric-engine' },
    research_trigger = utils.null,
    unit = {
        count = 100,
        time = 30,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
        },
    }
})

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
    { type='item', name='concrete', amount=250 },
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
}

recipe['heating-tower'].ingredients = {
    { type='item', name='heat-pipe', amount=5 },
    { type='item', name='steel-furnace', amount=2 },
    { type='item', name='concrete', amount=20 },
}

-- Energy

recipe['accumulator'].ingredients = {
    { type='item', name='battery', amount=5 },
    { type='item', name='copper-cable', amount=3 },
    { type='item', name='electronic-circuit', amount=1 },
    { type='item', name='iron-plate', amount=2 },
}

recipe['substation'].ingredients = {
    { type='item', name='big-electric-pole', amount=1 },
    { type='item', name='accumulator', amount=1 },
    { type='item', name='advanced-circuit', amount=5 },
}

table.insert(tech['electric-energy-distribution-2'].prerequisites, 'electric-energy-accumulators')

recipe['power-switch'].ingredients = {
    { type='item', name='advanced-circuit', amount=1 },
    { type='item', name='copper-cable', amount=10 },
    { type='item', name='iron-gear-wheel', amount=5 },
    { type='item', name='steel-plate', amount=5 },
}

data.raw.item['power-switch'].subgroup = data.raw.item.substation.subgroup
data.raw.item['power-switch'].order = data.raw.item.substation.order .. '-a[switch]'

table.insert(tech['electric-energy-distribution-2'].effects,
    table.remove_matching(tech['circuit-network'].effects, { recipe = 'power-switch' })
)
