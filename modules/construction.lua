
local construction = require('namespace')('construction')

construction.data = asset{
    '.recipes.crafting-times',
    '.entities.mining-times',
    '.tiles.collision-layers',
    ['.entities.pavement'] = asset{
        'modules.bootstrap.entities.burner-miner',
        'modules.bootstrap.entities.electric-miner',
    }
}

return construction:seal()