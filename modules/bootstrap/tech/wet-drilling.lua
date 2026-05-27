
local fns = require 'fns'
local tech = data.raw.technology

tech['uranium-mining'] = nil

local uranium = tech['uranium-processing']

table.merge(tech['uranium-processing'], {
    prerequisites = { fns 'wet-drilling', 'concrete', 'chemical-science-pack' },
    research_trigger = functions.null,
    unit = {
        count = 100,
        time = 30,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
        },
    }
})

local wet = {
    type = 'technology',
    name = fns 'wet-drilling',
    icons = {
        {
            icon = '__base__/graphics/technology/steam-power.png',
            icon_size = 256,
        },
        {
            icon = '__base__/graphics/technology/mining-productivity.png',
            icon_size = 256,
        },
    },
    prerequisites = { 'steam-power' },
    effects = { { type = 'mining-with-fluid', modifier = true, } },
    research_trigger = { type = 'build-entity', entity = 'offshore-pump', },
}

tech['electric-mining-drill'].prerequisites = { 'automation-science-pack', fns 'wet-drilling' }

data:extend{wet}