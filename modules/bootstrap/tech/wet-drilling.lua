require 'prelude'

local tech = data.raw.technology

tech['uranium-mining'] = nil

local uranium = tech['uranium-processing']

uranium.prerequisites = { fns 'wet-drilling', 'concrete', 'chemical-science-pack' }
uranium.research_trigger = nil
uranium.unit = {
    count = 100,
    time = 30,
    ingredients = {
        { 'automation-science-pack', 1 },
        { 'logistic-science-pack', 1 },
        { 'chemical-science-pack', 1 },
    },
}

local wet = assoc{
    type = 'technology',
    name = fns 'wet-drilling',
    order = 'a-b-b',  -- after steam-power (a-b-a)
    icons = array{
        assoc{
            icon = '__base__/graphics/technology/steam-power.png',
            icon_size = 256,
        },
        assoc{
            icon = '__base__/graphics/technology/mining-productivity.png',
            icon_size = 256,
        },
    },
    prerequisites = array{ 'steam-power' },
    effects = array{
        assoc{
            type = 'mining-with-fluid',
            modifier = true,
        },
        assoc{
            type = 'unlock-recipe',
            recipe = fns 'burner-mining-drill-fluid',
        },
    },
    research_trigger = assoc{
        type = 'craft-item',
        item = 'offshore-pump',
        amount = 1,
    },
}

prototype(wet)