
local production = namespace 'production'

production.data = asset{
    '.fluids.water',
    '.fluids.oil-processing',
    ['.fluids.boil-water'] = asset{ '.fluids.water' },

    '.fluids.barrel-tapper',
    '.recipes.concrete',
    '.recipes.casting',

    ['.entities.nuclear-energy'] = asset{ '.fluids.water' }
}

production['data-updates'] = asset{
    '.recipes.update-barrels'
}

return production:seal()