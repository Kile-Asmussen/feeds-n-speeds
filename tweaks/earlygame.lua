require 'prelude'

local earlygame = namespace 'earlygame'
earlygame.enabled = true

function earlygame.data_updates()
    if not earlygame.enabled then return end

    earlygame.tweak_technologies()
    earlygame.tweak_recipes()
end

function earlygame.tweak_technologies()
    data.raw.recipe['iron-chest'].enabled = false

    local tech = data.raw.technolog

    tech['steel-processing'].research_trigger = {
        count = 20,
        item = 'iron-plate',
        type = 'craft-item'
    }

    tech['steel-processing'].unit = nil
    tech['steel-processing'].prerequisites = nil

    tech['steel-processing'].effects = {
        { type = 'unlock-recipe', name = 'steel-plate' },
        { type = 'unlock-recipe', name = 'iron-stick' },
        { type = 'unlock-recipe', name = 'iron-chest' },
        { type = 'unlock-recipe', name = 'steel-chest' }
    }

    local extras = import 'extras'

    if extras.chests.enabled then

        tech['automation-2'].effects = {
            { type = 'unlock-recipe', name = 'assembling-machine-2' }
        }

        table.insert(tech['steel-processing'].effects,
            { type = 'unlock-recipe', name = fns 'big-steel-chest' }
        )

        table.insert(tech.automation.effects,
            { type = 'unlock-recipe', name = fns 'smart-big-steel-chest' }
        )

        table.insert(tech.automation.effects,
            { type = 'unlock-recipe', name = fns 'big-steel-hopper' }
        )
    end

    local steam_power = data.raw.technology['steam-power']

    steam_power.research_trigger = {
        count = 10,
        item = 'steel-plate',
        type = 'craft-item'
    }

    steam_power.prerequisites = {
        'steel-processing'
    }
end

function earlygame.tweak_recipes()
    local recipe = data.raw.recipe

    recipe['burner-inserter'] = nil

    recipe['assembly-machine'].ingredients = {
        { type='item', name='inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='iron-plate', amount=4 },
    }

    recipe['assembly-machine-2'].ingredients = {
        { type='item', name='fast-inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='steel-plate', amount=4 },
    }

    recipe['assembly-machine-3'].ingredients = {
        { type='item', name='fast-inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='steel-plate', amount=4 },
    }
    
end

function earlygame.data_final_fixes()

    for name, tech in pairs(data.raw.technology) do
        if name ~= 'steel-processing' then
            table.remove_matching(tech.effects,
                table.matches{name = 'iron-stick', type = 'unlock-recipe'}
            )
        end
    end

end