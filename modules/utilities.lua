
local utilities = require('namespace')('utilities')

local set = table.intoset

utilities.settings = set{
    '.setting.restart-toggle'
}

utilities.control = set{
    '.simple-chat-commands'
}

utilities['data-updates'] = set{
    ['.assign-recipe-unlocks'] = set{
        'modules.production.recipes.update-barrels'
        'modules.integrations.textplates.unlocks'
    }
}

return utilities:seal()