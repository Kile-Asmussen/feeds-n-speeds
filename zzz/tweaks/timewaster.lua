
local timewaster = namespace 'tweaks.timewaster'

timewaster.enabled = true


function timewaster.data()
    
    data:extend(require'tweaks.timewaster.categories')

    local assmacs = data.raw['assembling-machine']

    for i = 1,3 do
        table.append(assmacs['assembling-machine-' .. i].crafting_categories, {
            fns'advanced-crafting-cryogenics', fns'advanced-crafting-organic',
            fns'advanced-pressing', fns'advanced-electronics'
        })
    end
    table.insert(assmacs['assembling-machine-3'].crafting_categories, fns'tier-3-crafting')
    table.insert(assmacs['electromagnetic-plant'].crafting_categories, fns'advanced-electronics')
    table.insert(assmacs['cryogenic-plant'].crafting_categories,  fns'advanced-crafting-cryogenics')
    table.insert(assmacs['foundry'].crafting_categories, fns'advanced-pressing')
    table.insert(assmacs['biochamber'].crafting_categories, fns'advanced-crafting-organic')
end

local function check(on, off, ...)
    local args = { ... }
    return function() return enabled(table.unpack(args)) and on or off end
end


-- Mining times scaled by approximate entity size/complexity
-- Format: [entity_type][entity_name] = mining_time



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

timewaster.ADVANCED = {
    ['advanced-crafting'] = {
        fns 'big-steel-chest',
        fns 'big-hopper',
        'active-provider-chest',
        'requester-chest',
        'buffer-chest',
        'cliff-explosives',

        'assembling-machine-2',
        'steel-furnace',
        'electric-furnace',
        'recycler',

        'electric-mining-drill',
        fns 'electric-mining-drill-fluid',
        'pumpjack',

        'chemical-plant',
        'oil-refinery',
        'centrifuge',
        'heating-tower',

        'agricultural-tower',
        'nuclear-reactor',
        'steam-turbine',
        'heat-exchanger',

        'flamethrower-turret',

        'pipe-to-ground',


        'roboport',
        fns 'construction-roboport',
        fns 'sleeper-roboport',
        fns 'logistics-roboport',

        'low-density-structure',

        'asteroid-collector',
        'cruster',
        'thruster',
        'space-platform-foundation',

        'locomotive',

        'space-science-pack',

        'nuclear-reactor',
        'rocket-silo',
        'cargo-landing-pad',
        'cargo-bay',
        'space-platform-starter-pack',

        'heat-pipe',

        'car',
        'tank',

        'rail',
        fns'rail-1',
        fns'rail-2',
        fns'rail-3',

        'rail-ramp',
        'rail-support',

        'pump',
    },
    [fns 'tier-3-crafting'] = {
        'rocket-turret',
        'artillery-turret',
        'artillery-wagon',
        'railgun-turret',
        'spidertron',

        'biolab',
    },
    electronics = {
        'decider-combinator',
        'selector-combinator',
        'arithmetic-combinator',
        'constant-combinator',
        'small-lamp',
        'display-panel',
        'programmable-speaker',

        'inserter',
        'fast-inserter',
        'long-handed-inserter',
        fns 'small-radar',
        'rail-signal',
        'rail-chain-signal',
        'rocket',
        'explosive-rocket',
        'defender-capsule',
        
        'modular-armor',
    },
    pressing = {
        'iron-chest',
        'steel-chest',
        fns 'barrel-tapper',

        'firearms-magazine',
        'piercing-rounds-magazine',

        'shotgun-shell',
        'piercing-shotgun-shell',
        'land-mine',
        'heavy-armor',
        'barrel',
    },
    ['organic-or-assembling'] = {
        'slowdown-capsule',
        'poison-capsule',
    },
    ['metallurgy-or-assembling'] = {
        fns'firearms-magazine-mass-production',
        fns'piercing-rounds-magazine-mass-production',
        fns'shotgun-shell-mass-production',
        fns'piercing-shotgun-shell-magazine-mass-production',
    },
    [fns'advanced-pressing'] = {
        'cargo-wagon',
        'fluid-wagon',
        fns 'big-steel-chest',
        fns 'big-steel-hopper',
        'storage-tank',

        'cannon-shell',
        'explosive-cannon-shell',
        'artillery-shell',
        'railgun-ammo',

        'gun-turret',
        fns 'shotgun-turret',
        fns 'cannon-turret',
    },
    [fns'advanced-crafting-cryogenics'] = {
        'cryogenic-plant',
        'atomic-bomb',
    },
    [fns"advanced-crafting-organic"] = {
        'biochamber'
    },
    [fns'advanced-electronics'] = {
        'advanced-circuit',
        'processing-unit',

        'laser-turret',
        'beacon',

        'radar',
        'electromagnetic-plant',
        'assembling-machine-3',

        'bulk-inserter',
        'stack-inserter',

        'electric-engine',
        'flying-robot-frame',
        'logistic-robot',
        'construction-robot',
        'power-switch',
        fns 'electric-link',
        'accumulator',
        'solar-panel',

        'medium-electric-pole',
        'big-electric-pole',
        'substation',

        'personal-laser-defense',
        'energy-shield-mk2',
        'energy-shield-mk1',
        'exoskeleton',

        'distractor-capsule',
        'destroyer-capsule',


        'power-armor-mk-1',
        'power-armor-mk-2',
        'mech-armor',
    }
}

function timewaster.data2()
    if not timewaster.enabled then return end


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

    if enabled('tweaks.malltech') then

        for category, names in pairs(timewaster.ADVANCED) do
            for _, name in ipairs(names) do
                if data.raw.recipe[name] then
                    data.raw.recipe[name].category = category
                end
            end
        end

        table.insert(data.raw.technology.biolab.prerequisites, 'automation-3')

    end
end


-- Returns longer, shorter tile dimensions of an entity's selection_box, rounded up.
function timewaster.footprint(prototype_type, entity_name)
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

function timewaster.weight(item_name)
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

timewaster.footprint_stack_sizes = {
    { lo=1, hi=1, stack=100 }, -- walls, power poles, chests, inserters
    { lo=2, hi=2, stack=50 }, -- offshore pump, combinators
    { lo=4, hi=4, stack=40 }, -- turrets, power switch, rail, big power poles
    { lo=6, hi=10, stack=20 }, -- 
    { lo=20, hi=49, stack=10 },
    { lo=50, hi=99, stack=5 },
    { lo=100, hi=1000, stack=1 },
}

function timewaster.check_footprint(prototype_type, entity_name)
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

return seal_namespace(timewaster)
