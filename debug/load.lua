require 'prelude'
require 'test'

local localization = require 'test.localization'
local debuglib = require 'debuglib'

local log = _G.log
if not _G.verbose then
    _G.__log = function() end
end
if _G.quiet then
    _G.log = function() end
end

log("SETTINGS")
require('settings')

log("SETTINGS-UPDATES")
require('settings-updates')

log("SETTINGS-FINAL-FIXES")
require('settings-final-fixes')

begin_data_stage()

log("DATA")
require('data')

log("DATA-UPDATES")
require('data-updates')

log("DATA-FINAL-FIXES")
require('data-final-fixes')

log("CONTROL")
_G.storage = {}
require('control')

log('\nLOCALIZATION')
log(localization.generate_stubs())