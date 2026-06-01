--! data, control: submodule governing changes to the early game stage of play

local fns = require 'fns'
local table = fns.table
local bootstrap = require('namespace')('bootstrap')

local set = table.intoset

bootstrap.data = set{
    '.entities.enrich-rocks',
    '.miners',

    '.recipes.stone-furnace-alt',
    '.recipes.hand-engine',

    '.tech.tree',
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