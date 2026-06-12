--! data: move pre-science tech tree around

local fns = require 'fns'
local table = fns.table
local utils = fns.utils
local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

local merge = fns.table.merge

data:extend{{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    essential = true,
    icons = {
        icon('__base__/graphics/technology/research-speed.png', 'technology'),
    },
    effects = { { type = "unlock-circuit-network", modifier = true } },
    prerequisites = { 'steam-power' },
    research_trigger = {
        type = 'build-entity',
        entity = 'steam-engine',
    },
}}

data.raw.technology['automation-science-pack'].prerequisites = { fns 'lab-tech' }

table.remove_matching(data.raw.technology['circuit-network'].effects, table.match{ type = "unlock-circuit-network" })

merge(data.raw.technology, {
    __rec = true,
    ['steel-processing'] = {
        essential = true,
        research_trigger = {
            count = 20,
            item = 'iron-plate',
            type = 'craft-item'
        },
        __del = {'unit', 'prerequisites'},
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
        'repair-pack',
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