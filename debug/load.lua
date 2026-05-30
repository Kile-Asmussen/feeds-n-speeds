local fns = require 'fns'

local print = _ENV.print

require 'test'

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local gadgets = fns.gadgets

if not _ENV.VERBOSE then
    _ENV.__log = function() end
end
if _ENV.QUIET then
    _ENV.log = function() end
end

_ENV.modlist = {}
local ok, err 

print("\nSETTINGS")
require 'settings'

fns.use()
data.begin_data_stage(_ENV.PROXIED)
fns.restore()

print("\nDATA")
require 'data'

print("\nDATA-UPDATES")
require 'data-updates'

fns.use()
gadgets.master_check()
fns.restore()

data.begin_control_stage()

print("\nCONTROL")
require 'control'

fns.use()
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