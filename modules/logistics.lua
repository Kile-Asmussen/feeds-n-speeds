
local logistics = require('namespace')('logistics')

local set = table.intoset

logistics.data = table.set{
    '.recipes.rails',
    '.entities.electric-link',
    '.items.stack-sizes'
}

return logistics:seal()