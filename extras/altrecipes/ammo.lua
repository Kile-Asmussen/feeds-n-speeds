require 'prelude'

local utilities = require 'extras.utilities'

local other_icon = data.raw.item['explosives'].icon

local recipes = data.raw.recipe

local ammo = table.clone(recipes['firearm-magazine'])

ammo.icon = data.raw.ammo[ammo.name].icon
ammo.name = fns 'firearm-magazine-mass-production'
ammo.category = 'crafting-with-fluid'
ammo.enabled = false
ammo.energy_required = 2
ammo.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=20 },
    { type='item', name='iron-plate', amount=5 },
    { type='item', name='copper-plate', amount=5 },
}
ammo.results = {
    { type='item', name='firearm-magazine', amount=10 },
}

utilities.iconify(ammo, other_icon)

local pammo = table.clone(recipes['piercing-rounds-magazine'])

pammo.icon = data.raw.ammo[pammo.name].icon
pammo.name = fns 'piercing-rounds-magazine-mass-production'
pammo.category = 'crafting-with-fluid'
pammo.energy_required = 2
pammo.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=20 },
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='firearm-magazine', amount=10 },
}
pammo.results = {
    { type='item', name='piercing-rounds-magazine', amount=10 },
}

utilities.iconify(pammo, other_icon)

local shell = table.clone(recipes['shotgun-shell'])

shell.icon = data.raw.ammo[shell.name].icon
shell.name = fns 'shotgun-shell-mass-production'
shell.category = 'crafting-with-fluid'
shell.enabled = false
shell.energy_required = 2
shell.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=30 },
    { type='item', name='iron-plate', amount=5 },
    { type='item', name='copper-plate', amount=5 },
}
shell.results = {
    { type='item', name='shotgun-shell', amount=10 },
}

utilities.iconify(shell, other_icon)

local pshell = table.clone(recipes['piercing-shotgun-shell'])
pshell.icon = data.raw.ammo[pshell.name].icon
pshell.name = fns 'piercing-shotgun-shell-mass-production'
pshell.category = 'crafting-with-fluid'
pshell.energy_required = 2
pshell.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=30 },
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='shotgun-shell', amount=10 },
}
pshell.results = {
    { type='item', name='piercing-shotgun-shell', amount=10 },
}

utilities.iconify(pshell, other_icon)

local nade = table.clone(recipes['grenade'])
nade.icon = data.raw.capsule[nade.name].icon
nade.name = fns 'grenade-mass-production'
nade.energy_required = 2
nade.ingredients = {
    { type='item', name='explosives', amount=2 },
    { type='fluid', name='petroleum-gas', amount=30 },
    { type='item', name='steel-plate', amount=5 },
}
nade.results = {
    { type='item', name='grenade', amount=5 },
}
nade.category = 'crafting-with-fluid'

utilities.iconify(nade, other_icon)

return {
    ammo,
    pammo,
    shell,
    pshell,
    nade
}
