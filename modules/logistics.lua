
local logistics = require('namespace')('logistics')

local set = table.intoset

logistics.data = table.set{
    '.chests.big-steel',
    '.chests.hopper',
    ['.chests.extant'] = -1,

    '.entities.electric-link',
    '.entities.electric-poles',
    '.entities.robotics',

    ['.items.stack-sizes'] = -1,

    '.recipes.rails',
}

return logistics:seal()