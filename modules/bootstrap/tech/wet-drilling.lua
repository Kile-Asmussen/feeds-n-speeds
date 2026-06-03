--! data: earlygame tech for mining with fluid, to allow sulfur mining
local fns = require 'fns'
local merge = fns.table.merge
local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

local tech = data.raw.technology

fns.gadgets.remove_technologies('uranium-mining')

data.raw.technology['electric-mining-drill'].prerequisites = { 'automation-science-pack', fns 'wet-drilling' }

local wet = {
    type = 'technology',
    name = fns 'wet-drilling',
    essential = true,
    icons = {
        icon('technology/steam-power.png', 'technology'),
        icon('technology/mining-productivity.png', 'technology'),
    },
    prerequisites = { 'steam-power' },
    effects = { { type = 'mining-with-fluid', modifier = true, } },
    research_trigger = { type = 'build-entity', entity = 'offshore-pump', },
}

data:extend{wet}