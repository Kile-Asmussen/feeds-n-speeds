
_ENV.TESTING = true
_ENV.QUIET = os.getenv("QUIET") and true or false
_ENV.VERBOSE = os.getenv("VERBOSE") and true or false

setmetatable(_ENV, {
    __index = function(_, name) error('_ENV.' .. name .. ' undefined', 2) end,
    __newindex = function(_, name, val) error('_ENV.' .. name .. ' = ' .. tostring(val), 2) end,
})

local fns = require 'fns'

fns.use()

local table = fns.table
local string = fns.string

require 'test.data'
require 'test.defines'
require 'test.utils'
require 'test.script'
require 'test.localisation'

local debuglib = require 'debuglib'
debuglib.recursion_limit = tonumber(os and os.getenv('DEPTH')) or 2

local stub_libs = {
    ['resource-autoplace'] = 'test.resource-autoplace'
}
local __require = require
local function require(name)
    name = stub_libs[name] or name
    local ok, val = pcall(__require, name)
    if not ok then
        if string.startswith(val, 'module') and val:find('not found', 1, true) then
            error(string.before(val, ':\n'), 2)
        elseif val:startswith('error loading module') then
            error(string.after(val, ':\n\t'), 2)
        end
    else
        return val
    end
end
rawset(_ENV, 'require', require)

local __exit = _ENV.os.exit

function debug.getline(n, msg)
    local traceback = debug.traceback(nil, n + 1)
    taceback = string.replace_prefix("stack traceback:\n\t")
    traceback = string.before(traceback, ': ', msg and true)
    return traceback .. (msg or '')
end

local function log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
    print(debug.getline(2, str))
end

rawset(_ENV, 'log', log)
rawset(_ENV, '__log', log)

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

local function __lock_mt(name, index, newindex)
    index = index or function() end
    newindex = newindex or index
    return {
        __index = function(_, key)
            die(fns.utils.tablepath(name, { key }) .. ' not found' .. (index(key) or ''))
        end,
        __newindex = function(_, key)
            die(fns.utils.tablepath(name, { key })  .. ' cannot be set' .. (newindex(key) or ''))
        end,
    }
end

setmetatable(_ENV.debug, __lock_mt('debug'))
