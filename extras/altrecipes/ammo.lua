require 'prelude'

local utilities = require 'extras.utilities'

local other_icon = data.raw.item['solid-fuel'].icon

local recipes = data.raw.recipe

local ammo = table.clone(recipe['firearms-magazine'])

ammo.name = fns 'firearms-magazine'
ammo.category = 'crafting-with-fluid'
ammo.enabled = false
ammo.energy_required = 2
ammo.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=20 },
    { type='item', name='iron-plate', amount=5 },
    { type='item', name='copper-plate', amount=5 },
}
ammo.result = {
    { type='item', name='firearms-magazine', amount=10 },
}

utilities.iconify(ammo, other_icon)

local pammo = table.clone(recipe['piercing-rounds-magazine'])

pammo.name = fns 'piercing-rounds-magazine'
pammo.category = 'crafting-with-fluid'
pammo.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=20 },
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='firearms-magazine', amount=10 },
}
pammo.result = {
    { type='item', name='piercing-rounds-magazine', amount=10 },
}

utilities.iconify(pammo, other_icon)

local shell = table.clone(recipe['shotgun-shell'])

shell.name = fns 'shotgun-shell'
shell.category = 'crafting-with-fluid'
shell.enabled = false
shell.energy_required = 2
shell.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=30 },
    { type='item', name='iron-plate', amount=5 },
    { type='item', name='copper-plate', amount=5 },
}
shell.result = {
    { type='item', name='shotgun-shell', amount=10 },
}

iconify(shell, other_icon)

local pshell = table.clone(recipe['piercing-shotgun-shell'])
pshell.category = 'crafting-with-fluid'
pshell.ingredients = {
    { type='item', name='explosives', amount=1 },
    { type='fluid', name='petroleum-gas', amount=30 },
    { type='item', name='steel-plate', amount=2 },
    { type='item', name='firearms-magazine', amount=10 },
}
pshell.result = {
    { type='item', name='piercing-shotgun-shell', amount=10 },
}

iconify(pshell, other_icon)

return {
    ammo,
    pammo,
    shell,
    pshell,
}
