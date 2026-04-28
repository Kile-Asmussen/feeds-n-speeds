require 'prelude'
require 'test'

local debuglib = require 'debuglib'

_G.modlist = {"textplates", "even-more-text-plates"}
begin_data_stage()

local args = table.pack( ... )

local ix = string.tablepath('data.raw', args)
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