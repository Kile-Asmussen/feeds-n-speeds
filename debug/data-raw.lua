require 'prelude'
require 'test'

local debuglib = require 'debuglib'

data.raw = require('rawdata')

local args = table.pack( ... )

local ix = 'data' .. debuglib.descent('raw', table.unpack(args))
local result, found = table.descend(data.raw, table.unpack(args))

if args.n < 2 then
    debuglib.recursion_limit = 1
end

if found then
    log(ix .. ' = ' .. debuglib.sprint(result))
else
    log('Path not found: ' .. ix)
    if result ~= nil then
        log('Stopped at value of type: ' .. type(result))
    end
end