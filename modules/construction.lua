
local construction = require('namespace')('construction')

local set = table.intoset

construction.data = set{
    '.recipes.crafting-times',
    '.entities.mining-times',
    '.tiles.collision-layers',
    ['.entities.pavement'] = set{
        'modules.bootstrap.entities.burner-miner',
        'modules.bootstrap.entities.electric-miner',
    }
}

return construction:seal()