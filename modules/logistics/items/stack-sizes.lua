
local fns = require 'fns'

local stack_sizes = {
    ['rail-planner'] = {
        ['rail'] = 40,
        ['rail-ramp'] = 5,
    },

    item = {
        --[==============[
           INTERMEDIARIES
          ]==============]
        
        

        --[=========[
           BUILDINGS
          ]=========]
        
        -- 1x1 simple
        ['stone-wall']      = 50,
        ['gate']            = 30,

        ['pipe']             = 50,
        ['pipe-to-ground']   = 20,
        ['pump']             = 10,
        
        ['transport-belt']         = 50,
        ['fast-transport-belt']    = 40,
        ['express-transport-belt'] = 30,
        ['turbo-transport-belt']   = 20,

        ['underground-belt']         = 20,
        ['fast-underground-belt']    = 20,
        ['express-underground-belt'] = 10,
        ['turbo-underground-belt']   = 10,

        ['splitter']               = 10,
        ['fast-splitter']          = 10,
        ['express-splitter']       = 5,
        ['turbo-splitter']         = 5,

        ['rail-signal']          = 20,
        ['chain-signal']         = 20,
        ['rail-station']         = 10,

        ['burner-inserter']      = 30,
        ['inserter']             = 30,
        ['fast-inserter']        = 20,
        ['long-handed-inserter'] = 20,
        ['bulk-inserter']        = 10,
        ['stack-inserter']       = 10,

        ['small-electric-pole']  = 30,
        ['medium-electric-pole'] = 20,
        ['big-electric-pole']    = 10,
        ['substation']           = 10,
        [fns 'electric-link']    = 10,
        ['power-switch']         = 10,

        ['small-lamp']           = 20,
        ['accumulator']          = 30,
        ['solar-panel']          = 40,

        ['constant-combinator']    = 30,
        ['display-panel']          = 30,
        ['programmable-speaker']   = 10,
        ['arithmetic-combinator']  = 20,
        ['decider-combinator']     = 20,
        ['selector-combinator']    = 10,
        
        ['stone-furnace']        = 30,
        ['steel-furnace']        = 20,
        ['electric-furnace']     = 10,
        ['recycler']             = 5,

        [fns 'small-radar']      = 20,
        ['radar']                = 10,

        ['burner-mining-drill']   = 20,
        ['pumpjack']              = 20,
        ['electric-mining-drill'] = 10,
        ['big-mining-drill']      = 5,
        
        -- 2x2 complex

        ['lightning-rod']        = 30,
        ['lightning-collector']  = 20,

        -- 2x3
        ['boiler']               = 10,
        [fns 'electroboiler']    = 10,
        ['heat-exchainger']      = 5,

        ['heat-pipe']            = 20,

        ['lab']                  = 10,
        ['biolab']               = 10,

        ['chemical-plant']        = 20,
        ['biochamber']            = 10,
        ['oil-refinery']          = 10,
        ['assembling-machine-1']  = 30,
        ['assembling-machine-2']  = 20,
        ['assembling-machine-3']  = 10,
        ['electromagnetic-plant'] = 5,
        ['cryogenic-plant']       = 5,
        ['foundry']               = 5,
        ['centrifuge']            = 5,
        ['crusher']               = 10,

        ['agricultural-tower']    = 5,
        
        ['storage-tank']          = 10,

        ['steam-engine']          = 10,
        ['steam-turbine']         = 5,

        ['thruster']              = 5,

        ['roboport']                  = 5,
        
        -- 5x5
        ['heating-tower']     = 5,
        ['nuclear-reactor']   = 1,

        ['asteroid-collector']  = 5,

        ['cargo-wagon']          = 5,
        ['fluid-wagon']          = 5,
        ['locomotive']           = 2,
        ['artillery-wagon']      = 2,

        -- 8x8 and above
        ['rocket-silo']          = 1,
        ['carg-bay']             = 5,
        ['landing-pad']          = 1, 
    },
    ammo = {

    },
    capsule = {

    },
    tool = {

    }
}

for cat, changes in pairs(stack_sizes) do
    assert(data.raw[cat], "no such item category: " .. cat)
    for id, size in pairs(changes) do
        assert(data.raw[cat][id], "no such item: " .. cat .. "." .. id)
        data.raw[cat][id].stack_size = size
    end
end
