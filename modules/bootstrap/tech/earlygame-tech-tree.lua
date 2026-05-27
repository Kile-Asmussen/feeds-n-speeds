
local tools = require 'gadgets'


local tech = data.raw.technology
local recipe = data.raw.recipe

for _, name in ipairs{ 'iron-stick', 'steel-plate', 'iron-gear-wheel', 'iron-chest', 'steel-chest' } do
    recipe[name].auto_unlocked_by = 'steel-processing'
end

table.merge(tech['steel-processing'], {
    research_trigger = {
        count = 10,
        item = 'iron-plate',
        type = 'craft-item'
    },
    unit = functions.null,
    prerequisites = functions.null,
    localised_description = {fns_locale_key('technology-description', 'tweaked-steel-processing')}
})

tech['electronics'].localised_description = {fns_locale_key("technology-description", 'tweaked-electronics') }

data.raw.recipe['assembling-machine-1'].auto_unlocked_by = 'automation'

tech.automation.effects = {
    { type = 'unlock-recipe', recipe = 'assembling-machine-1' },
    { type = 'unlock-recipe', recipe = 'long-handed-inserter' },
    { type = 'unlock-recipe', recipe = fns 'big-steel-chest' },
    { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' },
}

table.merge(tech['steam-power'], {
    localised_description = { fns_locale_key('technology-description', 'tweaked-steam-power') },
    research_trigger = {
        count = 10,
        item = 'steel-plate',
        type = 'craft-item'
    },
    prerequisites = {
        'steel-processing',
        'electronics',
        fns 'basic-materials-processing',
    },
})

-- tech['steam-power'].localised_description = { fns_locale_key('technology-description', 'tweaked-steam-power') }

-- tech['steam-power'].research_trigger = {
--     count = 10,
--     item = 'steel-plate',
--     type = 'craft-item'
-- }

-- tech['steam-power'].prerequisites = {
--     'steel-processing',
--     'electronics',
--     fns 'basic-materials-processing',
-- }

-- table.append(tech['steam-power'].effects, {
--     { type = 'unlock-recipe', recipe = 'transport-belt' },
--     { type = 'unlock-recipe', recipe = 'burner-mining-drill' },
-- })

for _, recipe in ipairs{
    'iron-chest',
    'stone-brick',
    'burner-inserter',
    'transport-belt',
    'iron-gear-wheel',
    } do
    data.raw.recipe[recipe].enabled = false
end