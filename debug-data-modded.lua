--! Inspect data.raw with mod prototypes merged
--!
--! Usage:
--!   DEPTH=2 lua inspect-data.lua container feeds-n-speeds-big-steel-chest
--!   DEPTH=1 lua inspect-data.lua recipe
--!
--! Loads all mod stages silently, then inspects data.raw.
--! For verbose loading output, use debug-load.lua instead.

require 'prelude'

-- Suppress logging during load (use debug-load.lua for verbose output)
local real_print = print
function log() end
function print() end

-- Load test harness (sets up data.raw from raw.lua)
require 'test'

-- Load mod stages (populates data.raw via data:extend)
require('settings')
require('settings-updates')
require('settings-final-fixes')
_G.settings = import('settings'):__seal()

require('data')
require('data-updates')
require('data-final-fixes')

-- Restore print for output
print = real_print

local debuglib = require 'debuglib'

local args = table.pack(...)

local ix = 'data' .. debuglib.descent('raw', table.unpack(args))

print(ix .. ' = ' .. debuglib.sprint(table.descend(data.raw, table.unpack(args))))
