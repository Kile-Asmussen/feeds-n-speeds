require 'prelude'
require 'test'

local __log = _ENV.__log
function _ENV.log() end
function _ENV.__log() end

_ENV.modlist = {}

require('settings')
require('settings-updates')
require('settings-final-fixes')
begin_data_stage()
require('data')
require('data-updates')
require('data-final-fixes')

local debuglib = require 'debuglib'

local args = { ... }
table.icollect(args, function(s) return tonumber(s) or s end)

local ix =  string.tablepath('data.raw', args)
local result, found = table.descend(data.raw, table.unpack(args))

-- if args.n < 2 then
    -- debuglib.recursion_limit = 1
-- end

if found then
    __log(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    __log('Path not found: ' .. ix)
    if result ~= nil then
        __log('Stopped at value of type: ' .. type(result))
    end
end
