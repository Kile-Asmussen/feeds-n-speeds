require 'prelude'

local tools = require 'tools'

return function()

    tools.remove_unlock('iron-stick')

    local tech = data.raw.technology

    local steel = tech['steel-processing']

    steel.research_trigger = {
        count = 10,
        item = 'iron-plate',
        type = 'craft-item'
    }

    steel.unit = nil
    steel.prerequisites = nil

    steel.effects = {
        { type = 'unlock-recipe', recipe = 'steel-plate' },
        { type = 'unlock-recipe', recipe = 'iron-stick' },
        { type = 'unlock-recipe', recipe = 'iron-gear-wheel' },
        { type = 'unlock-recipe', recipe = 'iron-chest' },
        { type = 'unlock-recipe', recipe = 'steel-chest' }
    }

    steel.localised_description = {"", {fns_locale_key('technology-description', 'tweaked-steel-processing')}}

    table.remove_matching(tech['electronics'].effects, {recipe='inserter'})
    tech['electronics'].localised_description = {"", {fns_locale_key("technology-description", 'tweaked-electronics')}}

    table.append(tech.automation.effects, {
        { type = 'unlock-recipe', recipe = fns 'big-steel-chest' },
        { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
    })

    local steam_power = data.raw.technology['steam-power']

    steam_power.localised_description = {"", { fns_locale_key('technology-description', 'tweaked-steam-power') } }

    steam_power.research_trigger = {
        count = 10,
        item = 'steel-plate',
        type = 'craft-item'
    }

    steam_power.prerequisites = {
        'steel-processing',
        'electronics',
    }

    table.insert(tech['steam-power'].effects,
        { type = 'unlock-recipe', recipe = 'transport-belt' }
    )

    table.insert(tech['steam-power'].effects,
        { type = 'unlock-recipe', recipe = 'burner-mining-drill' }
    )

    data.raw.recipe['burner-mining-drill'].enabled = false


    tech[fns 'basic-materials-processing'].research_trigger = {
        type = 'craft-item',
        item = 'stone-furnace',
        count = 3,
    }

    table.append(tech[fns 'basic-materials-processing'].effects, {
        { type = 'unlock-recipe', recipe = 'stone-brick' },
    })

    table.insert(tech['steam-power'].prerequisites,
        fns 'basic-materials-processing'
    )

    for _, recipe in ipairs{
        'iron-chest',
        'stone-brick',
        'burner-inserter',
        'burner-inserter',
        'transport-belt',
        'iron-gear-wheel',
     } do
        data.raw.recipe[recipe].enabled = false
    end


end