require 'prelude'

local timewaster = namespace 'tweaks.timewaster'

timewaster.enabled = true

-- Mining times scaled by approximate entity size/complexity
-- Format: [entity_type][entity_name] = mining_time
timewaster.mining_times = {
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
        ['burner-mining-drill'] = 1,
        [fns 'burner-mining-drill-fluid'] = 1,
        ['electric-mining-drill'] = 1.5,
        [fns 'electric-mining-drill-fluid'] = 1.5,
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

-- Returns longer, shorter tile dimensions of an entity's selection_box, rounded up.
local function footprint(prototype_type, entity_name)
    local entity = data.raw[prototype_type] and data.raw[prototype_type][entity_name]
    assert(entity, 'footprint: no such entity ' .. prototype_type .. '/' .. entity_name)
    local box = entity.selection_box
    assert(box, 'footprint: ' .. entity_name .. ' has no selection_box')

    local w = math.ceil(box[2][1] - box[1][1])
    local h = math.ceil(box[2][2] - box[1][2])

    local long = math.max(w, h)
    local short = math.min(w, h)

    if entity.fluid_box and entity.fluid_box.pipe_connections then
        local underground = table.find_matching(entity.fluid_box.pipe_connections,
            table.matches{ connection_type='underground' }
        )
        if underground then
            long = long + underground.max_underground_distance
        end
    end

    if entity.type == 'underground-belt' then
        long = long + entity.max_distance
    end
end

local function weight(item_name)
    local item = data.raw.item[item_name]
    local recipe = data.raw.recipe[item_name]
    if not recipe then return 1 end

    local sum = 0

    for _, ingredient in ipairs(recipe.ingredients) do
        
        if ingredient.type == 'item' and data.raw.item[ingredient.name].place_result then
            sum = sum + weight(ingredient.name)
        elseif ingredient.type == 'fluid' then
            sum = sum + math.ceil(ingredient.amount / 10)
        elseif ingredient.type == 'item' then
            sum = sum + ingredient.amount
        end
    end

    sum = sum / table.find_matching(recipe.results, table.matches{name=item_name}).amount
end

local footprint_stack_sizes = {
    { lo=1, hi=1, stack=100 }, -- walls, power poles, chests, inserters
    { lo=2, hi=2, stack=50 }, -- offshore pump, combinators
    { lo=4, hi=4, stack=40 }, -- turrets, power switch, rail, big power poles
    { lo=6, hi=10, stack=20 }, -- 
    { lo=20, hi=49, stack=10 },
    { lo=50, hi=99, stack=5 },
    { lo=100, hi=1000, stack=1 },
}

local function check_footprint(prototype_type, entity_name)
    penalty = footprint_penalties[entity_name] or 0
    local long, short = footprint(prototype_type, entity_name)
    local area = long * short + weight(entity_name) / 15
    return function()
        for _, class in ipairs(footprint_stack_sizes) do
            if class.lo <= area and area <= class.hi then
                return class.stack
            end 
        end
    end
end

-- Stack sizes for placeable buildings, tiered by footprint
-- Tiers: 1 (9x9+), 5 (5x5), 10 (3x4–4x5), 20 (2x3–3x3), 50 (1x1–2x2)
timewaster.STACK_SIZES = {
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
    ['storage-tank'] = 5.0,

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

    ['locomotive'] = 10.0,
    ['cargo-wagon'] = 8.0,
    ['fluid-wagon'] = 8.0,
    ['artillery-wagon'] = 8.0,
    -- also set mining time

    ['engine-unit'] = 5.0,
    ['electric-engine-unit'] = 5.0,
}

function timewaster.data2()
    if not timewaster.enabled then return end

    data.raw.technology['steel-axe'] = nil

    -- Update mining times
    for entity_type, entities in pairs(timewaster.mining_times) do
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

    -- Update stack sizes
    for item_name, stack_size in pairs(timewaster.STACK_SIZES) do
        local item = data.raw.item[item_name]
        if item then
            if type(stack_size) == 'function' then
                item.stack_size = stack_size()
            elseif type(stack_size) == 'number' then
                item.stack_size = stack_size
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

return seal_namespace(timewaster)
