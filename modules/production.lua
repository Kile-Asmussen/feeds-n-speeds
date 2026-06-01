--! settings, data, data-updates: submodule governing changes to production mechanics including new altered/recipes for intermediary products, rebalancing of crafting, etc.

local fns = require 'fns'
local table = fns.table
local production = require('namespace')('production')

local set = table.intoset

production.settings = set{
    '.ores.infinite-setting',
}

production.data = set{
    ['.energy.electroboiler'] = set { '.fluids.boil-water' },
    ['.energy.nuclear-energy'] = set{ '.fluids.water' },
    ['.energy.mini-reactor'] = set{ '.energy.electroboiler', '.energy.nuclear-energy' },

    '.fluids.barrel-tapper',
    '.fluids.oil-processing',
    '.fluids.water',
    ['.fluids.boil-water'] = set{ '.fluids.water' },

    ['.ores.infinite'] = set{ 'modules.bootstrap.worldgen.sulfur-ore' },

    '.recipes.crafting-times',
    '.recipes.casting',
    '.recipes.concrete',
    '.recipes.misc',
    '.recipes.sulfur-processing',
    ['.recipes.crafting-categories'] = -1,
    '.recipes.batteries-and-modules',

    '.science.packs',

    ['.machines'] = -1,
}

production['data-updates'] = set{
    '.fluids.update-barrels',

}

return production:seal()