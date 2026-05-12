require 'prelude'

local print = _ENV.print

require 'test'

local debuglib = require 'debuglib'

_ENV.modlist = {"textplates", "even-more-text-plates"}
begin_data_stage()

local args = table.pack( ... )
args = table.icollect(args, function(s) return tonumber(s) or s end)

local ix = string.tablepath('data.raw', args)
local result, found = table.descend(data.raw, table.unpack(args))

if (args.n or 0) < 2 then
    debuglib.recursion_limit = 1
end

if found then
    print(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    print('Path not found: ' .. ix)
    if result ~= nil then
        print('Stopped at value of type: ' .. type(result))
    end
end