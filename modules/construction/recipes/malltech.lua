--! data: change recipe ingredients of most buildable entities
local fns = require 'fns'
local puts = fns.gadgets.throughputs
local merge = fns.table.merge
local null = fns.utils.null
local append = fns.table.append

merge(data.raw.technology, {
    __rec = true,
    ['logistics-2'] = {
        prerequisites = { 'circuit-network', 'engine' }
    },
    ['logistics-3'] = {
        prerequisites = { 'production-science-pack', 'electric-engine', 'nuclear-power', 'advanced-combinators' }
    },
    ['railway'] = {
        prerequisites = { 'circuit-network', 'engine', 'radar' }
    },
    ['automation-2'] = {
        prerequisites = append{'fast-inserter', 'circuit-network'},
    },
    ['automation-3'] = {
        prerequisites = append{'bulk-inserter', 'logistic-robotics'},
    },
    ['effect-transmission'] = {
        prerequisites = append{'efficiency-module'}
    },
    ['electric-energy-distribution-2'] = {
        prerequisites = append{'electric-energy-accumulators'}
    },
    ['uranium-processing'] = {
        prerequisites = { fns 'wet-drilling', 'concrete', 'chemical-science-pack', 'speed-module', 'electric-engine' 
        },
    }
})

local function ingredients(inputs)
     local energy = inputs.time
     inputs.time = nil
     return { ingredients = fns.gadgets.throughputs(inputs), energy_required = energy }
end

