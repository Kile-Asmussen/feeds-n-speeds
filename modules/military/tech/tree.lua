--! data: alterations to the military tech tree, chiefly making powerful weapons available earlier
local fns = require 'fns'
local table = fns.table
local tech = data.raw.technology

table.insert(tech['gun-turret'].prerequisites, 'military')

table.insert(tech['laser-turret'].prerequisites, 'gun-turret')
table.insert(tech['flamethrower'].prerequisites, 'gun-turret')
table.insert(tech['artillery'].prerequisites, 'gun-turret')
table.insert(tech['rocket-turret'].prerequisites, 'gun-turret')
table.insert(tech['railgun'].prerequisites, 'gun-turret')
table.insert(tech['tesla-weapons'].prerequisites, 'gun-turret')

table.insert(tech['laser-turret'].prerequisites, 'electric-engine')

table.insert(data.raw.technology.automobilism.prerequisites, 'gun-turret')

tech['military'].effects = {
    { type='unlock-recipe', recipe='submachine-gun' },
    { type='unlock-recipe', recipe='combat-shotgun' },
}

tech['rocketry'].prerequisites = {
    'rocket-fuel',
    'explosives',
    'military-science-pack'
}
tech['rocketry'].unit.ingredients = {
    { 'automation-science-pack', 1 },
    { 'logistic-science-pack', 1 },
    { 'chemical-science-pack', 1 },
    { 'military-science-pack', 1 },
}

table.insert(tech['rocket-silo'].prerequisites, 'rocketry')

tech['flammables'].effects = {
    { type='unlock-recipe', recipe='flamethrower' },
    { type='unlock-recipe', recipe='flamethrower-ammo' }
}
tech['flammables'].localised_description = {"", { fns 'technology-description', 'flammables' }}

tech['flamethrower'].effects = {
    { type='unlock-recipe', recipe='flamethrower-turret' },
    { type='unlock-recipe', recipe=fns 'napalm' },
    { type='unlock-recipe', recipe=fns 'flamethrower-ammo' },
}
tech['flamethrower'].localised_name = {"", { fns 'technology-description', 'flamethrower' }}
tech['flamethrower'].localised_description = {"", { fns 'technology-description', 'flamethrower' }}

tech['flamethrower'].prerequisites = {
    'flammables', 'advanced-oil-processing', 'military-science-pack'
}
tech['flamethrower'].unit = {
    count = 50,
    ingredients = {
        {'automation-science-pack', 1},
        {'logistic-science-pack', 1},
        {'chemical-science-pack', 1},
        {'military-science-pack', 1},
    },
    time = 30
}

tech['refined-flammables-1'].prerequisites = { 'flammables' }



tech['military-2'].effects = {
    { type='unlock-recipe', recipe='piercing-shotgun-shell' },
    { type='unlock-recipe', recipe='piercing-rounds-magazine' },
    { type='unlock-recipe', recipe='grenade' },
}

tech['defender'].prerequisites = {
    'military-science-pack', 'robotics'
}

tech['military-3'].prerequisites = { 'explosives', 'plastics', 'military-science-pack' }

tech['military-3'].effects = {
    { type='unlock-recipe', recipe='cluster-grenade' },
    { type='unlock-recipe', recipe='slowdown-capsule' },
    { type='unlock-recipe', recipe='poison-capsule' },
}

tech['military-4'].prerequisites = { 'utility-science-pack', 'military-3' }
tech['military-4'].localised_description = {fns.locale_key('technology-description', 'military-4-mass-production')}

tech['military-4'].effects = {
    { type='unlock-recipe', recipe=fns 'firearm-magazine-mass-production', },
    { type='unlock-recipe', recipe=fns 'piercing-rounds-magazine-mass-production', },
    { type='unlock-recipe', recipe=fns 'shotgun-shell-mass-production', },
    { type='unlock-recipe', recipe=fns 'piercing-shotgun-shell-mass-production', },
    { type='unlock-recipe', recipe=fns 'grenade-mass-production', },
    { type='unlock-recipe', recipe='destroyer-capsule' },
}

tech['destroyer'].prerequisites = { 'military-4', 'distractor' }
tech['destroyer'].effects = {}

tech['discharge-defense-equipment'].prerequisites = {
    'military-3', 'solar-panel-equipment', 'power-armor', 'energy-shield-equipment'
}

tech['railgun'].prerequisites = {
    'metallurgic-science-pack', 
    'electromagnetic-science-pack', 
    'carbon-fiber', 
}

tech['railgun'].unit.ingredients = table.icollect(
    { 'automation', 'logistic', 'chemical', 'production', 'utility', 'agricultural', 'metallurgic', 'electromagnetic' },
    function(s) return { s..'-science-pack', 1 } end
)

tech['railgun-shooting-speed-1'].unit.ingredients = table.deepcopy(tech['railgun'].unit.ingredients)
tech['railgun-damage-1'].unit.ingredients = table.deepcopy(tech['railgun'].unit.ingredients)

fns.locale_key("modifier-description", "rocket-turret-attack-bonus")

table.insert(tech['stronger-explosives-5'].effects,
    { type='turret-attack', modifier = 0.4, turret_id = 'rocket-turret' }
)

table.insert(tech['stronger-explosives-6'].prerequisites, 'planet-discovery-gleba')

table.insert(tech['stronger-explosives-6'].effects,
    { type='turret-attack', modifier = 0.5, turret_id = 'rocket-turret' }
)

table.insert(tech['stronger-explosives-7'].effects,
    { type='turret-attack', modifier = 0.5, turret_id = 'rocket-turret' }
)