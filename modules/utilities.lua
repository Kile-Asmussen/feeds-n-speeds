
local utilities = namespace 'utilities'

utilities.settings = asset{
    '.setting.restart-toggle'
}

utilities.control = asset{
    '.simple-chat-commands'
}

utilities['data-updates'] = asset{
    ['.assign-recipe-unlocks'] = asset{
        'modules.production.recipes.update-barrels'
        'modules.integrations.textplates.unlocks'
    }
}

return utilities:seal()