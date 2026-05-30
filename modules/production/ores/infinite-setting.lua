-- settings: setting to enable/disable infinite ores
local fns = require 'fns'

data:extend{{
    type = 'bool-setting',
    name = fns('infinite-ores'),
    order='b',
    setting_type = 'startup',
    default_value = false,
}}