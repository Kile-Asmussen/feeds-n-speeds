require 'prelude'

local production = namespace 'production'

production.data = asset{
    '.fluids.boil-water',
    ['.fluids.water'] = asset{ '.fluids.boil-water' },
    '.fluids.oil-processing',
    '.entities.barrel-tapper',
    '.recipes.concrete',
    ['.entities.nuclear-energy'] = asset{ '.fluids.water' }
}

production['data-updates'] = asset{
    '.recipes.update-barrels'
}

return production:seal()