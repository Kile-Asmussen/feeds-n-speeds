
local fns = require 'fns'
local tech = data.raw.technology

tech['uranium-mining'] = nil


local wet = {
    type = 'technology',
    name = fns 'wet-drilling',
    essential = true,
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