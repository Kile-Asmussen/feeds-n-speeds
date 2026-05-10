require 'prelude'

local utilities = namespace 'modules.utilities'

utilities.settings = asset{
    'setting.restart-toggle'
}

utilities.control = asset{
    'reset-tech'
}

return seal_namespace(utilities)