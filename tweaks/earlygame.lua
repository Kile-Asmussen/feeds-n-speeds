require 'prelude'

local utilities = require 'extras.utilities'

local earlygame = namespace 'tweaks.earlygame'
earlygame.enabled = true

function earlygame.data()
    if not earlygame.enabled then return end

    data:extend{ require 'tweaks.earlygame.lab-technology' }
end

function earlygame.data2()
    if not earlygame.enabled then return end

    earlygame.tweak_technologies()
    earlygame.tweak_recipes()

end

function earlygame.tweak_technologies()
    data.raw.recipe['iron-chest'].enabled = false

    utilities.remove_unlock('iron-stick')

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

    if enabled('extras.chests') then
        table.append(tech.automation.effects, {
            { type = 'unlock-recipe', recipe = fns 'big-steel-chest' },
            { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
        })
    end

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

    if not enabled('tweaks.technologies') then
        table.insert(tech['steam-power'].effects,
            { type = 'unlock-recipe', recipe = 'transport-belt' }
        )
    end

    table.insert(tech['steam-power'].effects,
        { type = 'unlock-recipe', recipe = 'burner-mining-drill' }
    )

    data.raw.recipe['burner-mining-drill'].enabled = false


    if enabled('extras.altrecipes') then
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
    end
end

function earlygame.tweak_recipes()
    local recipe = data.raw.recipe

    recipe['stone-brick'].enabled = false
    recipe['burner-inserter'].enabled = false
    recipe['burner-inserter'].hidden = true
    recipe['transport-belt'].enabled = false
    recipe['iron-gear-wheel'].enabled = false
end

return seal_namespace(earlygame)