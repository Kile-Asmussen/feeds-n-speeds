
local fns = require 'fns'
local modules = require 'modules'

print '--[[ settings.lua ]]'
modules.print_stage_loading_order 'settings'

print '--[[ data.lua ]]'
modules.print_stage_loading_order 'data'

print '--[[ data-updates.lua ]]'
modules.print_stage_loading_order 'data-updates'

print '--[[ control.lua ]]'
modules.print_stage_loading_order 'control'