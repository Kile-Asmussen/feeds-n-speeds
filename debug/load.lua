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

_G.settings = import('test.settings'):__seal()
data.raw = require('test.rawdata')

log("\nDATA")
require('data')

log("\nDATA-UPDATES")
require('data-updates')

log("\nDATA-FINAL-FIXES")
require('data-final-fixes')

_G.storage = {}

log("\nCONTROL")
require('control')

log('\nLOCALIZATION')
log(localization.generate_stubs())