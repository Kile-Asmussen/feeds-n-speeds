require 'prelude'
require 'test'

local log = __log
function log() end
function __log() end

require('settings')
require('settings-updates')
require('settings-final-fixes')
begin_data_stage()
require('data')
require('data-updates')
require('data-final-fixes')

-- Restore print for output
log = real_log

local debuglib = require 'debuglib'

local args = table.pack(...)

local ix =  string.tablepath('data.raw', args)
local result, found = table.descend(data.raw, table.unpack(args))

if args.n < 2 then
    debuglib.recursion_limit = 1
end

if found then
    log(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    log('Path not found: ' .. ix)
    if result ~= nil then
        log('Stopped at value of type: ' .. type(result))
    end
end
