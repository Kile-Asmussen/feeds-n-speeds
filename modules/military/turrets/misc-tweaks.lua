require 'prelude'

local recipes = data.raw.recipe
local turrets = data.raw['ammo-turret']

recipes['gun-turret'].ingredients = {
    { type='item', name='electronic-circuit', amount=8 },
    { type='item', name='steel-plate', amount=4 },
    { type='item', name='submachine-gun', amount=2 },
    { type='item', name='iron-gear-wheel', amount=8 },
    { type='item', name='stone-brick', amount=10 },
}
turrets['gun-turret'].max_health = 800

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
data.raw['ammo-turret']['rocket-turret'].max_health = 1000

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

data.raw['ammo-turret']['rocket-turret'].attack_parameters.cooldown = 40
data.raw['ammo-turret']['rocket-turret'].attack_parameters.min_range = 15
data.raw['ammo-turret']['rocket-turret'].attack_parameters.range = 40
data.raw['ammo-turret']['rocket-turret'].automated_ammo_count = 20
data.raw['ammo-turret']['rocket-turret'].inventory_size = 2
data.raw['ammo-turret']['railgun-turret'].attack_parameters.range = 50

data.raw['ammo-turret']['railgun-turret'].max_health = 800
data.raw['electric-turret']['laser-turret'].max_health = 600

data.raw['fluid-turret']['flamethrower-turret'].attack_parameters.fluids = {
    {
        type='crude-oil',
        damage_modifier=0.5
    },
    {
        type='heavy-oil',
        damage_modifier=1.0
    },
    {
        type='light-oil',
        damage_modifier=0.9
    },
    { type=fns'napalm', damage_modifier = 1.35 }
}

