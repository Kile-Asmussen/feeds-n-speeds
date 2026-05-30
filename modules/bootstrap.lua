-- Changes to the early game

local bootstrap = require('namespace')('bootstrap')

local set = table.intoset

bootstrap.data = set{
    '.entities.enrich-rocks',
    '.entities.miners',

    '.recipes.stone-furnace-alt',

    '.tech.tree',
    '.tech.unlocks',
    '.tech.wet-drilling',

    '.worldgen.sulfur-ore',
    '.worldgen.noise-expressions',
    '.worldgen.sulfur-item',
    ['.worldgen.fix-ore-config'] = set{
        '.worldgen.sulfur-ore',
        '.worldgen.noise-expressions',
    }
}

bootstrap.control = set{
    '.scripts.freeplay'
}

return bootstrap:seal()