--! data: changes to recipes/tech tree relating to batteries/modules
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
        ingredients = inputs{
            ['battery'] = 2,
            ['electronic-circuit'] = 5,
            ['advanced-circuit'] = 5,
        }
    },
    ['beacon'] = {
        ingredients = inputs{
          ['efficiency-module'] = 2,
          ['copper-cable'] = 40,
          ['substation'] = 1,
        }
    }
})