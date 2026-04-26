require 'prelude'
require 'test'

local localization = require 'test.localization'
local debuglib = require 'debuglib'

log("\nSETTINGS")
require('settings')

log("\nSETTINGS-UPDATES")
require('settings-updates')

log("\nSETTINGS-FINAL-FIXES")
require('settings-final-fixes')

begin_data_stage()

log("\nDATA")
require('data')

log("\nDATA-UPDATES")
require('data-updates')

log("\nDATA-FINAL-FIXES")
require('data-final-fixes')

log("\nCONTROL")
_G.storage = {}
require('control')

local rec_lim = debuglib.recursion_limit
debuglib.recursion_limit = 5
debuglib.pp(script.__handlers, "handlers")
debuglib.recursion_limit = rec_lim


log('\nLOCALIZATION')
log(localization.generate_stubs())