merge(data.raw.recipe, {
    __rec = true,
    ['display-panel'] = ingredients{ ['small-lamp'] = 1, ['copper-plate'] = 2, time = 1 },

    -- Inserters
    ['burner-inserter'] = ingredients{
         ['iron-stick'] = 1, ['iron-gear-wheel'] = 1, ['stone-brick'] = 1
    },
    ['inserter'] = ingredients{
         ['iron-stick'] = 2, ['iron-gear-wheel'] = 2, ['electronic-circuit'] = 1
    },
    ['long-handed-inserter'] = ingredients{
         ['iron-stick'] = 2, ['iron-gear-wheel'] = 1, ['electronic-circuit'] = 1, ['inserter'] = 1
    },
    ['fast-inserter'] = ingredients{
         ['iron-stick'] = 1, ['iron-gear-wheel'] = 2, ['electronic-circuit'] = 1, ['inserter'] = 1
    },
    ['bulk-inserter'] = ingredients{
         ['steel-plate'] = 2, ['advanced-circuit'] = 1, ['engine-unit'] = 2, ['fast-inserter'] = 4
    },
    ['stack-inserter'] = ingredients{
         ['carbon-fiber'] = 2, ['efficiency-module'] = 1, ['electric-engine-unit'] = 4, ['bulk-inserter'] = 2
    },

    -- Belts
    ['transport-belt'] = {},
    ['splitter'] = ingredients{
         ['transport-belt'] = 4, ['electronic-circuit'] = 4, ['iron-gear-wheel'] = 2
    },
    ['underground-belt'] = ingredients{
         ['iron-plate'] = 10, ['transport-belt'] = 6
    },

    ['fast-transport-belt'] = {
        results = puts{ ['fast-transport-belt'] = 2 },
        ingredients = puts{
             ['copper-plate'] = 4, ['engine-unit'] = 2, ['iron-gear-wheel'] = 5
        },
    },
    ['fast-underground-belt'] = ingredients{
         ['fast-transport-belt'] = 8, ['steel-plate'] = 5, ['copper-plate'] = 10
    },
    ['fast-splitter'] = ingredients{
         ['fast-transport-belt'] = 4, ['decider-combinator'] = 2, ['steel-plate'] = 2
    },

    ['express-transport-belt'] = {
        results = puts{ ['turbo-transport-belt'] = 2 },
        ingredients = puts{
            ['steel-plate'] = 2, ['iron-gear-wheel'] = 10, ['electric-engine-unit'] = 4, ['lubricant'] = 20
        },
    },
    ['express-underground-belt'] = ingredients{
         ['express-transport-belt'] = 10, ['concrete'] = 20, ['pump'] = 1, ['water'] = 200
    },
    ['express-splitter'] = ingredients{
         ['express-transport-belt'] = 4, ['selector-combinator'] = 2, ['steel-plate'] = 5
    },

    ['turbo-transport-belt'] = {
        surface_conditions = null,
        results = puts{ ['turbo-transport-belt'] = 2 },
        ingredients = puts {
            ['tungsten-plate'] = 4, ['iron-gear-wheel'] = 20, ['electric-engine-unit'] = 10, ['lubricant'] = 100
        },
    },
    ['turbo-underground-belt'] = {
        surface_conditions = null,
        ingredients = puts{
            ['turbo-transport-belt'] = 12, ['heat-pipe'] = 4, ['refined-concrete'] = 50, ['lubricant'] = 500
        }
    },
    ['turbo-splitter'] = {
        surface_conditions = null,
        ingredients = puts{
            ['turbo-transport-belt'] = 4, ['speed-module'] = 4, ['processing-unit'] = 1, ['low-density-structure'] = 10
        },
    },

    -- Misc
     ['lab'] = ingredients{
          ['engine-unit'] = 1, ['electronic-circuit'] = 10, ['stone-furnace'] = 1, ['transport-belt'] = 3, ['inserter'] = 3,
     },

     -- Furnaces
     ['steel-furnace'] = ingredients{
          ['stone-furnace'] = 2, ['steel-plate'] = 6,
     },
     ['electric-furnace'] = ingredients{
          ['advanced-circuit'] = 5, ['engine-unit'] = 2, ['steel-furnace'] = 2, ['copper-plate'] = 10
     },

     -- Vehicles
     ['car'] = ingredients{
          ['engine-unit'] = 8, ['steel-plate'] = 8, ['pipe'] = 2, ['electronic-circuit'] = 5, ['iron-gear-wheel'] = 10, ['small-lamp'] = 2, ['submachine-gun'] = 2,
     },


    -- Mining drills
    ['burner-mining-drill'] = ingredients{
         ['stone-furnace'] = 1, ['engine-unit'] = 1, ['steel-plate'] = 1, ['pipe'] = 1,
    },
    ['electric-mining-drill'] = ingredients{
         ['electronic-circuit'] = 3,
         ['engine-unit'] = 1, ['iron-gear-wheel'] = 10,
         ['steel-plate'] = 2, ['pipe'] = 3,
    },
    ['big-mining-drill'] = ingredients{
         ['processing-unit'] = 1, ['productivity-module'] = 2, ['electric-engine-unit'] = 10, ['tungsten-carbide'] = 20, ['molten-iron'] = 100, ['molten-copper'] = 100
    },

    -- Steam
    ['boiler'] = ingredients{
         ['stone-furnace'] = 1, ['pipe'] = 3, ['copper-plate'] = 5
    },
    ['steam-engine'] = ingredients{
         ['pipe'] = 2, ['engine-unit'] = 3, ['copper-cable'] = 10,
    },
    ['offshore-pump'] = ingredients{
         ['engine-unit'] = 1, ['pipe'] = 1, ['stone-brick'] = 4
    },

    -- Assembling machines
    ['assembling-machine-1'] = ingredients{
         ['inserter'] = 3, ['electronic-circuit'] = 1, ['repair-pack'] = 2, ['iron-chest'] = 1
    },
    ['assembling-machine-2'] = ingredients{
         ['fast-inserter'] = 4, ['decider-combinator'] = 2, ['pipe'] = 2, ['steel-chest'] = 1
    },
    ['assembling-machine-3'] = ingredients{
         ['bulk-inserter'] = 5, ['speed-module'] = 3, ['storage-chest'] = 1, ['pump'] = 2
    },

     -- Chemical
     ['storage-tank'] = ingredients{
          ['steel-plate'] = 10, ['pipe'] = 4
     },
     ['chemical-plant'] = ingredients{
          ['storage-tank'] = 1, ['arithmetic-combinator'] = 1,  ['pump'] = 2,  ['offshore-pump'] = 1,
          ['copper-plate'] = 10
     },
     ['oil-refinery'] = ingredients{
          ['pipe'] = 10, ['storage-tank'] = 1, ['boiler'] = 3, ['steel-plate'] = 10,
     },
     ['pumpjack'] = ingredients{
          ['pump'] = 1, ['pipe-to-ground'] = 2, ['engine-unit'] = 1, ['steel-plate'] = 5
     },
     ['pump'] = ingredients{
          ['engine-unit'] = 1, ['electronic-circuit'] = 1, ['pipe'] = 1
     },


    -- Rail
     ['locomotive'] = ingredients{
          ['radar'] = 1, ['decider-combinator'] = 3, ['engine-unit'] = 20, ['steel-plate'] = 20, ['small-lamp'] = 3
     },
     ['rail-chain-signal'] = ingredients{
          ['decider-combinator'] = 1, ['arithmetic-combinator'] = 1, ['small-lamp'] = 1
     },
     ['rail-signal'] = ingredients{
          ['decider-combinator'] = 1, ['arithmetic-combinator'] = 1, ['small-lamp'] = 3
     },
     ['train-stop'] = ingredients{
          ['radar'] = 1, ['steel-plate'] = 3, ['small-lamp'] = 2, ['arithmetic-combinator'] = 3
     },
     ['artillery-wagon'] = ingredients{
          ['locomotive'] = 1, ['artillery-turret'] = 1
     },
     ['cargo-wagon'] = ingredients{
          ['iron-chest'] = 3, ['iron-gear-wheel'] = 10, ['steel-plate'] = 10
     },
     ['fluid-wagon'] = ingredients{
          ['storage-tank'] = 2, ['cargo-wagon'] = 1
     },

    -- Nuclear machines
     ['steam-turbine'] = ingredients{
          ['electric-engine-unit'] = 10, ['steel-plate'] = 20, ['pipe'] = 10
     },
     ['heat-exchanger'] = ingredients{
          ['heat-pipe'] = 10, ['engine-unit'] = 20, ['pipe'] = 10
     },
     ['nuclear-reactor'] = ingredients{
          ['concrete'] = 250, ['uranium-238'] = 100, ['advanced-circuit'] = 500, ['steel-plate'] = 250, ['electric-engine-unit'] = 100, ['heat-pipe'] = 100
     },
     ['centrifuge'] = ingredients{
          ['electric-engine-unit'] = 20, ['speed-module'] = 5, ['steel-plate'] = 50, ['iron-gear-wheel'] = 100
     },
     ['heating-tower'] = ingredients{
          ['heat-pipe'] = 5, ['steel-furnace'] = 2, ['concrete'] = 20
     },
     ['heat-pipe'] = ingredients{
          ['copper-plate'] = 10, ['steel-plate'] = 2
     },

     -- Energy
     ['accumulator'] = ingredients{
          ['battery'] = 5, ['copper-cable'] = 3, ['electronic-circuit'] = 1, ['iron-plate'] = 2
     },
     ['solar-panel'] = ingredients{
          ['copper-cable'] = 10, ['plastic-bar'] = 10, ['steel-plate'] = 1, ['electronic-circuit'] = 1,
     },
     ['substation'] = ingredients{
          ['big-electric-pole'] = 1, ['accumulator'] = 1, ['advanced-circuit'] = 5
     },
     ['power-switch'] = ingredients{
          ['electronic-circuit'] = 1, ['copper-cable'] = 10, ['electric-engine'] = 1, ['steel-plate'] = 5
     },
})
