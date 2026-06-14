--! data: lowering the stack sizes of most building items
local fns = require 'fns'

local stack_sizes = {
    item = {
        --[==============[
           INTERMEDIARIES
          ]==============]
        
        ['iron-stick'] = 200,
        ['steel-plate'] = 50,
        ['electronic-circuit'] = 100,
        ['advanced-circuit'] = 100,
        ['processing-unit'] = 100,
        ['engine-unit'] = 30,
        ['electric-engine-unit'] = 30,
        
        --[=========[
           BUILDINGS
          ]=========]
        
        ['stone-wall']      = 50,
        ['gate']            = 20,

        ['wooden-chest'] = 20,
        ['iron-chest'] = 20,
        ['steel-chest'] = 10,

        ['active-provider-chest'] = 10,
        ['passive-provider-chest'] = 10,
        ['storage-chest'] = 10,
        ['requester-chest'] = 10,
        ['buffer-chest'] = 10,

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

        ['inserter']             = 30,
        ['fast-inserter']        = 20,
        ['long-handed-inserter'] = 20,
        ['bulk-inserter']        = 10,
        ['stack-inserter']       = 10,

        ['small-electric-pole']  = 30,
        ['medium-electric-pole'] = 20,
        ['big-electric-pole']    = 10,
        ['substation']           = 10,
        ['power-switch']         = 10,

        ['small-lamp']           = 20,
        ['accumulator']          = 30,
        ['solar-panel']          = 30,

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

        ['radar']                = 10,

        ['burner-mining-drill']   = 20,
        ['pumpjack']              = 20,
        ['electric-mining-drill'] = 10,
        ['big-mining-drill']      = 5,
        
        ['lightning-rod']        = 30,
        ['lightning-collector']  = 20,

        ['boiler']                = 10,
        ['heat-exchanger']       = 5,

        ['heat-pipe']             = 20,

        ['lab']                   = 10,
        ['biolab']                = 5,

        ['chemical-plant']        = 30,
        ['biochamber']            = 20,
        ['oil-refinery']          = 10,
        ['assembling-machine-1']  = 30,
        ['assembling-machine-2']  = 20,
        ['assembling-machine-3']  = 10,
        ['centrifuge']            = 10,
        ['electromagnetic-plant'] = 5,
        ['cryogenic-plant']       = 5,
        ['foundry']               = 5,
        ['crusher']               = 10,

        ['agricultural-tower']    = 5,
        
        ['storage-tank']          = 10,

        ['steam-engine']          = 10,
        ['steam-turbine']         = 5,

        ['thruster']              = 5,

        ['roboport']              = 5,
        
        ['heating-tower']         = 5,
        ['nuclear-reactor']       = 1,

        ['asteroid-collector']    = 5,

    
        ['rail-support']          = 10,
        ['rail-signal']           = 20,
        ['rail-chain-signal']     = 20,
        ['train-stop']            = 10,
 
        ['rocket-silo']           = 1,
        ['cargo-bay']             = 5,
        ['cargo-landing-pad']     = 1, 

        ['gun-turret'] = 10,
        ['laser-turret'] = 10,
        ['tesla-turret'] = 5,
        ['artillery-turret'] = 5,
        ['railgun-turret'] = 5,
        ['rocket-turret'] = 5,
    },
    ['item-with-entity-data'] = {
        ['locomotive']            = 1,
        ['cargo-wagon']           = 5,
        ['fluid-wagon']           = 5,
        ['artillery-wagon']       = 1,
        ['tank']                  = 1,
        ['car']                   = 1,
        ['spidertron']            = 1,
    },
    ['rail-planner'] = {
        ['rail'] = 50,
        ['rail-ramp'] = 5,
    },
    ammo = {

    },
    gun = {

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
