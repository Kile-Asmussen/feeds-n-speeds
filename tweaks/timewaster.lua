require 'prelude'

local timewaster = namespace 'tweaks.timewaster'

timewaster.enabled = true

-- Mining times scaled by approximate entity size/complexity
-- Format: [entity_type][entity_name] = mining_time
timewaster.MINING_TIMES = {
    ['generator'] = {
        ['steam-engine'] = 1.5,      -- 3x5 entity
        ['steam-turbine'] = 2.0,     -- larger, more complex
    },
    ['boiler'] = {
        ['boiler'] = 1.0,            -- 2x3 entity
        ['heat-exchanger'] = 1.5,
    },
    ['reactor'] = {
        ['nuclear-reactor'] = 5.0,   -- 5x5, very complex
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
        ['burner-mining-drill'] = 0.5,
        ['electric-mining-drill'] = 0.8,
        ['pumpjack'] = 1.0,
        -- Space Age
        ['big-mining-drill'] = 2.0,       -- 5x5, Vulcanus
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
}

local function check(on, off, ...)
    local args = table.pack(...)
    return function() return enabled(table.unpack(args)) and on or off end
end

-- Crafting times (energy_required) for recipes
-- Format: [recipe_name] = energy_required
timewaster.CRAFTING_TIMES = {
    -- Power generation
    ['steam-engine'] = 5.0,
    ['steam-turbine'] = 10.0,
    ['boiler'] = 3.0,
    ['heat-exchanger'] = 8.0,
    ['nuclear-reactor'] = 30.0,
    ['solar-panel'] = 5.0,
    ['accumulator'] = 4.0,

    -- Production
    ['assembling-machine-1'] = 2.0,
    ['assembling-machine-2'] = 5.0,
    ['assembling-machine-3'] = 10.0,
    ['chemical-plant'] = 8.0,
    ['oil-refinery'] = 15.0,
    ['centrifuge'] = 10.0,

    -- Furnaces
    ['stone-furnace'] = check(4.0, 2.0, 'extras.altrecipes'),
    [fns 'stone-furnace'] = 2.0,
    ['steel-furnace'] = 3.0,
    ['electric-furnace'] = 5.0,

    -- Mining
    ['electric-mining-drill'] = 3.0,
    ['pumpjack'] = 5.0,

    -- Logistics
    ['roboport'] = 10.0,
    [fns 'sleeper-roboport'] = check(1.0, 10.0, 'tweaks.malltech'),
    [fns 'construction-roboport'] = check(1.0, 10.0, 'tweaks.malltech'),
    [fns 'logistics-roboport'] = check(1.0, 10.0, 'tweaks.malltech'),
    ['radar'] = 5.0,
    [fns 'small-radar'] = 3.0,
    ['medium-electric-pole'] = 1.0,
    ['big-electric-pole'] = 2.0,
    ['substation'] = 3.0,

    -- Chests
    ['wooden-chest'] = 1,
    ['iron-chest'] = 1.5,
    ['steel-chest'] = 1.5,
    [fns 'big-steel-chest'] = 2.5,
    [fns 'big-steel-hopper'] = 2.0,

    -- Science
    ['lab'] = 5.0,

    -- Endgame
    ['rocket-silo'] = 60.0,

    -- Space Age (only where vanilla times are too short)
    ['recycler'] = 5.0,
}

function timewaster.data_updates()
    if not timewaster.enabled then return end

    data.raw.technology['steel-axe'] = nil

    -- Update mining times
    for entity_type, entities in pairs(timewaster.MINING_TIMES) do
        local category = data.raw[entity_type]
        if category then
            for entity_name, mining_time in pairs(entities) do
                local entity = category[entity_name]
                if entity and entity.minable then
                    if type(mining_time) == 'function' then
                        entity.minable.mining_time = mining_time()
                    elseif type(mining_time) == 'number' then
                        entity.minable.mining_time = mining_time
                    end
                end
            end
        end
    end

    -- Update crafting times
    for recipe_name, energy_required in pairs(timewaster.CRAFTING_TIMES) do
        local recipe = data.raw.recipe[recipe_name]
        if recipe then
            if type(energy_required) == 'function' then
                recipe.energy_required = energy_required()
            elseif type(energy_required) == 'number' then
                recipe.energy_required = energy_required
            end
        end
    end
end

return timewaster:__seal()
