require 'test'
local fns = require 'fns'

local print = _ENV.print

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local gadgets = fns.gadgets

if not _ENV.VERBOSE then
    _ENV.__log = function() end
end
if _ENV.QUIET then
    _ENV.log = function() end
end

rawset(_ENV, 'modlist', {})

begin_settings_stage()


print("\nSETTINGS")
require 'settings'

begin_data_stage(_ENV.PROXIED)

print("\nDATA")
require 'data'

print("\nDATA-UPDATES")
require 'data-updates'

require('test.tools').master_check()

begin_control_stage()

print("\nCONTROL")
require 'control'

localisation.finalize()

local keys

keys = localisation.list_missing_locale_keys()
if #keys > 0 then
    print('\nLOCALISATION NEEDED')
    print(keys)
end

keys = localisation.list_superfluous_locale_keys()
if #keys > 0 then
    print('\nLOCALISATION COVERED BY DEFAULTS')
    print(keys)
end

keys = localisation.list_dead_locale_keys()
if #keys > 0 then
    print('\nLOCALISATION NO LONGER USED')
    print(keys)
end

print()