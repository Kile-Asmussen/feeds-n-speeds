local fns = require 'fns'

fns.use()

require 'test'

local __log = _ENV.__log
function _ENV.log() end
function _ENV.__log() end

_ENV.modlist = {}

require('settings')
fns.use()
data.begin_data_stage()
require('data')
require('data-updates')

fns.use()

local debuglib = require 'debuglib'

local args = { ... }
table.icollect(args, function(s) return tonumber(s) or s end)

local ix =  utils.tablepath('data.raw', args)
local result, found = table.descend(data.raw, args)

if #args < 2 then
    debuglib.recursion_limit = 1
end

if found then
    __log(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    __log('Path not found: ' .. ix)
end
