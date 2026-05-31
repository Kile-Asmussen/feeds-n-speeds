--! data: move pre-science tech tree around

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

data.raw.technology['automation-science-pack'].prerequisites = { fns 'lab-tech' }

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

merge(data.raw.recipe, {
    __rec = true,
    [{
        'transport-belt',
        'inserter',
        'lab'
    }] = { auto_unlocked_by = fns 'lab-tech' },
    [{
        'iron-stick',
        'steel-plate',
        'iron-gear-wheel',
        'iron-chest'
    }] = { auto_unlocked_by = 'steel-processing' },

    ['burner-inserter'] = {auto_unlocked_by = 'steam-power'},
})

data.raw.recipe['repair-pack'].auto_unlocked_by = fns 'lab-tech'
data.raw.technology['repair-pack'] = nil