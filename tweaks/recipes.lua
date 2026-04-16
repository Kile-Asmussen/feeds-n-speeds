require 'prelude'

local alteredrecipes = namespace 'alteredrecipes'
alteredrecipes.enabled = true

function alteredrecipes.data_updates()
    if not alteredrecipes.enabled then return end

    alteredrecipes.tweak_recipes()
end

function alteredrecipes.tweak_technologies()
    data.raw.recipe['iron-chest'].enabled = false

    local tech = data.raw.technolog

    table.insert(tech['automation-2'].prerequisites, 'fast-inserter')
end

function alteredrecipes.tweak_recipes()
    local recipe = data.raw.recipe

    recipe['burner-inserter'] = nil

    recipe['assembly-machine'].ingredients = {
        { type='item', name='inserter', amount=2 },
        { type='item', name='transport-belt', amount=2 },
        { type='item', name='electronic-circuit', amount=1 },
        { type='item', name='iron-plate', amount=4 },
    }

    recipe['assembly-machine-2'].ingredients = {
        { type='item', name='assembly-machine', amount=1 },
        { type='item', name='fast-inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=6 },
        { type='item', name='steel-plate', amount=2 },
    }

    recipe['assembly-machine-3'].ingredients = {
        { type='item', name='assembly-machine-2', amount=1 },
        { type='item', name='fast-transport-belt', amount='4' }
        { type='item', name='speed-module', amount=3 },
        { type='item', name='steel-plate', amount=4 },
    }

    local tweaks = import 'tweaks'

    if tweaks.earlygame.enabled then

        recipe['burner-mining-drill'].ingredients = {
            { type='item', name='stone-brick', amount=4 },
            { type='item', name='iron-gear', amount=2 },
            { type='item', name='steel-plate', amount=1 },
        }

        recipe['electric-mining-drill'].ingredients = {
            { type='item', name='electronic-circuit', amount=3 },
            { type='item', name='iron-gear', amount=5 },
            { type='item', name='steel-plate', amount=2 },
        }

        recipe['boiler'].ingredients = {
            { type='item', name='stone-brick', amount=4 },
            { type='item', name='pipe', amount=4 },
            { type='item', name='copper-plate', amount=2 },
        }

        recipe['steam-engine'].ingredients = {
            { type='item', name='copper-wire', amount=6 },
            { type='item', name='iron-gear', amount=4 },
            { type='item', name='pipe', amount=5 },
            { type='item', name='steel-plate', amount=2 },
        }
    end
    
end

function alteredrecipes.data_final_fixes()

    for name, tech in pairs(data.raw.technology) do
        if name ~= 'steel-processing' then
            table.remove_matching(tech.effects,
                table.matches{name = 'iron-stick', type = 'unlock-recipe'}
            )
        end
    end

end