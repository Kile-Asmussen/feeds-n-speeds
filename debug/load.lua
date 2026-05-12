require 'prelude'

local print = _G.print

require 'test'

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local tools = require 'tools'

local log = _G.__log
if not _G.VERBOSE then
    _G.__log = function() end
end
if _G.QUIET then
    _G.log = function() end
end

_G.modlist = {"textplates", "even-more-text-plates"}

print("\nSETTINGS")
require('settings')

print("\nSETTINGS-UPDATES")
require('settings-updates')

print("\nSETTINGS-FINAL-FIXES")
require('settings-final-fixes')

begin_data_stage()

print("\nDATA")
require('data')

print("\nDATA-UPDATES")
require('data-updates')

print("\nDATA-FINAL-FIXES")
require('data-final-fixes')

tools.recursion_check(data.raw)

begin_control_stage()

print("\nCONTROL")
require('control')

localisation.finalize()

local keys

print('\nNEEDED LOCALISATION')
keys = localisation.list_missing_locale_keys()
if #keys > 0 then
    print(keys)
end

print('\nSUPERFLUOUS LOCALISATION')
keys = localisation.list_superfluous_locale_keys()
if #keys > 0 then
    print(keys)
end

print()