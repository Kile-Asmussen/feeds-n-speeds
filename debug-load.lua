require 'prelude'
require 'test-config'
local debuglib = require 'debuglib'

log("SETTINGS")
require('settings')

log("SETTINGS-UPDATES")
require('settings-updates')

log("SETTINGS-FINAL-FIXES")
require('settings-final-fixes')

log("DATA")
require('data')

log("DATA-UPDATES")
require('data-updates')

log("DATA-FINAL-FIXES")
require('data-final-fixes')

log(debuglib.sprint(fns_identifiers()))

log('')

log(generate_localization_stub())