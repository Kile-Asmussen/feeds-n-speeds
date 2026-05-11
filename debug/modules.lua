require 'prelude'
require 'test'

local localisation = require 'test.localisation'
local modules = require 'modules'
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
modules.load_stage 'settings'

begin_data_stage()

log("\nDATA")
modules.load_stage 'data'

log("\nDATA-UPDATES")
modules.load_stage 'data-updates'

table.recursion_check(data.raw)

log("\nCONTROL")
modules.load_stage 'control'

localisation.finalize()

log('\nNEEDED LOCALISATION')
log(localisation.list_missing_locale_keys())

log('\nSUPERFLUOUS LOCALISATION')
log(localisation.list_superfluous_locale_keys())