local fns = require 'fns'

fns.use()

require 'test'

_ENV.QUIET = true

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
local result = table.access(data.raw, args)

if #args < 2 then
    debuglib.recursion_limit = 1
end

if result ~= nil then
    print(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    print('Path not found: ' .. ix)
end
