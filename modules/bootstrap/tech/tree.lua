
local fns = require 'fns'

local merge = fns.table.merge

data:extend{{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    essential = true,
    icons = {
        {
            icon = '__base__/graphics/technology/research-speed.png',
            icon_size = 256
        },
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
    ['steel-processing'] = table.merge{
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

    ['electronics'] = table.merge{
        localised_description = {fns.locale_key("technology-description", 'tweaked-electronics') },
        essential = true,
        research_trigger = {
            count = 10,
            item = 'copper-plate',
            type = 'craft-item'
        },
    },
    ['steam-power'] = table.merge{
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