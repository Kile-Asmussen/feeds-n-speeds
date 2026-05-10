require 'prelude'

local utilities = namespace 'modules.utilities'

utilities.settings = asset{
    'setting.restart-toggle'
}

return seal_namespace(utilities)