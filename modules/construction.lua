require 'prelude'

local construction = namespace 'construction'

construction.data = asset{
    '.recipes.crafting-times',
    '.entities.mining-times',
    '.tiles.collision-layers',
    ['.entities.pavement'] = asset{
        'module.bootstrap.entities.burnder-miner',
        'module.bootstrap.entities.electric-miner',
    }
}

return seal_namespace(construction)