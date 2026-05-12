require 'prelude'

local times = {
    ['generator'] = {
        ['steam-engine'] = 1.5,      -- 3x5 entity
        ['steam-turbine'] = 2.0,     -- larger, more complex
    },
    ['boiler'] = {
        ['boiler'] = 1.0,            -- 2x3 entity
        ['heat-exchanger'] = 1.5,
    },
    ['reactor'] = {
        ['nuclear-reactor'] = 8.0,   -- 5x5, very complex
        ['heating-tower'] = 2.0,
    },
    ['assembling-machine'] = {
        ['assembling-machine-1'] = 0.5,
        ['assembling-machine-2'] = 0.8,
        ['assembling-machine-3'] = 1.0,
        ['chemical-plant'] = 1.2,
        ['oil-refinery'] = 2.0,      -- 5x5 entity
        ['centrifuge'] = 1.5,
        -- Space Age
        ['electromagnetic-plant'] = 2.0,  -- 5x5, Fulgora
        ['cryogenic-plant'] = 2.0,        -- 5x5, Aquilo
        ['biochamber'] = 1.5,             -- 4x4, Gleba
        ['foundry'] = 2.5,                -- 4x5, Vulcanus
        ['crusher'] = 1.0,                -- 3x3, Vulcanus
    },
    ['furnace'] = {
        ['stone-furnace'] = 0.5,
        ['steel-furnace'] = 0.8,
        ['electric-furnace'] = 1.0,  -- 3x3 entity
        -- Space Age
        ['recycler'] = 1.0,               -- 3x3, Fulgora
    },
    ['mining-drill'] = {
        ['burner-mining-drill'] = 1,
        -- [fns 'burner-mining-drill-fluid'] = 1,
        ['electric-mining-drill'] = 1.5,
        -- [fns 'electric-mining-drill-fluid'] = 1.5,
        ['pumpjack'] = 1.0,
        -- Space Age
        ['big-mining-drill'] = 3.0,       -- 5x5, Vulcanus
    },
    ['lab'] = {
        ['lab'] = 1.0,               -- 3x3 entity
    },
    ['roboport'] = {
        ['roboport'] = 2.0,          -- 4x4 entity
    },
    ['radar'] = {
        ['radar'] = 1.0,             -- 3x3 entity
    },
    ['electric-pole'] = {
        ['small-electric-pole'] = 0.2,
        ['medium-electric-pole'] = 0.3,
        ['big-electric-pole'] = 0.5,      -- 2x2
        ['substation'] = 0.8,             -- 2x2, complex
    },
    ['rocket-silo'] = {
        ['rocket-silo'] = 10.0,      -- 9x9 entity, most complex
    },
    -- Space Age entity types
    ['agricultural-tower'] = {
        ['agricultural-tower'] = 1.0,     -- 3x3, Gleba
    },
    ['asteroid-collector'] = {
        ['asteroid-collector'] = 1.5,     -- Space platform
    },
    ['lightning-attractor'] = {
        ['lightning-collector'] = 1.0,    -- 2x2, Fulgora
    },
    ['thruster'] = {
        ['thruster'] = 1.0,               -- Space platform
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
    local category = data.raw[entity_type]
    if category then
        for entity_name, mining_time in pairs(entities) do
            local entity = category[entity_name]
            if entity and entity.minable then
                entity.minable.mining_time = mining_time
            else
                die("no such entity: " .. entity_name)
            end
        end
    else
        die("no such prototype: " .. entity_type)
    end
end