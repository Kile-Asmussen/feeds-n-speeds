--! data, control: submodule governing changes to the logistics

local fns = require 'fns'
local table = fns.table
local logistics = require('namespace')('logistics')

local set = table.intoset

logistics.data = set{
    '.chests.extant',
    ['.chests.hopper'] = set{ '.chests.extant' },

    '.entities.electric-link',
    '.electric-poles',

    ['.items.stack-sizes'] = -1,
    ['.inserters'] = -1,

    '.railway.concrete-rails',

    '.robotics.battery',
    '.robotics.robotics',
}

logistics.control = set{
    '.chests.hopper-control'
}

return logistics:seal()