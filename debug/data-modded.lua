require 'prelude'
require 'test'

local __log = _G.__log
function _G.log() end
function _G.__log() end

_G.modlist = {"textplates", "even-more-text-plates"}

require('settings')
require('settings-updates')
require('settings-final-fixes')
begin_data_stage()
require('data')
require('data-updates')
require('data-final-fixes')

local debuglib = require 'debuglib'

local args = table.pack(...)
table.imap(args, function(s) return tonumber(s) or s end)

local ix =  string.tablepath('data.raw', args)
local result, found = table.descend(data.raw, table.unpack(args))

if args.n < 2 then
    debuglib.recursion_limit = 1
end

if found then
    __log(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    __log('Path not found: ' .. ix)
    if result ~= nil then
        __log('Stopped at value of type: ' .. type(result))
    end
end
