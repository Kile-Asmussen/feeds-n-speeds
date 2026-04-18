require 'prelude'

local alteredrecipes = namespace 'tweaks.alteredrecipes'
alteredrecipes.enabled = true

function alteredrecipes.data()
    if not alteredrecipes.enabled then return end

    alteredrecipes.tweak_recipes()
    alteredrecipes.tweak_technologies()
end

function alteredrecipes.tweak_technologies()
    local tech = data.raw.technology

    table.insert(tech['automation-2'].prerequisites, 'fast-inserter')
end

function alteredrecipes.tweak_recipes()
    local recipe = data.raw.recipe


    local tweaks = import 'tweaks'

    if tweaks.earlygame.enabled then

        recipe['burner-mining-drill'].ingredients = {
            { type='item', name='stone-brick', amount=6 },
            { type='item', name='iron-gear-wheel', amount=2 },
            { type='item', name='steel-plate', amount=2 },
        }

        recipe['electric-mining-drill'].ingredients = {
            { type='item', name='electronic-circuit', amount=3 },
            { type='item', name='iron-gear-wheel', amount=5 },
            { type='item', name='steel-plate', amount=3 },
        }

        recipe['boiler'].ingredients = {
            { type='item', name='stone-brick', amount=8 },
            { type='item', name='pipe', amount=4 },
            { type='item', name='copper-plate', amount=2 },
        }

        recipe['steam-engine'].ingredients = {
            { type='item', name='copper-cable', amount=6 },
            { type='item', name='iron-gear-wheel', amount=4 },
            { type='item', name='pipe', amount=10 },
            { type='item', name='steel-plate', amount=2 },
        }

        recipe['offshore-pump'].ingredients = {
            { type='item', name='iron-gear-wheel', amount=4 },
            { type='item', name='steel-plate', amount=2 },
            { type='item', name='pipe', amount=3 },
            { type='item', name='electronic-circuit', amount=2 },
        }

    end

    if tweaks.nuclear.enabled then

        data.raw.recipe['steam-turbine'].ingredients = {
            { type='item', name='electric-engine-unit', amount=20 },
            { type='item', name='steel-plate', amount=20 },
            { type='item', name='pipe', amount=50 },
        }

        data.raw.recipe['heat-exchanger'].ingredients = {
            { type='item', name='heat-pipe', amount=10 },
            { type='item', name='engine-unit', amount=20 },
            { type='item', name='electronic-circuit', amount=20 },
            { type='item', name='pipe', amount=50 },
        }

        data.raw.recipe['nuclear-reactor'].ingredients = {
            { type='item', name='concrete', amount=500 },
            { type='item', name='uranium-238', amount=500 },
            { type='item', name='advanced-circuit', amount=500 },
            { type='item', name='steel-plate', amount=250 },
            { type='item', name='electric-engine-unit', amount=100 },
            { type='item', name='heat-pipe', amount=100 },
        }
    end
end

function alteredrecipes.assembling_machines()
    recipe['assembling-machine-1'].ingredients = {
        { type='item', name='inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='iron-plate', amount=4 },
    }

    recipe['assembling-machine-2'].ingredients = {
        { type='item', name='fast-inserter', amount=3 },
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='pipe', amount=2 },
        { type='item', name='steel-plate', amount=4 },
    }

    recipe['assembling-machine-3'].ingredients = {
        { type='item', name='fast-inserter', amount=3 },
        { type='item', name='speed-module', amount=3 },
        { type='item', name='pump', amount=1 },
        { type='item', name='refined-concrete', amount=4 },
    }
end

return alteredrecipes:__seal()