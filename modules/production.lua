
local production = require('namespace')('production')

local set = table.intoset

production.settings = set{
    '.ores.infinite-setting',
}

production.data = set{
    '.energy.electroboiler',
    '.energy.mini-reactor',
    ['.energy.nuclear-energy'] = set{ '.fluids.water' },

    '.fluids.barrel-tapper',
    '.fluids.oil-processing',
    '.fluids.water',
    ['.fluids.boil-water'] = set{ '.fluids.water' },

    '.ores.infinite',
    '.ores.starting-patch-shape',

    '.recipes.casting',
    '.recipes.concrete',
    ['.recipes.crafting-categories'] = -1,
    '.recipes.modules',

    '.science.packs',

    ['.machines'] = -1,
}

production['data-updates'] = set{
    '.fluids.update-barrels'
}

return production:seal()