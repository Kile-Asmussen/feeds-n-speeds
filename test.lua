
_ENV.TESTING = true
_ENV.QUIET = os.getenv("QUIET") and true or false
_ENV.VERBOSE = os.getenv("VERBOSE") and true or false
_ENV.PROXIED = os.getenv("PROXIED") and true or false

_ENV.table_size = require('test.rawdata').table_size


setmetatable(_ENV, {
    __index = function(_, name) error('_ENV.' .. name .. ' undefined', 2) end,
    __newindex = function(_, name, val) error('_ENV.' .. name .. ' = ' .. tostring(val), 2) end,
})

require 'test.data'
require 'test.defines'
require 'test.utils'
require 'test.script'
require 'test.localisation'


local fns = require 'fns'
local table = fns.table
_ENV.table.deepcopy = fns.table.deepcopy

local debuglib = require 'debuglib'
rawset(_ENV, 'serpent', { line = debuglib.p, block = debuglib.pp })
debuglib.recursion_limit = tonumber(os and os.getenv('DEPTH')) or 4

local __exit = _ENV.os.exit

function debug.getline(n, msg)
    local traceback = debug.traceback(nil, n + 1)
    traceback = traceback:replace_prefix("stack traceback:\n\t")
    traceback = traceback:before(': ', msg and true)
    return traceback .. (msg or '')
end

local function test_log(str)
    assert(type(str) == 'string', "argument #1 must be a string, not " .. type(str))
    print(debug.getline(3, str))
end

rawset(_ENV, 'log', function(str)
    if not _ENV.QUIET then test_log(str) end
end)
rawset(_ENV, '__log', function(str)
    if _ENV.VERBOSE then print(str) end
end)

rawset(_ENV, 'io', nil)
rawset(_ENV, 'os', nil)
rawset(_ENV, 'coroutine', nil)
rawset(_ENV, 'loadfile', nil)
rawset(_ENV, 'dofile', nil)
rawset(_ENV, 'package', nil)

rawset(_ENV, 'debug', {
    getinfo = debug.getinfo,
    traceback = debug.traceback,
    getline = debug.getline,
    debug = debug.debug,
})
