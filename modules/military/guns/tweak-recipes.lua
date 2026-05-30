--! data: tweaks to the recipes for guns

local fns = require 'fns'
local recipes = data.raw.recipe

recipes.shotgun.category = fns 'hand-crafting'
recipes.pistol.category = fns 'hand-crafting'
recipes['light-armor'].category = fns 'hand-crafting'

recipes['shotgun-shell'].auto_unlocked_by = {}

recipes.pistol.auto_unlocked_by = {}
recipes.pistol.hidden = false
recipes.shotgun.auto_unlocked_by = {}

recipes.shotgun.ingredients = {
    { type='item', name='iron-plate', amount=5 },
    { type='item', name='copper-plate', amount=5 },
    { type='item', name='wood', amount=5 },
}

recipes['flamethrower'].ingredients = {
    { type='item', name='pipe', amount=1 },
    { type='item', name='engine-unit', amount=1 },
    { type='item', name='iron-gear-wheel', amount=5 },
    { type='item', name='barrel', amount=1 },
}

recipes['submachine-gun'].ingredients = {
    { type='item', name='copper-plate', amount=2 },
    { type='item', name='iron-plate', amount=4 },
    { type='item', name='iron-gear-wheel', amount=4 },
    { type='item', name='steel-plate', amount=1 },
    { type='item', name='wood', amount=2 },
}

recipes['combat-shotgun'].ingredients = {
    { type='item', name='copper-plate', amount=4 },
    { type='item', name='iron-plate', amount=4 },
    { type='item', name='iron-gear-wheel', amount=4 },
    { type='item', name='wood', amount=2 },
    { type='item', name='steel-plate', amount=1 },
}

recipes['railgun'].ingredients = {
    { type='item', name='tungsten-plate', amount = 10 },
    { type='item', name='carbon-fiber', amount = 10 },
    { type='item', name='supercapacitor', amount = 10 },
    { type='item', name='copper-plate', amount = 10 },
}