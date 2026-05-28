local electric_pole = data.raw['electric-pole']

local small = electric_pole['small-electric-pole']
local medium = electric_pole['medium-electric-pole']
local big = electric_pole['big-electric-pole']
local substation = electric_pole.substation

big.maximum_wire_distance = 50
substation.maximum_wire_distance = 18

small.circuit_connector = nil

data.raw.recipe['power-switch'].auto_unlocked_by = 'electric-energy-distribution-2'
data.raw.recipe['power-switch'].ingredients = {
    { type='item', name='advanced-circuit', amount=1 },
    { type='item', name='copper-cable', amount=10 },
    { type='item', name='iron-gear-wheel', amount=5 },
    { type='item', name='steel-plate', amount=5 },
}

data.raw.item['power-switch'].subgroup = data.raw.item.substation.subgroup
data.raw.item['power-switch'].order = data.raw.item.substation.order .. '-a[switch]'

table.insert(data.raw.technology['electric-energy-distribution-1'].prerequisites, 'concrete')