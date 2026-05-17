
local recipes = data.raw.recipe

recipes['shotgun-shell'].energy_required = 4
recipes['shotgun-shell'].results[1].amount = 2
recipes['piercing-shotgun-shell'].results[1].amount = 2
recipes['firearm-magazine'].energy_required = 2
recipes['firearm-magazine'].results[1].amount = 2

recipes['artillery-shell'].ingredients = {
    { type = 'item', name = 'explosives', amount = 10 },
    { type = 'item', name = 'steel-plate', amount = 2 },
    { type = 'item', name = fns'small-radar', amount = 1 },
}

recipes['firearm-magazine'].ingredients = {
    { type = 'item', name = 'iron-plate', amount = 2 },
    { type = 'item', name = 'copper-plate', amount = 2 },
    { type = 'item', name = 'sulfur', amount = 1 },
    { type = 'item', name = 'coal', amount = 1 },
}

recipes['piercing-rounds-magazine'].ingredients = {
    { type = 'item', name = 'steel-plate', amount = 1 },
    { type = 'item', name = 'firearm-magazine', amount = 2 },
    { type = 'item', name = 'sulfur', amount = 1 },
    { type = 'item', name = 'coal', amount = 1 },
}

recipes['shotgun-shell'].ingredients = {
    { type = 'item', name = 'copper-plate', amount = 2 },
    { type = 'item', name = 'iron-plate', amount = 2 },
    { type = 'item', name = 'sulfur', amount = 1 },
    { type = 'item', name = 'coal', amount = 2 },
}

recipes['piercing-shotgun-shell'].ingredients = {
    { type = 'item', name = 'shotgun-shell', amount = 2 },
    { type = 'item', name = 'steel-plate', amount = 1 },
    { type = 'item', name = 'sulfur', amount = 1 },
    { type = 'item', name = 'coal', amount = 1 },
}

recipes['grenade'].ingredients = {
    { type = 'item', name = 'steel-plate', amount = 1 },
    { type = 'item', name = 'sulfur', amount = 5 },
    { type = 'item', name = 'coal', amount = 5 },
}

recipes['flamethrower-ammo'].ingredients = {
    { type = 'fluid', name = 'crude-oil', amount = 100 },
    { type = 'item', name = 'barrel', amount = 1 },
}

recipes['slowdown-capsule'].category = 'crafting-with-fluid'
recipes['slowdown-capsule'].ingredients = {
    { type = 'item', name = 'sulfur', amount = 5 },
    { type = 'item', name = 'copper-cable', amount = 5 },
    { type = 'fluid', name = 'crude-oil', amount = 50 },
    { type = 'item', name = 'grenade', amount = 1 },
}

recipes['poison-capsule'].category = 'crafting-with-fluid'
recipes['poison-capsule'].ingredients = {
    { type = 'item', name = 'solid-fuel', amount = 5 },
    { type = 'item', name = 'iron-stick', amount = 5 },
    { type = 'fluid', name = 'sulfuric-acid', amount = 50 },
    { type = 'item', name = 'grenade', amount = 1 },
}

recipes['defender-capsule'].ingredients = {
    { type = 'item', name = 'solid-fuel', amount = 1 },
    { type = 'item', name = 'engine-unit', amount = 1 },
    { type = 'item', name = 'advanced-circuit', amount = 1 },
    { type = 'item', name = 'iron-gear-wheel', amount = 2 },
    { type = 'item', name = 'piercing-rounds-magazine', amount = 1 },
}

recipes['distractor-capsule'].ingredients = {
    { type = 'item', name = 'solid-fuel', amount = 3 },
    { type = 'item', name = 'engine-unit', amount = 3 },
    { type = 'item', name = 'advanced-circuit', amount = 3 },
    { type = 'item', name = 'small-lamp', amount = 3 },
    { type = 'item', name = 'battery', amount = 3 },
}

recipes['destroyer-capsule'].ingredients = {
    { type = 'item', name = 'solid-fuel', amount = 5 },
    { type = 'item', name = 'engine-unit', amount = 5 },
    { type = 'item', name = 'advanced-circuit', amount = 5 },
    { type = 'item', name = 'copper-cable', amount = 10 },
    { type = 'item', name = 'battery', amount = 10 },
}

recipes['rocket'].ingredients = {
    { type = 'item', name = 'rocket-fuel', amount = 1 },
    { type = 'item', name = 'explosives', amount = 1 },
    { type = 'item', name = 'steel-plate', amount = 1 },
    { type = 'item', name = 'electronic-circuit', amount = 3 },
}

recipes['explosive-rocket'].ingredients = {
    { type = 'item', name = 'rocket-fuel', amount = 2 },
    { type = 'item', name = 'explosives', amount = 5 },
    { type = 'item', name = 'steel-plate', amount = 2 },
    { type = 'item', name = 'electronic-circuit', amount = 3 },
}

recipes['railgun-ammo'].ingredients = {
    { type = 'item', name = 'copper-cable', amount = 10 },
    { type = 'item', name = 'tungsten-carbide', amount = 1 },
    { type = 'item', name = 'steel-plate', amount = 5 },
}