require 'prelude'

local utilities = namespace 'utilities'

utilities.settings = asset{
    '.setting.restart-toggle'
}

utilities.control = asset{
    '.simple-chat-commands'
}

utilities['data-updates'] = asset{
    ['.assign-recipe-unlock'] = asset{ 'modules.production.recipes.update-barrels' }
}

return utilities:seal()