require 'prelude'

local turrets = data.raw['ammo-turret']

recipes['gun-turret'].ingredients = {
    { type='item', name='electronic-circuit', amount=8 },
    { type='item', name='steel-plate', amount=4 },
    { type='item', name='submachine-gun', amount=2 },
    { type='item', name='iron-gear-wheel', amount=8 },
    { type='item', name='stone-brick', amount=10 },
}


recipes['flamethrower-turret'].ingredients = {
    { type='item', name='pump', amount=5 },
    { type='item', name='pipe', amount=20 },
    { type='item', name='steel-plate', amount=10 },
    { type='item', name='iron-gear-wheel', amount=10 },
    { type='item', name='advanced-circuit', amount=2 },
    { type='item', name='hazard-concrete', amount=10 },
}

recipes['laser-turret'].ingredients = {
    { type='item', name='steel-plate', amount=10 },
    { type='item', name='accumulator', amount=1 },
    { type='item', name='advanced-circuit', amount=5 },
    { type='item', name='electric-engine-unit', amount=2 },
    { type='item', name='small-lamp', amount=10 },
}

table.append(recipes['tesla-turret'].ingredients, {
    { type='item', name='plastic-bar', amount=50 },
    { type='item', name='hazard-concrete', amount=30 },
})

recipes['artillery-turret'].ingredients = {
    { type='item', name='electric-engine-unit', amount = 20 },
    { type='item', name='quality-module-2', amount = 2 },
    { type='item', name='refined-hazard-concrete', amount = 100 },
    { type='item', name='steel-plate', amount = 100 },
    { type='item', name='radar', amount = 30 },
    { type='item', name='tungsten-plate', amount = 30 },
}
-- TODO: make a new tech for artillery wagons
table.append(data.raw.technology['artillery'].prerequisites,
    {'railway', 'quality-module-2'})

recipes['rocket-turret'].ingredients = {
    { type='item', name='hazard-concrete', amount = 10 },
    { type='item', name='electric-engine-unit', amount = 4 },
    { type='item', name='steel-plate', amount = 20 },
    { type='item', name='processing-unit', amount = 4 },
    { type='item', name='carbon-fiber', amount = 20 },
    { type='item', name='rocket-launcher', amount = 4 },
}

recipes['railgun-turret'].ingredients = {
    { type='item', name='electric-engine-unit', amount = 30 },
    { type='item', name='heat-pipe', amount = 20 },
    { type='item', name='tungsten-plate', amount = 60 },
    { type='item', name='superconductor', amount = 50 },
    { type='item', name='carbon-fiber', amount = 50 },
    { type='item', name='speed-module-3', amount = 5 },
    { type='item', name='refined-hazard-concrete', amount= 100 },
}
table.append(data.raw.technology['railgun'].prerequisites, {'speed-module-3'})