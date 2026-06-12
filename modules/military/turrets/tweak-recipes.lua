--! data: changes to recipes for turrets to make them more difficult to build

local fns = require'fns'
local table = fns.table

local recipes = data.raw.recipe

recipes['gun-turret'].ingredients = {
    { type='item', name='engine-unit', amount=2 },
    { type='item', name='electronic-circuit', amount=5 },
    { type='item', name='steel-plate', amount=5 },
    { type='item', name='iron-gear-wheel', amount=5 },
}

recipes['flamethrower-turret'].ingredients = {
    { type='item', name='pump', amount=5 },
    { type='item', name='pipe', amount=10 },
    { type='item', name='steel-plate', amount=10 },
    { type='item', name='engine-unit', amount=2 },
    { type='item', name='advanced-circuit', amount=2 },
}

recipes['laser-turret'].ingredients = {
    { type='item', name='steel-plate', amount=10 },
    { type='item', name='accumulator', amount=1 },
    { type='item', name='advanced-circuit', amount=2 },
    { type='item', name='electric-engine-unit', amount=2 },
    { type='item', name='small-lamp', amount=10 },
}

recipes['tesla-turret'].ingredients = {
    { type='item', name='plastic-bar', amount=50 },
    { type='item', name='processing-unit', amount=10 },
    { type='item', name='hazard-concrete', amount=30 },
    { type='item', name='supercapacitor', amount=10 },
    { type='item', name='superconductor', amount=10 },
}

recipes['artillery-turret'].ingredients = {
    { type='item', name='electric-engine-unit', amount = 20 },
    { type='item', name='quality-module-2', amount = 5 },
    { type='item', name='refined-hazard-concrete', amount = 100 },
    { type='item', name='radar', amount = 10 },
    { type='item', name='tungsten-plate', amount = 20 },
}

-- TODO: make a new tech for artillery wagons
table.append(data.raw.technology['artillery'].prerequisites,
    {'quality-module-2'})

recipes['rocket-turret'].ingredients = {
    { type='item', name='electric-engine-unit', amount = 4 },
    { type='item', name='steel-plate', amount = 20 },
    { type='item', name='processing-unit', amount = 4 },
    { type='item', name='carbon-fiber', amount = 20 },
}

recipes['railgun-turret'].ingredients = {
    { type='item', name='electric-engine-unit', amount = 30 },
    { type='item', name='heat-pipe', amount = 20 },
    { type='item', name='tungsten-plate', amount = 60 },
    { type='item', name='superconductor', amount = 50 },
    { type='item', name='carbon-fiber', amount = 50 },
    { type='item', name='speed-module-2', amount = 5 },
    { type='item', name='refined-hazard-concrete', amount= 100 },
}
table.append(data.raw.technology['railgun'].prerequisites, {'speed-module-2'})