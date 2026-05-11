require 'prelude'

local production = namespace 'production'

production.data = asset{
    '.fluids.water',
    '.fluids.boil-water',
    '.fluids.oil-processing',
    ['.entities.nuclear-energy'] = asset{ '.fluids.water' }
}

return production:seal()