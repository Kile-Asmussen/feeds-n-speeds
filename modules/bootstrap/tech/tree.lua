
local fns = require 'fns'

local tech = data.raw.technology

data:extend{{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    icons = {
        {
            icon = '__base__/graphics/technology/research-speed.png',
            icon_size = 256
        },
    },
    prerequisites = { 'steam-power' },
    research_trigger = {
        type = 'craft-item',
        item = 'steam-engine',
        amount = 1
    },
}}

table.merge(tech['steel-processing'], {
    research_trigger = {
        count = 20,
        item = 'iron-plate',
        type = 'craft-item'
    },
    unit = functions.null,
    prerequisites = functions.null,
    localised_description = {fns.locale_key('technology-description', 'tweaked-steel-processing')}
})

table.merge(tech['electronics'], {
    localised_description = {fns.locale_key("technology-description", 'tweaked-electronics') },
    research_trigger = {
        count = 10,
        item = 'copper-plate',
        type = 'craft-item'
    },
})

table.merge(tech['steam-power'], {
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
})