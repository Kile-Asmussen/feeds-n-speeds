--! data: data-driven assignment of subgroup and order to items, fluids, and recipes by name
local fns = require 'fns'
local table = fns.table
local gadgets = fns.gadgets

local letters = {}
local base_orderings = {}

local function add_subgroup(base_name, new_name)
    local base = data.raw['item-subgroup'][base_name]
    
    assert(base, "no such item-subgroup: " .. base_name)
    
    base_orderings[base_name] = base_orderings[base_name] or base.order

    local order = base_orderings[base_name]

    base.order = order .. '-a'

    letters[base_name] = letters[base_name] or 'b'
    
    data:extend{table.merge(table.deepcopy(base), {
        name = new_name,
        order = base.order .. '-' .. letters[base_name],
    })}

    letters[base_name] = string.char(string.byte(letters[base_name]) + 1)
end

data.raw['item-subgroup']['agriculture'] = nil
data.raw['item-subgroup']['environmental-protection'] = nil

-- ordering : map[subgroup id -> subgroup settings]
-- subgroup settings : array[order settings]
-- order settings : array[id list] + { name : string }
-- id list : string or array[string]
local ordering = {
    {
        subgroup = 'storage',
        {
            name = 'chests',
            { 'wooden-chest', fns'wooden-chest', },
            { 'iron-chest', fns'iron-chest', },
            { 'steel-chest', fns'steel-chest', },
        },
        {
            name = 'logistics',
            { 'storage-chest', fns'storage-chest', },
            { 'passive-provider-chest', fns'passive-provider-chest', },
            { 'active-provider-chest', fns'active-provider-chest', },
            { 'requester-chest', fns'requester-chest', },
            { 'buffer-chest', fns'buffer-chest', },
        }
    },
    {
        subgroup = 'belt',
        {
            name = 'belts',
            'transport-belt',
            'underground-belt',
            'splitter',
        },
        {
            name = 'fast-belts',
            'fast-transport-belt',
            'fast-underground-belt',
            'fast-splitter',
        }
    },
    {
        subgroup = fns'better-belt',
        after = 'belt',
        {
            name = 'express-belts',
            'express-transport-belt',
            'express-underground-belt',
            'express-splitter',
        },
        {
            name = 'turbo-belts',
            'turbo-transport-belt',
            'turbo-underground-belt',
            'turbo-splitter',
        }
    },
    {
        subgroup = 'energy-pipe-distribution',
        {
            name = 'electric',
            'small-electric-pole',
            'medium-electric-pole',
            'big-electric-pole',
            'substation',
        },
        {
            name = 'fluids',
            'pipe',
            'pipe-to-ground',

        },
        {
            name = 'heat',
            'heat-pipe',
        },
        {
            name = 'transmission',
            'beacon',
        }
    },
    {
        subgroup = fns'energy-pipe-storage',
        after = 'energy-pipe-distribution',
        {
            name = 'electric',
            'accumulator',
            'power-switch',
            fns'electric-link',
        },
        {
            name = 'fluids',
            'storage-tank',
            'pump',
            'one-way-valve',
            'overflow-valve',
            'top-up-valve',
            fns 'barrel-tapper',
        },
        {
            name = 'heat',
            fns'tank-o-sand',
        }
    },
    {
        subgroup = 'transport',
        {
            name = 'railway',
            'locomotive',
            'cargo-wagon',
            'fluid-wagon',
            'artillery-wagon',
        },
        {
            name = 'personal',
            'car',
            'tank',
            'spidertron',
        }
    },
    {
        subgroup = 'logistic-network',
        {
            name = 'tools',
            'repair-pack',
        },
        {
            name = 'robots',
            'construction-robot',
            'logistic-robot',
        },
        {
            name = 'roboports',
            'roboport',
            fns'construction-roboport',
            fns'logistics-roboport',
            fns'sleeper-roboport',
            fns'network-roboport',
        }
    },
    {
        subgroup = 'terrain',
        {
            name = 'pavements',
            'stone-brick',
            'concrete',
            'refined-concrete',
            'hazard-concrete',
            'refined-hazard-concrete',
            'foundation',
        },
        {
            name = "terraforming",
            'cliff-explosives'
        }
    },
    {
        subgroup = fns'soil',
        after = 'terrain',
        {
            name = 'generic',
            'landfill',
        },
        {
            name = 'agriculture',
            'artificial-yumako-soil',
            'overgrowth-yumako-soil',
            'artificial-jellynut-soil',
            'overgrowth-jellynut-soil',
        },
        {
            name = 'ice',
            'ice-platform',
        }
    },
    {
        subgroup = 'energy',
        {
            name = 'boiler',
            'boiler',
            fns 'electoboiler',
            fns 'heat-boiler',
            'heat-exchanger',
        },
        {
            name = 'generators',
            'steam-engine',
            'steam-turbine',
        },
        {
            name = 'reactors',
            'heating-tower'
        },
    },
    {
        subgroup = fns'green-energy',
        after = 'energy',
        {
            name = 'electric',
            'solar-panel',
            'lightning-rod',
            'lightning-collector',
        },
        {
            name = 'heat',
            fns 'mini-reactor',
            'nuclear-reactor',
        },
        {
            name = 'fusion',
            'fusion-reactor',
            'fusion-generator',
        }
    },
    {
        subgroup = 'extraction-machine',
        {
            name = 'mining',
            'burner-mining-drill',
            'electric-mining-drill',
            'big-mining-drill',
            'pumpjack',
        },
        {
            name = 'agriculture',
            'agricultural-tower',
            'captive-biter-spawner'
        }
    },
    {
        subgroup = 'smelting-machine',
        {
            name = 'furnaces',
            'stone-furnace',
            fns 'stone-furnace',
            'steel-furnace',
            'electric-furnace',
        },
        {
            name = 'chemistry',
            'oil-refinery',
        },
        {
            name = 'specialized',
            'centrifuge',
            'recycler',
        },

    },
    {
        subgroup = 'production-machine',
        {
            name = 'assemblers',
            'assembling-machine-1',
            'assembling-machine-2',
            'assembling-machine-3',
        },
        {
            name = 'chemistry',
            'chemical-plant',
        },
        {
            name = 'science',
            'lab'
        }
    },
    {
        subgroup = fns 'advanced-production-machine',
        after = 'production-machine',
        {
            name = 'space-assemblers',
            'biochamber', 'electromagnetic-plant', 'cryogenic-plant', 'foundry',
        },
        {
            name = 'science',
            'biolab'
        }
    },
    {
        subgroup = 'module',
        {
            name = 'speed',
            'speed-module',
            'speed-module-2',
            'speed-module-3',
        },
        {
            name = 'productivity',
            'productivity-module',
            'productivity-module-2',
            'productivity-module-3',
        },
    },
    {
        subgroup = fns 'worse-module',
        after = 'module',
        {
            name = 'efficiency',
            'efficiency-module',
            'efficiency-module-2',
            'efficiency-module-3',
        },
        {
            name = 'quality',
            'quality-module',
            'quality-module-2',
            'quality-module-3',
        }
    }
}

