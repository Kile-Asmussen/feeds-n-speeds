local electric_pole = data.raw['electric-pole']

local small = electric_pole['small-electric-pole']
local medium = electric_pole['medium-electric-pole']
local big = electric_pole['big-electric-pole']
local substation = electric_pole.substation

small.maximum_wire_distance = 8.5
medium.maximum_wire_distance = 10
big.maximum_wire_distance = 50
substation.maximum_wire_distance = 22

data.raw.recipe['power-switch'].unlocked_by = 'electric-energy-distribution-2'
data.raw.recipe['power-switch'].ingredients = {
    { type='item', name='advanced-circuit', amount=1 },
    { type='item', name='copper-cable', amount=10 },
    { type='item', name='iron-gear-wheel', amount=5 },
    { type='item', name='steel-plate', amount=5 },
}

data.raw.item['power-switch'].subgroup = data.raw.item.substation.subgroup
data.raw.item['power-switch'].order = data.raw.item.substation.order .. '-a[switch]'

table.insert(data.raw.technology['electric-energy-distribution-1'].prerequisites, 'concrete')

table.insert(data.raw.recipe['medium-electric-pole'].ingredients,
    { type = "item", name = "concrete", amount = 1 }
)

table.insert(data.raw.recipe['big-electric-pole'].ingredients,
    { type = "item", name = "concrete", amount = 4 }
)