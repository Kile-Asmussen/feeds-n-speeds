
local fns = require 'fns'

local inputs = require('gadgets').throughputs
local merge = fns.table.merge
local append = fns.table.append


local function ingredients(tbl)
    return merge{ ingredients = inputs(tbl) }
end

merge(data.raw.technology, {
    ['battery'] = merge{
        prerequisites = append{'plastics'},
    },
    ['modules'] = merge{
        prerequisites = append{'battery'},
    }
})

merge(data.raw.recipe, {
    ['battery'] = ingredients{
        ['copper-plate'] = 1,
        ['iron-plate'] = 1,
        ['sulfuric-acid'] = 20,
        ['plastic-bar'] = 1
    },

    ['speed-module'] = ingredients{
        ['battery'] = 2,
        ['electronic-circuit'] = 5,
        ['advanced-circuit'] = 5,
    },

    ['speed-module'] = ingredients{
        ['battery'] = 2,
        ['electronic-circuit'] = 5,
        ['advanced-circuit'] = 5,
    },
})