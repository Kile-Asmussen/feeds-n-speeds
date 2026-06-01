--! settings, data-updates, control: submodule of utility scripts that don't fit other categories, such as the auto_unlocked_by field for recipes

local fns = require 'fns'
local table = fns.table
local utilities = require('namespace')('utilities')

local set = table.intoset

utilities.settings = set{
    '.setting.restart-toggle'
}

utilities.control = set{
    '.reset-tech'
}

utilities.data = set{
    ['.tech-tweaks'] = -1,
    '.map-gen-presets',
}

utilities['data-updates'] = set{
    ['.assign-recipe-unlocks'] = set{
        'modules.production.fluids.update-barrels',
        'modules.integrations.textplates.unlocks',
    }
}

return utilities:seal()