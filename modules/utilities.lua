require 'prelude'

local utilities = namespace 'utilities'

utilities.settings = asset{
    'setting.restart-toggle'
}

utilities.control = asset{
    'simple-chat-commands'
}

return utilities:seal()