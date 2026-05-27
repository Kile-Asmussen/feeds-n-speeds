
local fns = require 'fns'

data:extend{{
    type = 'bool-setting',
    name = fns('restart-toggle'),
    order='a',
    setting_type = 'startup',
    default_value = true,
}}