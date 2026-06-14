--! data: data-driven assignment of subgroup and order to items, fluids, and recipes by name
local fns = require 'fns'
local table = fns.table
local gadgets = fns.gadgets

local letters = {}
local orderings = {}


data.raw['item-subgroup']['agriculture'] = nil
data.raw['item-subgroup']['environmental-protection'] = nil
data.raw['item-subgroup']['energy-pipe-distribution'] = nil
data.raw['item-subgroup']['intermediate-product'] = nil

-- ordering : map[subgroup id -> subgroup settings]
-- subgroup settings : array[order settings]
-- order settings : array[id list] + { name : string }
-- id list : string or array[string]
local ordering = {
    -- logistics
    {
        subgroup = 'storage',
        order = 'a',
        'wooden-chest',
        'iron-chest',
        'steel-chest',
        'storage-chest', 
        'passive-provider-chest', 
        'active-provider-chest', 
        'requester-chest', 
        'buffer-chest', 
    },
    {
        subgroup = 'belt',
        after = true,
        'transport-belt',
        'underground-belt',
        'splitter',
        'fast-transport-belt',
        'fast-underground-belt',
        'fast-splitter',
    },
    {
        subgroup = fns'better-belt',
        after = true,
        'express-transport-belt',
        'express-underground-belt',
        'express-splitter',
        'turbo-transport-belt',
        'turbo-underground-belt',
        'turbo-splitter',
    },
    {
        subgroup = fns'energy-distribution',
        after = true,
        'small-electric-pole',
        'medium-electric-pole',
        'big-electric-pole',
        'substation',
        'accumulator',
        'power-switch',
        fns'electric-link',
    },
    {
        subgroup = fns'pipe-distribution',
        after = true,
        'pipe',
        'pipe-to-ground',
        'one-way-valve',
        'overflow-valve',
        'top-up-valve',
        'storage-tank',
        'pump',
        fns 'barrel-tapper'
    },
    {
        subgroup = fns'heat-distribution',
        after = true,
        'heat-pipe',
        fns 'tank-o-sand',
    },
    {
        subgroup = 'transport',
        after = true,
        'locomotive',
        'cargo-wagon',
        'fluid-wagon',
        'artillery-wagon',
        'car',
        'tank',
        'spidertron',
    
    },
    {
        subgroup = 'logistic-network',
        after = true,
        'repair-pack',
        'construction-robot',
        'logistic-robot',
        'roboport',
        fns'construction-roboport',
        fns'logistics-roboport',
        fns'sleeper-roboport',
        fns'network-roboport',
    },
    {
        subgroup = 'terrain',
        'stone-brick',
        'concrete',
        fns'mechanical-concrete',
        fns 'simple-concrete',
        'refined-concrete',
        'hazard-concrete',
        'refined-hazard-concrete',
        'foundation',
        'cliff-explosives'
    },
    {
        subgroup = fns'soil',
        after = true,
        'landfill',
        'artificial-yumako-soil',
        'overgrowth-yumako-soil',
        'artificial-jellynut-soil',
        'overgrowth-jellynut-soil',
        'ice-platform',
    },
    -- production 
    {
        subgroup = 'energy',
        order = 'a',
        fns 'electroboiler',
        fns 'heat-boiler',
        'heat-exchanger',
        'steam-engine',
        'steam-turbine',
        'heating-tower'
    },
    {
        subgroup = fns'green-energy',
        after = true,
        'solar-panel',
        'lightning-rod',
        'lightning-collector',
        fns 'electric-heater',
        'nuclear-reactor',
        'fusion-reactor',
        'fusion-generator',
    },
    {
        subgroup = 'extraction-machine',
        'burner-mining-drill',
        'electric-mining-drill',
        'big-mining-drill',
        'pumpjack',
        'agricultural-tower',
        'captive-biter-spawner'
    },
    {
        subgroup = 'smelting-machine',
        'stone-furnace',
        fns 'stone-furnace',
        'steel-furnace',
        'electric-furnace',
        'oil-refinery',
        'centrifuge',
        'recycler',

    },
    {
        subgroup = 'production-machine',
        after = true,
        'assembling-machine-1',
        'assembling-machine-2',
        'assembling-machine-3',
        'chemical-plant',
        'lab'
    },
    {
        subgroup = fns 'advanced-production-machine',
        after = true,
        'biochamber',
        'electromagnetic-plant',
        'cryogenic-plant',
        'foundry',
        'biolab'
    },
    {
        subgroup = 'module',
        after = true,
        'speed-module',
        'speed-module-2',
        'speed-module-3',
        'productivity-module',
        'productivity-module-2',
        'productivity-module-3',
    },
    {
        subgroup = fns 'worse-module',
        after = true,
        'efficiency-module',
        'efficiency-module-2',
        'efficiency-module-3',
        'quality-module',
        'quality-module-2',
        'quality-module-3',
    },

    -- intermediate products
    {
        subgroup = 'raw-material',
        order = "a",
        'iron-plate',
        'copper-plate',
        'steel-plate',
        'tungsten-carbide',
        'tungsten-plate',
        'scrap-recycling',
        'holmium-plate',
        'lithium',
        'lithium-plate',
    },
    {
        subgroup = fns'metal-parts',
        after = true,
        'iron-gear-wheel',
        'iron-stick',
        'copper-cable',
        'barrel',
        'engine-unit',
        fns'hand-engine-unit',
        'electric-engine-unit',
        fns'hand-electric-engine-unit',
        'low-density-structure'
    },
    {
        subgroup = fns'electronic-components',
        after = true,
        'electronic-circuit',
        'advanced-circuit',
        'processing-unit',
        'quantum-processor',
        'battery',
        'flying-robot-frame',
        'supercapacitor',
        'superconductor',
    },
    {
        subgroup = 'fluid',
        after = true,
        'steam-condensation',
        'ice-melting',
        'acid-neutralisation',
        'sulfuric-acid',
        'holmium-solution',
        'electrolyte',
        'ammonia',
        'fluoroketone',
        'fluoroketone-cooling',
    },
    {
        subgroup = fns'petroleum',
        after = true,
        'basic-oil-processing',
        fns'purifying-oil-processing',
        'advanced-oil-processing',
        fns'purifying-advanced-oil-processing',
        'light-oil-cracking',
        'heavy-oil-cracking',
        fns'purifying-heavy-oil-cracking',
        'coal-liquefaction',
        'simple-coal-liquefaction',
        'lubricant',
    },
    {
        subgroup = fns'petroleum-derivates',
        after = true,
        'sulfur',
        'plastic-bar',
        'explosives',
        'solid-fuel-from-petroleum-gas',
        'solid-fuel-from-light-oil',
        'solid-fuel-from-heavy-oil',
        'solid-fuel-from-ammonia',
        'rocket-fuel', 'ammonia-rocket-fuel',
        'carbon',
    },
    {
        subgroup = 'agriculture-products',
        after = true,  
    },
    {
        subgroup = 'nauvis-agriculture',
        after = true,
    },
    {
        subgroup = 'vulcanus-processes',
        after = true,
    },
    {
        subgroup = 'science-pack',
        after = true,
        'automation-science-pack',
        'logistic-science-pack',
        'military-science-pack',
        'chemical-science-pack',
        'production-science-pack',
        'utility-science-pack',
    },
    {
        subgroup = fns'space-science-pack',
        after = true,   
        'space-science-pack',
        'metallurgic-science-pack',
        'agricultural-science-pack',
        'electromagnetic-science-pack',
        'cryogenic-science-pack',
        'promethium-science-pack',
    }
}

