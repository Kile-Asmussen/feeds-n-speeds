require 'prelude'
require 'test'

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'

local log = _G.__log
if not _G.VERBOSE then
    _G.__log = function() end
end
if _G.QUIET then
    _G.log = function() end
end

_G.modlist = {"textplates", "even-more-text-plates"}

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

localisation.finalize()

log('\nNEEDED LOCALISATION')
log(localisation.list_missing_locale_keys())

log('\nSUPERFLUOUS LOCALISATION')
log(localisation.list_superfluous_locale_keys())
