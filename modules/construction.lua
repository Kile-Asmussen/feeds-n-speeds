
local construction = require('namespace')('construction')

local set = table.intoset

construction.data = set{
    ['.entities.fix-quality'] = -1,

    ['.recipes.crafting-times'] = -1,
    
    '.tiles.collision-layers',
    ['.tiles.pavement'] = -1

}

construction['data-updates'] = set{
    '.tiles.auto-pavement'
}

return construction:seal()