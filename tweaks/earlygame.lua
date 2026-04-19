require 'prelude'

local earlygame = namespace 'tweaks.earlygame'
earlygame.enabled = true

function earlygame.data_updates()
    if not earlygame.enabled then return end

    earlygame.tweak_technologies()
    earlygame.tweak_recipes()
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
        { type = 'unlock-recipe', recipe = 'iron-chest' },
        { type = 'unlock-recipe', recipe = 'steel-chest' }
    }

    tech['steel-processing'].localised_description = 'Unlocks steel plates and iron sticks, as well as iron and steel chests.'

    local extras = import 'extras'

    if extras.chests.enabled then

        table.remove_matching(tech['automation-2'].effects,
            table.matches{
                { type = 'unlock-recipe', recipe = 'assembling-machine-2' }
            }
        )

        table.insert(tech['steel-processing'].effects,
            { type = 'unlock-recipe', recipe = fns 'big-steel-chest' }
        )

        table.insert(tech.automation.effects,
            { type = 'unlock-recipe', recipe = fns 'big-steel-hopper' }
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
end

function earlygame.tweak_recipes()
    local recipe = data.raw.recipe

    recipe['burner-inserter'] = nil
    recipe['transport-belt'].enabled = false
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