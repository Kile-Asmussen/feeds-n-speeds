require 'prelude'
require 'test-config'

local debuglib = require 'debuglib'

local args = table.pack( ... )

local ix = 'data' .. debuglib.descent('raw', table.unpack(args))

log(ix .. ' = ' .. debuglib.sprint(table.descend(data.raw, table.unpack(args))))