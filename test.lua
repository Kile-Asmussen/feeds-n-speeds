_G.TESTING = true
_G.QUIET = os.getenv("QUIET") and true or false
_G.VERBOSE = os.getenv("VERBOSE") and true or false

require 'prelude'

_G.TESTING = true

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
function _G.require(name)
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

local __print = _G.print
local __exit = _G.os.exit

function _G.__log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
    __print(str)
end

function _G.die(message, n)
    n = n or 2
    __print(message)
    __print(debug.traceback(nil, n))
    __exit(1)
end

function debug.getline(n, msg)
    return debug.traceback(nil, n + 1):replace_prefix("stack traceback:\n\t"):before(': ', msg and true) .. (msg or '')
end

function _G.log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))

    __print(debug.getline(2, str))
end

local function __global_index(_, name)
    die('_G.' .. name .. ' undefined', 3)
end

local function __global_newindex(_, name, val)
    die('_G.' .. name .. ' = ' .. tostring(val), 3)
end


_G.io = nil
_G.os = nil
_G.coroutine = nil
_G.loadfile = nil
_G.dofile = nil
_G.package = nil
_G.math.randomseed = nil
_G.print = nil

_G.debug = {
    getinfo = debug.getinfo,
    traceback = debug.traceback,
    getline = debug.getline,
}

local function __lock_mt(name)
    return {
        __index = function(_, key)
            die(name .. '.' .. key .. ' not found')
        end,
        __newindex = function(_, key)
            die(name .. '.' .. key .. ' cannot be defined at this point')
        end,
    }
end

setmetatable(_G.table, __lock_mt('table'))
setmetatable(_G.functions, __lock_mt('functions'))
setmetatable(_G.string, __lock_mt('string'))
setmetatable(_G.debug, __lock_mt('debug'))

setmetatable(_G, {
    __index = __global_index,
    __newindex = __global_newindex,
})
