
local fns = require 'fns'
local icons = fns.gadgets.icons

local merge = fns.table.merge

data:extend{{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    essential = true,
    icons = icons{
        type = 'technology',
        '__base__/graphics/technology/research-speed.png',
    },
    effects = { { type = "unlock-circuit-network", modifier = true } },
    prerequisites = { 'steam-power' },
    research_trigger = {
        type = 'craft-item',
        item = 'steam-engine',
        amount = 1
    },
}}

table.remove_matching(data.raw.technology['circuit-network'].effects, { type = "unlock-circuit-network" })

table.merge(data.raw.technology, {
    __rec = true,
    ['steel-processing'] = {
        essential = true,
        research_trigger = {
            count = 20,
            item = 'iron-plate',
            type = 'craft-item'
        },
        unit = utils.null,
        prerequisites = utils.null,
        localised_description = {fns.locale_key('technology-description', 'tweaked-steel-processing')}
    },

    ['electronics'] = {
        localised_description = {fns.locale_key("technology-description", 'tweaked-electronics') },
        essential = true,
        research_trigger = {
            count = 10,
            item = 'copper-plate',
            type = 'craft-item'
        },
    },
    ['steam-power'] = {
        essential = true,
        localised_description = { fns.locale_key('technology-description', 'tweaked-steam-power') },
        research_trigger = {
            count = 10,
            item = 'steel-plate',
            type = 'craft-item'
        },
        prerequisites = {
            'steel-processing',
            'electronics',
            fns 'basic-materials-processing',
        },
    }
})