local fns = require 'fns'

fns.use()


local debuglib = require 'debuglib'

debuglib.recursion_limit = tonumber(os.getenv("DEPTH")) or 2

require 'test'

rawset(_ENV, 'modlist', {"textplates", "even-more-text-plates", "arrowplates"})

_ENV.QUIET = true
data.begin_data_stage()

local args = { ... }

args = table.icollect(args, function(s) return tonumber(s) or s end)

local ix = utils.tablepath('data.raw', args)
local result = table.access(data.raw, args)

if #args < 2 then
    debuglib.recursion_limit = 1
end

local buffer = debuglib.new_buffer{
    depth_limit = debuglib.recursion_limit,
    separator = '\n',
    indent = '  ',
    root = 'data.raw',
}

buffer:print_any(result)

if result ~= nil then
    print(ix .. ' = ' .. tostring(buffer))
else
    print('Path not found: ' .. ix)
end