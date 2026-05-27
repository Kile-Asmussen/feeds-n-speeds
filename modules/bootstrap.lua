
local bootstrap = require('namespace')('bootstrap')

local set = table.intoset

bootstrap.data = set{
    '.recipes.stone-furnace-alt',

    '.entities.enrich-rocks',

    ['.entities.miners'] = set{
        
    },

    '.tech.earlygame-tech-tree',
    '.tech.wet-drilling',
    '.tech.lab-tech',    

    '.worldgen.sulfur-ore',
    '.worldgen.sulfur-ore-noise-expressions',
    '.worldgen.sulfur-item-variations',

    ['.worldgen.fix-ore-config'] = set{
        '.worldgen.sulfur-ore',
        '.worldgen.sulfur-ore-noise-expressions',
    }
}

bootstrap.control = set{
    '.scripts.freeplay'
}

return bootstrap:seal()