for r = 1, #ordering do
    local runs = ordering[r]

    if not data.raw['item-subgroup'][runs.subgroup] and data.raw['item-subgroup'][runs.after] then
        add_subgroup(runs.after, runs.subgroup)
    end

    local subgroup = data.raw['item-subgroup'][runs.subgroup]

    if not subgroup then
        error("no such item-subgroup as " .. subgroup_name)
    end

    for i = 1, #runs do
        local run = runs[i]
        if not run.name then 
            error("no run name given (run #" .. i .. " in " .. subgroup.name .. ")", 1)
        end
        local major = string.char(string.byte('a') - 1 + i) .. '[' .. run.name .. ']'

        for j = 1, #run do
            local names = run[j]
            if type(names) == 'string' then names = { names } end

            for k = 1, #names do
                local name = names[k]
                local minor = string.char(string.byte('a') - 1 + j)
                    .. '[' .. name .. ']'
                
                local order = major .. '-' .. minor
                
                local ent = gadgets.find_entity_prototype(name)
                local item = gadgets.find_item_prototype(name)
                local recipe = data.raw.recipe[name]
                local item2 = gadgets.find_item_prototype(ent and ent.minable and ent.minable.result)
                local ent2 = gadgets.find_entity_prototype((item and item.place_result) or (item2 and item2.place_result))

                if ent then ent.order = order end
                if ent2 then ent2.order = order end
                if item then item.order = order end
                if item2 then item2.order = order end
                if recipe then recipe.order = order end
            end
        end
    end
end

for _, subgroup in pairs(data.raw['item-subgroup']) do
    subgroup.order = subgroup.order .. '[' .. subgroup.name .. ']'
end