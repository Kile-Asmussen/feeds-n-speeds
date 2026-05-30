--! data: change mining times for most buildable entities

local times = {
    ['generator'] = {
        ['steam-engine'] = 1.5,
        ['steam-turbine'] = 2.0,
    },
    ['boiler'] = {
        ['boiler'] = 1.0,
        ['heat-exchanger'] = 1.5,
    },
    ['reactor'] = {
        ['nuclear-reactor'] = 8.0,
        ['heating-tower'] = 2.0,
    },
    ['assembling-machine'] = {
        ['assembling-machine-1'] = 0.5,
        ['assembling-machine-2'] = 0.8,
        ['assembling-machine-3'] = 1.0,
        ['chemical-plant'] = 1.2,
        ['oil-refinery'] = 2.0,
        ['centrifuge'] = 1.5,

        ['electromagnetic-plant'] = 2.0,
        ['cryogenic-plant'] = 2.0,
        ['biochamber'] = 1.5,
        ['foundry'] = 2.5,
        ['crusher'] = 1.0,
    },
    ['furnace'] = {
        ['stone-furnace'] = 0.8,
        ['steel-furnace'] = 1.0,
        ['electric-furnace'] = 1.2, 
        ['recycler'] = 1.5,
    },
    ['mining-drill'] = {
        ['burner-mining-drill'] = 1,
        ['electric-mining-drill'] = 1.5,
        -- ['']
        ['pumpjack'] = 1.5,
        ['big-mining-drill'] = 3.0,
    },
    ['lab'] = {
        ['lab'] = 1.0,
    },
    ['roboport'] = {
        ['roboport'] = 2.0,
    },
    ['radar'] = {
        ['radar'] = 1.0,
    },
    ['electric-pole'] = {
        ['small-electric-pole'] = 0.2,
        ['medium-electric-pole'] = 0.3,
        ['big-electric-pole'] = 0.5,
        ['substation'] = 0.8,
    },
    ['rocket-silo'] = {
        ['rocket-silo'] = 10.0,
    },
    ['agricultural-tower'] = {
        ['agricultural-tower'] = 1.0,
    },
    ['asteroid-collector'] = {
        ['asteroid-collector'] = 1.5,
    },
    ['lightning-attractor'] = {
        ['lightning-collector'] = 1.0,
    },
    ['thruster'] = {
        ['thruster'] = 1.0,
    },
    ['locomotive'] = {
        ['locomotive'] = 5.0,
    },
    ['cargo-wagon'] = {
        ['cargo-wagon'] = 3.0,
    },
    ['fluid-wagon'] = {
        ['fluid-wagon'] = 3.0,
    },
    ['artillery-wagon'] = {
        ['artillery-wagon'] = 5.0,
    },
}

data.raw.technology['steel-axe'] = nil

-- Update mining times
for entity_type, entities in pairs(times) do
    for entity_name, mining_time in pairs(entities) do
        if not (data.raw[entity_type] and data.raw[entity_type][entity_name]) then
            die("no such prototype: " .. string.tablepath('data.raw', { entity_type, entity_name }))
        end

        local entity = data.raw[entity_type][entity_name]

        if entity.minable then
            entity.minable.mining_time = mining_time
        else
            die("not minable: " .. string.tablepath('data.raw', { entity_type, entity_name }))
        end
    end
end