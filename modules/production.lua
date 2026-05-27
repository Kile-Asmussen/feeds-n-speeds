
local production = require('namespace')('production')

local set = table.intoset

production.data = set{
    '.fluids.water',
    '.fluids.oil-processing',
    ['.fluids.boil-water'] = set{ '.fluids.water' },

    '.fluids.barrel-tapper',
    '.recipes.concrete',
    '.recipes.casting',

    ['.entities.nuclear-energy'] = set{ '.fluids.water' }
}

production['data-updates'] = set{
    '.recipes.update-barrels'
}

return production:seal()