
local logistics = require('namespace')('logistics')


logistics.data = asset{
    '.recipes.rails',
    '.entities.electric-link',
    '.items.stack-sizes'
}

return logistics:seal()