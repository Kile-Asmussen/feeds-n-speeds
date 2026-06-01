--! data: new crafting categories that prohibit/solely allow handcrafting plus reassignment of crafting category to a bunch of recipes
local fns = require 'fns'
local table = fns.table

data:extend{
    { type='recipe-category', name=fns 'hand-crafting' },
    { type='recipe-category', name=fns 'advanced-crafting-organic' },
    { type='recipe-category', name=fns 'advanced-pressing' },
    { type='recipe-category', name=fns 'advanced-electronics' },
    { type='recipe-category', name=fns 'advanced-crafting-cryogenics' },
    { type='recipe-category', name=fns 'tier-3-crafting' },
}

table.insert(data.raw.character.character.crafting_categories, fns 'hand-crafting')

local assignments = {
    ['advanced-crafting'] = {
        fns 'big-steel-chest',
        fns 'big-hopper',
        'active-provider-chest',
        'requester-chest',
        'buffer-chest',
        'cliff-explosives',

        'assembling-machine-2',
        'steel-furnace',
        'electric-furnace',
        'recycler',

        'electric-mining-drill',
        fns 'electric-mining-drill-fluid',
        'pumpjack',

        'chemical-plant',
        'oil-refinery',
        'centrifuge',
        'heating-tower',

        'agricultural-tower',
        'nuclear-reactor',
        'steam-turbine',
        'heat-exchanger',

        'flamethrower-turret',

        'roboport',
        fns 'construction-roboport',
        fns 'sleeper-roboport',
        fns 'logistics-roboport',

        'low-density-structure',

        'asteroid-collector',
        'cruster',
        'thruster',
        'space-platform-foundation',

        'locomotive',

        'space-science-pack',

        'nuclear-reactor',
        'rocket-silo',
        'cargo-landing-pad',
        'cargo-bay',
        'space-platform-starter-pack',

        'heat-pipe',

        'car',
        'tank',

        'rail',
        fns 'rail-1',
        fns 'rail-2',
        fns 'rail-3',

        'rail-ramp',
        'rail-support',

        'pump',
    },
    [fns 'tier-3-crafting'] = {
        'rocket-turret',
        'artillery-turret',
        'artillery-wagon',
        'railgun-turret',
        'spidertron',

        'biolab',
    },
    ['electronics'] = {
        'decider-combinator',
        'selector-combinator',
        'arithmetic-combinator',
        'constant-combinator',
        'small-lamp',
        'display-panel',
        'programmable-speaker',

        'inserter',
        'fast-inserter',
        'long-handed-inserter',
        'rail-signal',
        'rail-chain-signal',
        'rocket',
        'explosive-rocket',
        'defender-capsule',

        'modular-armor',
    },
    ['pressing'] = {
        'iron-chest',
        'steel-chest',
        fns 'barrel-tapper',

        'firearm-magazine',
        'piercing-rounds-magazine',

        'shotgun-shell',
        'piercing-shotgun-shell',
        'land-mine',
        'heavy-armor',
        'barrel',
    },
    ['organic-or-assembling'] = {
        'slowdown-capsule',
        'poison-capsule',
    },
    ['metallurgy-or-assembling'] = {
        fns 'firearm-magazine-mass-production',
        fns 'piercing-rounds-magazine-mass-production',
        fns 'shotgun-shell-mass-production',
        fns 'piercing-shotgun-shell-magazine-mass-production',
    },
    [fns 'advanced-pressing'] = {
        'cargo-wagon',
        'fluid-wagon',
        fns 'big-steel-chest',
        fns 'big-steel-hopper',
        'storage-tank',

        'cannon-shell',
        'explosive-cannon-shell',
        'artillery-shell',
        'railgun-ammo',

        'gun-turret',
        fns 'shotgun-turret',
        fns 'cannon-turret',
    },
    [fns 'advanced-crafting-cryogenics'] = {
        'cryogenic-plant',
        'atomic-bomb',
    },
    [fns 'advanced-crafting-organic'] = {
        'biochamber',
    },
    [fns 'advanced-electronics'] = {
        'advanced-circuit',
        'processing-unit',

        'laser-turret',
        'beacon',

        'radar',
        'electromagnetic-plant',
        'assembling-machine-3',

        'bulk-inserter',
        'stack-inserter',

        'electric-engine-unit',
        'flying-robot-frame',
        'logistic-robot',
        'construction-robot',
        'power-switch',
        fns 'electric-link',
        'accumulator',
        'solar-panel',

        'medium-electric-pole',
        'big-electric-pole',
        'substation',

        'personal-laser-defense',
        'energy-shield-mk2',
        'energy-shield-mk1',
        'exoskeleton',

        'distractor-capsule',
        'destroyer-capsule',

        'power-armor-mk-1',
        'power-armor-mk-2',
        'mech-armor',
    },
}

local assmacs = data.raw['assembling-machine']

for i = 1, 3 do
    table.append(assmacs['assembling-machine-' .. i].crafting_categories, {
        fns 'advanced-crafting-cryogenics', fns 'advanced-crafting-organic',
        fns 'advanced-pressing', fns 'advanced-electronics',
    })
end

table.insert(assmacs['assembling-machine-3'].crafting_categories, fns 'tier-3-crafting')
table.insert(assmacs['electromagnetic-plant'].crafting_categories, fns 'advanced-electronics')
table.insert(assmacs['cryogenic-plant'].crafting_categories, fns 'advanced-crafting-cryogenics')
table.insert(assmacs['foundry'].crafting_categories, fns 'advanced-pressing')
table.insert(assmacs['biochamber'].crafting_categories, fns 'advanced-crafting-organic')

for category, names in pairs(assignments) do
    for _, name in ipairs(names) do
        if data.raw.recipe[name] then
            data.raw.recipe[name].category = category
        end
    end
end

table.insert(data.raw.technology.biolab.prerequisites, 'automation-3')
