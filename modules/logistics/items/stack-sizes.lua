
local fns = require 'fns'

local ENTITIES = assoc{
    roboport = 10,
    locomotive = 2,
    gate = 20,
    wall = 20
}

local STACK_SIZES = assoc{
    item = assoc{
        --[==============[
           INTERMEDIARIES
          ]==============]
        
        

        --[=========[
           BUILDINGS
          ]=========]
        
        ['stone-wall']           = 100,
        ['gate']                 = 50,
        ['small-electric-pole']  = 50,
        ['medium-electric-pole'] = 30,

        -- 2x2 'complicated'
        ['big-electric-pole']    = 20,
        ['substation']           = 20,
        ['lightning-collector']  = 20,

        -- 2x2 'light'
        ['stone-furnace']        = 30,
        ['burner-mining-drill']  = 30,
        [fns 'small-radar']      = 30,

        -- 2x2 'medium'
        ['steel-furnace']        = 20,
        ['pumpjack']             = 20,
        -- 2x3
        ['boiler']               = 20,

        -- 2x3 heavy

        -- 3x3 'light'
        ['radar']                = 20,

        -- 3x3 'big'
        ['lab']                  = 10,

        -- 4x2 'light'
        ['crusher']              = 20,
        -- 4x2 'complex'
        ['recycler']              = 10,


        -- 3x3 'huge'
        ['agricultural-tower']   = 5,

        -- 3x3 'too useful to limit'
        ['electric-furnace']      = 20,
        ['electric-mining-drill'] = 20,
        ['chemical-plant']        = 20,
        -- 5x5 'too useful to limit'
        ['oil-refinery']          = 10,
        
        -- 3x3 'progressive'
        ['assembling-machine-1']  = 30,
        ['assembling-machine-2']  = 20,
        ['assembling-machine-3']  = 10,
        
        -- 3x3 'cumbersome'
        ['storage-tank']          = 10,
        ['steam-engine']          = 10,

        -- 4x5 'almost too big'
        ['thruster']              = 2,

        -- 3x5–4x5 → 5

        ['centrifuge']           = 5,
        ['steam-turbine']        = 5,
        ['heat-exchanger']       = 10,
        ['roboport']             = 5,
        ['foundry']              = 5,
        
        -- 4x4
        ['biochamber']           = 10,
        ['electromagnetic-plant']    = 10,

        -- 5x5
        ['cryogenic-plant']          = 5,
        ['heating-tower']            = 5,
        ['big-mining-drill']         = 5,
        ['asteroid-collector']       = 5,

        -- Trains
        ['cargo-wagon']          = 5,
        ['fluid-wagon']          = 5,
        -- super heavy
        ['locomotive']           = 2,
        ['artillery-wagon']      = 2,

        -- 5x5 'super heavy'
        ['nuclear-reactor']          = 1,

        -- 8x8 and above
        ['rocket-silo']          = 1,
        ['landing-pad']          = 1, 
    },
    ammo = assoc{

    },
    capsule = assoc{

    },
    tool = assoc{

    }
}

local function get_minable(ent)
    local item, prototype = nil, nil
    if ent.minable
        and ent.minable.results
        and #ent.minable.results == 1 
    then
        item = ent.minable.results[1].name
        prototype = ent.minable.results[1].type
    else
        item = ent.minable.result
        prototype = 'item'
    end
    return prototype, item
end

for cat, changes in pairs(ENTITIES) do
    if type(changes) == 'table' then
        for name, size in pairs(changes) do
            local item, prototype = get_minable(data.raw[cat][name])

            if item and prototype then
                STACK_SIZES[prototype][item] = changes
            end
        end
    elseif type(changes) == 'number' then
        for _, ent in pairs(data.raw[cat]) do
            local item, prototype = get_minable(ent)

            if item and prototype then
                STACK_SIZES[prototype][item] = changes
            end
        end
    end
end

for cat, changes in pairs(STACK_SIZES) do
    for id, size in pairs(changes) do
        data.raw[cat][id].stack_size = size
    end
end
