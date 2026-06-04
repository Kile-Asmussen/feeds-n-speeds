--! data: data-driven assignment of subgroup and order to items, fluids, and recipes by name
local fns = require 'fns'
local table = fns.table
local gadgets = fns.gadgets

local function add_subgroups(args)
    local base = data.raw['item-subgroup'][args[1]]
    assert(base, "no such item-subgroup: " .. args[1])
    local n = string.byte('b')
    for i=2,#args do
        data:extend{table.merge(table.deepcopy(base), {
            name = fns(args[i]),
            order = base.order .. '-' .. string.char(n),
        })}
        n = n + 1
    end
    base.order = base.order .. '-a'
end

add_subgroups{
    'belt',
    'better-belt',
}

add_subgroups{
    'energy-pipe-distribution',
    'energy-pipe-storage',
}

add_subgroups{
    'terrain',
    'soil'
}

add_subgroups{
    'energy',
    'green-energy'
}

add_subgroups{
    'production-machine',
    'advanced-production-machine',
}
add_subgroups{
    'module',
    'module-2',
}

data.raw['item-subgroup']['agriculture'] = nil
data.raw['item-subgroup']['environmental-protection'] = nil

-- map[subgroup_id -> array[item/fluid/recipe id] + map[item/fluid/recipe id -> order]]
local ordering = {
    storage = {
        fns'wooden-chest',
        fns'iron-chest',
        fns'steel-chest',
        nil,
        'storage-chest',
        'passive-provider-chest',
        'active-provider-chest',
        'requester-chest',
        'buffer-chest',
    },
    belt = {
        ['transport-belt'] = 'a-a',
        ['underground-belt'] = 'a-b',
        ['splitter'] = 'a-c',
        ['fast-transport-belt'] = 'b-a',
        ['fast-underground-belt'] = 'b-c',
        ['fast-splitter'] = 'b-c',
    },
    [fns'better-belt'] = {
        ['express-transport-belt'] = 'a-a',
        ['express-underground-belt'] = 'a-b',
        ['express-splitter'] = 'a-c',
        ['turbo-transport-belt'] = 'b-a',
        ['turbo-underground-belt'] = 'b-b',
        ['turbo-splitter'] = 'b-c',
    },
    ['energy-pipe-distribution'] = {
        'small-electric-pole',
        'medium-electric-pole',
        'big-electric-pole',
        'substation',
        'pipe',
        'pipe-to-ground',
        'heat-pipe',
        'beacon',
    },
    [fns'energy-pipe-storage'] = {
        'accumulator',
        'power-switch',
        'storage-tank',
        'pump',
    },
    transport = {
        'locomotive',
        'cargo-wagon',
        'fluid-wagon',
        'artillery-wagon',
        'car',
        'tank',
        'spidertron',
    },
    ['logistic-network'] = {
        'repair-pack'
    },
    [fns'soil'] = {
        'landfill',
        'artificial-yumako-soil',
        'overgrowth-yumako-soil',
        'artificial-jellynut-soil',
        'overgrowth-jellynut-soil',
        'ice-platform',
    },
    energy = {
        'heating-tower'
    },
    [fns'green-energy'] = {
        'solar-panel',
        'nuclear-reactor',
        'lightning-rod',
        'lightning-collector',
        'fusion-reactor',
        'fusion-generator',
    },
    ['extraction-machine'] = {
        'agricultural-tower',
        'captive-biter-spawner'
    },
    ['smelting-machine'] = {
        'oil-refinery',
        'centrifuge'
    },
    [fns 'advanced-production-machine'] = {
        'biochamber', 'electromagnetic-plant', 'cryogenic-plant', 'foundry', 'biolab'
    },
    -- do something interesting with beacons. Logistics?
    [fns 'module-2'] = {
        'productivity-module',
        'productivity-module-2',
        'productivity-module-3',
        'quality-module',
        'quality-module-2',
        'quality-module-3',
    }
}

for subgroup, spec in table.opairs(ordering) do
    if not data.raw['item-subgroup'][subgroup] then
        error("recipe-ordering: no such subgroup as "..subgroup, 1)
    end
    local run = string.byte('a')
    local step = string.byte('a')

    for i = 1, #spec do
        local name = spec[i]
        if not name then
            run = run + 1
            step = string.byte('a')
        end
        local ord = string.char(run) .. '-' .. string.char(step)

        local proto
        local entity = gadgets.find_entity_prototype(name)
        if entity then
            entity.subgroup = subgroup
            entity.order = ord
            if not entity.minable then
                goto skip
            end

            if entity.minable.result then
                proto = gadgets.find_item_prototype(entity.minable.result)
            elseif entity.minable.results and #entity.minable.results == 1 then
                proto = gadgets.find_item_prototype(entity.minable.results[1].name)
            end

            ::skip::
        end

        if not proto then
            proto = gadgets.find_item_prototype(name)
            if not proto then error("recipe-ordering: no prototype found for '" .. name .. "'", 1) end
        end

        proto.subgroup = subgroup
        proto.order = ord
    end
end
