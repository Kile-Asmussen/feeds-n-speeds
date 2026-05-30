--! settings: a do-nothing startup setting to force complete game restart without needing to close the program
local fns = require 'fns'

data:extend{{
    type = 'bool-setting',
    name = fns('restart-toggle'),
    order='a',
    setting_type = 'startup',
    default_value = true,
}}