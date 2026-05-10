_G.TESTING = true
_G.QUIET = os.getenv("QUIET") and true or false
_G.VERBOSE = os.getenv("VERBOSE") and true or false

require 'prelude'

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
local real_require = require

function require(name)
    if stub_libs[name] then
        return real_require(stub_libs[name])
    else
        return real_require(name)
    end
end

local print = _G.print
_G.__traceback = debug.traceback
function _G.__log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
    print(str)
end

local skip = {
    "stack traceback:",
    "debug/.*%.lua",
    "test%.lua",
    "%[C%]"
}

function _G.log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))

    local traceback = string.lines(debug.traceback())
    local filename = ''
    local lineno = ''
    for l in traceback do
        l = l:gsub('^%s+', '')
        if not table.any(skip, l:match_function()) then
            lineno = l:match(':%d+:')
            filename = l:sub(1, (lineno and l:find(lineno) or #l + 1) - 1)
            break
        end
    end
    local where = filename .. tostring(lineno)
    if #where > 0 then
        print(where .. ' ' .. str)
    else
        print(str)
    end
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
    traceback = debug.traceback
}

local function __lock_mt(name)
    return {
        __index = function(_, key) error(name .. '.' .. key .. ' not found') end,
        __newindex = function(_, key) error('creating ' .. name .. '.' .. key .. ' at this point is probably a bad idea') end,
    }
end

local function __global_index(_, name)
    error('global ' .. name .. ' not found')
end

local function __global_newindex(_, name, val)
    log('_G.' .. name .. ' = ' .. tostring(val))
    rawset(_G, name, val)
end

_G.assoc = table.assoc
_G.array = table.array

setmetatable(_G.table, __lock_mt('table'))
setmetatable(_G.functions, __lock_mt('functions'))
setmetatable(_G.string, __lock_mt('string'))

setmetatable(_G, {
    __index = __global_index,
    __newindex = __global_newindex,
})
