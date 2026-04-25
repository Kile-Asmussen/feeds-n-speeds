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
data.__begin_proxy()

log("\nDATA")
require('data')

log(table.concat(table.sorted_keys(data.__changes), '\n'))
data.__changes = {}

log("\nDATA-UPDATES")
require('data-updates')

log(table.concat(table.sorted_keys(data.__changes), '\n'))
data.__changes = {}

log("\nDATA-FINAL-FIXES")
require('data-final-fixes')

log(table.concat(table.sorted_keys(data.__changes), '\n'))
data.__changes = {}

_G.storage = {}

log("\nCONTROL")
require('control')

local rec_lim = debuglib.recursion_limit
debuglib.recursion_limit = 5
log(debuglib.sprint(script.__handlers))
debuglib.recursion_limit = rec_lim


log('\nLOCALIZATION')
log(localization.generate_stubs())