require 'prelude'

local earlygame = namespace 'tweaks.earlygame'
earlygame.enabled = true

function earlygame.data_updates()
    if not earlygame.enabled then return end

    earlygame.tweak_technologies()
    earlygame.tweak_recipes()
    earlygame.tweak_military()
end

function earlygame.tweak_military()
    local extras = import 'extras'
    local tweaks = import 'tweaks'

    local tech = data.raw.technology
    local recipes = data.raw.recipe

    recipes['submachine-gun'].ingredients = {
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'item', name = 'iron-plate', amount = 2 },
        { type = 'item', name = 'copper-plate', amount = 2 },
    }

    -- Enable vanilla pistol recipe (normally hidden since player starts with one)
    recipes['pistol'].hidden = false
    recipes['pistol'].enabled = true
    recipes['pistol'].ingredients = {
        { type = 'item', name = 'copper-plate', amount = 1 },
        { type = 'item', name = 'iron-plate', amount = 3 },
    }

    if
        extras.ores.enabled
        and extras.drills.enabled
        and tweaks.sulfur_processing.enabled
    then
        recipes['firearm-magazine'].energy_required = 2
        recipes['firearm-magazine'].ingredients = {
            { type = 'item', name = 'iron-plate', amount = 2 },
            { type = 'item', name = 'copper-plate', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }
        recipes['firearm-magazine'].results = {
            { type = 'item', name = 'firearm-magazine', amount = 2 },
        }

        recipes['piercing-rounds-magazine'].ingredients = {
            { type = 'item', name = 'steel-plate', amount = 1 },
            { type = 'item', name = 'firearm-magazine', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }

        recipes['shotgun-shell'].energy_required = 6
        recipes['shotgun-shell'].ingredients = {
            { type = 'item', name = 'copper-plate', amount = 2 },
            { type = 'item', name = 'iron-plate', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }
        recipes['shotgun-shell'].results = {
            { type = 'item', name = 'shotgun-shell', amount = 2 },
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

    end


end

function earlygame.tweak_technologies()
    data.raw.recipe['iron-chest'].enabled = false

    local tech = data.raw.technology

    tech['steel-processing'].research_trigger = {
        count = 20,
        item = 'iron-plate',
        type = 'craft-item'
    }

    tech['steel-processing'].unit = nil
    tech['steel-processing'].prerequisites = nil

    tech['steel-processing'].effects = {
        { type = 'unlock-recipe', recipe = 'steel-plate' },
        { type = 'unlock-recipe', recipe = 'iron-stick' },
        { type = 'unlock-recipe', recipe = 'iron-gear-wheel' },
        { type = 'unlock-recipe', recipe = 'iron-chest' },
        { type = 'unlock-recipe', recipe = 'steel-chest' }
    }

    tech['steel-processing'].localised_description = {'technology-description.feeds-n-speeds-tweaked-steel-processing'}

    local extras = import 'extras'

    if extras.chests.enabled then

        table.remove_matching(tech['automation-2'].effects,
            table.matches{
                { type = 'unlock-recipe', recipe = 'assembling-machine-2' }
            }
        )

        table.remove_matching(tech['automation-2'].effects,
            table.matches{
                { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
            }
        )

        table.insert(tech['steel-processing'].effects,
            { type = 'unlock-recipe', recipe = fns 'big-steel-chest' }
        )

        table.insert(tech.automation.effects,
            { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
        )

        table.remove_matching(tech['automation-2'].effects,
            table.matches{ type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
        )
    end

    local steam_power = data.raw.technology['steam-power']

    steam_power.research_trigger = {
        count = 10,
        item = 'steel-plate',
        type = 'craft-item'
    }

    steam_power.prerequisites = {
        'steel-processing',
        'electronics',
    }

    -- Move transport belts to logistics (sadistic early game)
    table.insert(tech.logistics.effects, 1,
        { type = 'unlock-recipe', recipe = 'transport-belt' }
    )

    table.insert(tech['logistic-science-pack'].prerequisites, 'logistics')

    if extras.altrecipes.enabled then
        tech[fns 'basic-materials-processing'].research_trigger = {
            type = 'craft-item',
            item = 'stone-furnace',
            count = 3,
        }

        table.append(tech[fns 'basic-materials-processing'].effects, {
            { type = 'unlock-recipe', recipe = 'stone-brick' },
            { type = 'unlock-recipe', recipe = 'burner-mining-drill' },
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

function earlygame.data_final_fixes()

    for name, tech in pairs(data.raw.technology) do
        if name ~= 'steel-processing' then
            if tech.effects then
                table.remove_matching(tech.effects,
                    table.matches{ recipe = 'iron-stick', type = 'unlock-recipe'}
                )
            end
        end
    end

end

return earlygame:__seal()