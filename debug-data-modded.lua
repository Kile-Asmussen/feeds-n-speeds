--! Inspect data.raw with mod prototypes merged
--!
--! Usage:
--!   DEPTH=2 lua inspect-data.lua container feeds-n-speeds-big-steel-chest
--!   DEPTH=1 lua inspect-data.lua recipe
--!
--! Loads all mod stages silently, then inspects data.raw.
--! For verbose loading output, use debug-load.lua instead.

require 'prelude'


-- Load test harness (sets up data.raw from raw.lua)
require 'test'

-- Suppress logging during load (use debug-load.lua for verbose output)
local real_log = log
function log() end

-- Load mod stages (populates data.raw via data:extend)
require('settings')
require('settings-updates')
require('settings-final-fixes')
_G.settings = import('settings'):__seal()

require('data')
require('data-updates')
require('data-final-fixes')

-- Restore print for output
log = real_log

local debuglib = require 'debuglib'

local args = table.pack(...)

local ix = 'data' .. debuglib.descent('raw', table.unpack(args))
local result, found = table.descend(data.raw, table.unpack(args))

if found then
    log(ix .. ' = ' .. debuglib.sprint(result))
else
    log('Path not found: ' .. ix)
    if result ~= nil then
        log('Stopped at value of type: ' .. type(result))
    end
end
