require 'prelude'
require 'test'

local debuglib = require 'debuglib'

local args = table.pack( ... )

local ix = 'data' .. debuglib.descent('raw', table.unpack(args))
local result, found = table.descend(data.raw, table.unpack(args))

if found then
    log(ix .. ' = ' .. debuglib.sprint(result))
else
    log('Path not found: ' .. ix)
    if result ~= nil then
        log('Stopped at value of type: ' .. type(result))
    end
end