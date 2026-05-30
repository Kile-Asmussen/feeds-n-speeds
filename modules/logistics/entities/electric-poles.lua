-- data: tweaks to vanilla electric poles
local fns = require 'fns'

local puts = fns.gadgets.throughputs
local merge = fns.table.merge

merge(data.raw['electric-pole'], {
    __rec = true,
    ['small-electric-pole'] = {
        circuit_connector = fns.utils.null,
    },
    ['medium-electric-pole'] = {
        auto_require_pavement = 'stone-path',
    },
    ['big-electric-pole'] = {
        maximum_wire_distance = 50
    },
})

merge(data.raw.recipe, {
    __rec = true,
    ['power-switch'] = {
        auto_unlocked_by = 'electric-energy-distribution-2',
        ingredients = puts{
            ['advanced-circuit'] = 1,
            ['copper-cable'] = 20,
            ['iron-gear-wheel'] = 2,
            ['steel-plate'] = 2,
        }
    },
    ['big-electric-pole'] = {
        ingredients = puts{
            ['concrete'] = 4,
            ['medium-electric-pole'] = 2,
            ['copper-cable'] = 5,
        }
    }
})

merge(data.raw.item['power-switch'], {
    subgroup = data.raw.item.substation.subgroup,
    data.raw.item.substation.order .. '-a[switch]',
})


data.raw.technology['electric-energy-distribution-1'].prerequisites = { 'automation-2' }