require 'prelude'
local tweaks = require 'tweaks'
local extras = require 'extras'

data:extend{
   {
        type = 'bool-setting',
        name = fns 'restart-toggle',
        setting_type = 'startup',
        default_value = true,
    } 
}

extras.create_toggles()
tweaks.create_toggles()

extras.settings()
tweaks.settings()
