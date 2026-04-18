require 'prelude'
require 'test'
local localization = require 'test.localization'
local debuglib = require 'debuglib'

log("SETTINGS")
require('settings')

log("SETTINGS-UPDATES")
require('settings-updates')

log("SETTINGS-FINAL-FIXES")
require('settings-final-fixes')

_G.settings = import('settings'):__seal()

log("DATA")
require('data')

log("DATA-UPDATES")
require('data-updates')

log("DATA-FINAL-FIXES")
require('data-final-fixes')

_G.storage = {}

log("CONTROL")
require('control')

log(debuglib.sprint(fnsidentifiers()))

log('')

log(localization.generate_stubs())