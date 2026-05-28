
local production = require('namespace')('production')

local set = table.intoset

production.data = set{
    '.energy.electroboiler',
    ['.energy.nuclear-energy'] = set{ '.fluids.water' },

    '.fluids.barrel-tapper',
    '.fluids.oil-processing',
    '.fluids.water',
    ['.fluids.boil-water'] = set{ '.fluids.water' },

    '.recipes.casting',
    '.recipes.concrete',
    ['.recipes.crafting-categories'] = -1,

    '.ores.starting-patch-shape',

    ['.machines'] = -1,
}

production['data-updates'] = set{
    '.fluids.update-barrels'
}

return production:seal()