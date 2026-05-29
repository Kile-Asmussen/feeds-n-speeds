
local fns = require 'fns'

local inputs = fns.gadgets.throughputs
local merge = fns.table.merge
local append = fns.table.append

merge(data.raw.technology, {
    __rec = true,
    ['battery'] = { prerequisites = { 'plastics', 'sulfur-processing' }, },
    ['modules'] = { prerequisites = { 'battery', 'advanced-circuit', }, }
})

merge(data.raw.recipe, {
    __rec = true,
    ['battery'] = {
        ingredients = inputs{
            ['copper-plate'] = 1,
            ['iron-plate'] = 1,
            ['sulfuric-acid'] = 20,
            ['plastic-bar'] = 1
        }
    },

    [{
        'speed-module',
        'efficiency-module',
        'productivity-module',
        'quality-module',
    }] = {
        __merge = true,
        ingredients = inputs{
            ['battery'] = 2,
            ['electronic-circuit'] = 5,
            ['advanced-circuit'] = 5,
        }
    },
})