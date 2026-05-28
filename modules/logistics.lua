
local logistics = require('namespace')('logistics')

local set = table.intoset

logistics.data = set{
    '.chests.extant',
    ['.chests.hopper'] = set{ '.chests.extant' },

    '.entities.electric-link',
    '.entities.electric-poles',
    '.entities.robotics',

    ['.items.stack-sizes'] = -1,

    '.recipes.rails',

    '.tech.worker-robot-battery'
}

logistics.control = set{
    '.chests.hopper-control'
}

return logistics:seal()