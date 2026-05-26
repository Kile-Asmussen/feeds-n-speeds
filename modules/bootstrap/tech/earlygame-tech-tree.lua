
local tools = require 'gadgets'


local tech = data.raw.technology
local recipe = data.raw.recipe

for _, name in ipairs{ 'iron-stick', 'steel-plate', 'iron-gear-wheel', 'iron-chest', 'steel-chest' } do
    recipe[name].auto_unlocked_by = 'steel-processing'
end

data.recipe['iron-stick']

table.merge(tech['steel-processing'], {
    research_trigger = assoc{
        count = 10,
        item = 'iron-plate',
        type = 'craft-item'
    },
    unit = functions.null,
    prerequisites = functions.null,
    localised_description = {fns_locale_key('technology-description', 'tweaked-steel-processing')}
})

tech['electronics'].localised_description = {fns_locale_key("technology-description", 'tweaked-electronics') }



tech.automation.effects = array{
    assoc{ type = 'unlock-recipe', recipe = 'assembling-machine-1' },
    assoc{ type = 'unlock-recipe', recipe = 'long-handed-inserter' },
    assoc{ type = 'unlock-recipe', recipe = fns 'big-steel-chest' },
    assoc{ type = 'unlock-recipe', recipe = fns 'big-steel-hopper' },
}

table.merge(tech['steam-power'], {
    localised_description = { fns_locale_key('technology-description', 'tweaked-steam-power') },
    research_trigger = assoc{
        count = 10,
        item = 'steel-plate',
        type = 'craft-item'
    },
    prerequisites = array{
        'steel-processing',
        'electronics',
        fns 'basic-materials-processing',
    },
})

-- tech['steam-power'].localised_description = { fns_locale_key('technology-description', 'tweaked-steam-power') }

-- tech['steam-power'].research_trigger = assoc{
--     count = 10,
--     item = 'steel-plate',
--     type = 'craft-item'
-- }

-- tech['steam-power'].prerequisites = array{
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