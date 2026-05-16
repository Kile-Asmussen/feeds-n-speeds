require 'prelude'

local print = _ENV.print

require 'test'

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local tools = require 'tools'

local log = _ENV.__log
if not _ENV.VERBOSE then
    _ENV.__log = function() end
end
if _ENV.QUIET then
    _ENV.log = function() end
end

_ENV.modlist = {}

print("\nSETTINGS")
require('settings')

print("\nSETTINGS-UPDATES")
require('settings-updates')

print("\nSETTINGS-FINAL-FIXES")
require('settings-final-fixes')

fns_instance()
begin_data_stage(_ENV.VERBOSE)

print("\nDATA")
require('data')

print("\nDATA-UPDATES")
require('data-updates')

print("\nDATA-FINAL-FIXES")
require('data-final-fixes')

fns_instance()
tools.recursion_check(data.raw)

begin_control_stage()

print("\nCONTROL")
require('control')

fns_instance()
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