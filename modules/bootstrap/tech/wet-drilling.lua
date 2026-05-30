--! data: earlygame tech for mining with fluid, to allow sulfur mining
local fns = require 'fns'
local merge = fns.table.merge
local icons = fns.gadgets.icons

local tech = data.raw.technology

fns.gadgets.remove_technologies('uranium-mining')

data.raw.technology['electric-mining-drill'].prerequisites = { 'automation-science-pack', fns 'wet-drilling' }

local wet = {
    type = 'technology',
    name = fns 'wet-drilling',
    essential = true,
    icons = icons{ type='technology',
        'technology/steam-power.png',
        'technology/mining-productivity.png',
    },
    prerequisites = { 'steam-power' },
    effects = { { type = 'mining-with-fluid', modifier = true, } },
    research_trigger = { type = 'build-entity', entity = 'offshore-pump', },
}

data:extend{wet}