local fns = require 'fns'

fns.use()

local debuglib = require 'debuglib'

debuglib.recursion_limit = tonumber(os.getenv("DEPTH")) or 2

require 'test'

rawset(_ENV, 'modlist', {"textplates", "even-more-text-plates"})

data.begin_data_stage()

local args = { ... }

args = table.icollect(args, function(s) return tonumber(s) or s end)

local ix = string.tablepath('data.raw', args)
local result, found = table.descend(data.raw, args)

if #args < 2 then
    debuglib.recursion_limit = 1
end

if found then
    print(ix .. ' = ' .. debuglib.pp(result, 'data.raw'))
else
    print('Path not found: ' .. ix)
end