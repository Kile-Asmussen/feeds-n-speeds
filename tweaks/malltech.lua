require 'prelude'

local malltech = namespace 'tweaks.malltech'
malltech.enabled = true

function malltech.data()
    if not malltech.enabled then return end

    malltech.tweak_recipes()
    malltech.tweak_technologies()
end

function malltech.tweak_technologies()
    local tech = data.raw.technology

    table.insert(tech['automation-2'].prerequisites, 'fast-inserter')
end

function malltech.tweak_recipes()
    local recipe = data.raw.recipe

    malltech.assembling_machines()
    
    local tweaks = import 'tweaks'

    if tweaks.earlygame.enabled then
        malltech.mining_drills()
    end

    if tweaks.nuclear.enabled then
        malltech.nuclear_machines()
    end
end

function malltech.mining_drills()
    local recipe = data.raw.recipe

    recipe['burner-mining-drill'].ingredients = {
        { type='item', name='stone-brick', amount=6 },
        { type='item', name='iron-gear-wheel', amount=2 },
        { type='item', name='steel-plate', amount=1 },
    }

    recipe['electric-mining-drill'].ingredients = {
        { type='item', name='electronic-circuit', amount=3 },
        { type='item', name='iron-gear-wheel', amount=5 },
        { type='item', name='iron-plate', amount=5 },
        { type='item', name='steel-plate', amount=2 },
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

function malltech.assembling_machines()
    local recipe = data.raw.recipe

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

function malltech.nuclear_machines()
    data.raw.recipe['steam-turbine'].ingredients = {
        { type='item', name='electric-engine-unit', amount=10 },
        { type='item', name='steel-plate', amount=20 },
        { type='item', name='pipe', amount=50 },
    }

    data.raw.recipe['heat-exchanger'].ingredients = {
        { type='item', name='heat-pipe', amount=10 },
        { type='item', name='engine-unit', amount=20 },
        { type='item', name='pipe', amount=50 },
    }

    data.raw.recipe['nuclear-reactor'].ingredients = {
        { type='item', name='concrete', amount=500 },
        { type='item', name='uranium-238', amount=100 },
        { type='item', name='advanced-circuit', amount=500 },
        { type='item', name='steel-plate', amount=250 },
        { type='item', name='electric-engine-unit', amount=100 },
        { type='item', name='heat-pipe', amount=100 },
    }

    data.raw.recipe.centrifuge = {
        { type='item', name='electric-engine-unit', amount=20 },
        { type='item', name='speed-module', amount=5 },
        { type='item', name='steel-plate', amount=50 },
        { type='item', name='iron-gear-wheel', amount=100 },
        { type='item', name='concrete', amount=100 },
    }
end

return malltech:__seal()