local prev_subgroup
for r = 1, #ordering do
    local run = ordering[r]

    if not run.subgroup then error("missing subgroup in #" .. r, 1) end

    if not data.raw['item-subgroup'][run.subgroup] then
        data:extend{{
            type = 'item-subgroup',
            name = run.subgroup,
            order = 'zzz[unassigned]',
            group = 'other',
        }}
    end

    local subgroup = data.raw['item-subgroup'][run.subgroup]

    if run.after == true then
        run.after = prev_subgroup
    end
    prev_subgroup = run.subgroup

    if run.after then
        local prev =  data.raw['item-subgroup'][run.after]
        if not prev then error("no such item subgroup " .. run.after) end
        subgroup.order = string.char(prev.order:byte() + 1)
    end
    
    if run.order then
        subgroup.order = run.order
    end

    if run.group then
        subgroup.group = run.group
    end

    for j = 1, #run do
        local names = run[j]
        if type(names) == 'string' then names = { recipe = names } end

        if names.item == true then
            names.item = names.recipe
        end
        if names.fluid == true then
            names.fluid = names.recipe
        end
        if names.entity == true then
            names.entity = names.recipe
        end

        local order = string.char(string.byte('a') - 1 + j)
            
        local recipe = data.raw.recipe[names.recipe]
        if names.recipe and not recipe then
            error("no such recipe as " .. names.recipe)
        elseif recipe then
            recipe.subgroup = subgroup.name
            recipe.order = order
        end

        local entity = gadgets.find_entity_prototype(names.entity)
        if names.entity and not entity then
            error("no such entity as " .. names.entity)
        elseif entity then
            entity.subgroup = subgroup.name
            entity.order = order
        end

        local item = gadgets.find_item_prototype(names.item)
        if names.item and not item then
            error("no such item as " .. names.item)
        elseif item then
            item.subgroup = subgroup.name
            item.order = order
        end

        local fluid = data.raw.fluid[names.fluid]
        if names.fluid and not fluid then
            error("no such fluid as " .. names.item)
        elseif fluid then
            fluid.order = order
        end
    end
end