require 'prelude'
fns_instance()

_ENV.TESTING = true
_ENV.QUIET = os.getenv("QUIET") and true or false
_ENV.VERBOSE = os.getenv("VERBOSE") and true or false

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
function _ENV.require(name)
    name = stub_libs[name] or name
    local ok, val = pcall(__require, name)
    if not ok then
        if val:startswith('module') and val:find('not found', 1, true) then
            error(val:before(':\n'), 2)
        elseif val:startswith('error loading module') then
            error(val:after(':\n\t'), 2)
        end
    else
        return val
    end
end

local __print = _ENV.print
local __exit = _ENV.os.exit

function _ENV.__log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
    __print(str)
end

function _ENV.die(message, n)
    n = n or 2
    __print(message)
    __print(debug.traceback(nil, n))
    __exit(1)
end

function debug.getline(n, msg)
    return debug.traceback(nil, n + 1):replace_prefix("stack traceback:\n\t"):before(': ', msg and true) .. (msg or '')
end

function _ENV.log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))

    __print(debug.getline(2, str))
end

local function __global_index(_, name)
    die('_ENV.' .. name .. ' undefined', 3)
end

local function __global_newindex(_, name, val)
    die('_ENV.' .. name .. ' = ' .. tostring(val), 3)
end


_ENV.io = nil
_ENV.os = nil
_ENV.coroutine = nil
_ENV.loadfile = nil
_ENV.dofile = nil
_ENV.package = nil
_ENV.math.randomseed = nil
_ENV.print = nil

_ENV.debug = {
    getinfo = debug.getinfo,
    traceback = debug.traceback,
    getline = debug.getline,
    debug = debug.debug,
}

local function __lock_mt(name, index, newindex)
    index = index or function() end
    newindex = newindex or index
    return {
        __index = function(_, key)
            die(string.tablepath(name, { key }) .. ' not found' .. (index(key) or ''))
        end,
        __newindex = function(_, key)
            die(string.tablepath(name, { key })  .. ' cannot be set' .. (newindex(key) or ''))
        end,
    }
end

setmetatable(_ENV.table, __lock_mt('table'))
setmetatable(_ENV.functions, __lock_mt('functions'))
setmetatable(_ENV.string, __lock_mt('string', function(k)
    if type(k) == 'number' then return ', use string:sub to index strings' end
end, function(k)
    if type(k) == 'number' then return ', strings are immutable' end 
end))
setmetatable(_ENV.debug, __lock_mt('debug'))

setmetatable(_ENV, {
    __index = __ENVlobal_index,
    __newindex = __ENVlobal_newindex,
})
