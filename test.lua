require 'prelude'

require 'test.data'
require 'test.defines'
require 'test.utils'
require 'test.script'
require 'test.localization'

local debuglib = require 'debuglib'
debuglib.recursion_limit = tonumber(os and os.getenv('DEPTH')) or 2

setmetatable(_G, {
    __index = function(_, name) error('global ' .. name .. ' not found') end
})

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

_G.quiet = os.getenv("QUIET") and true or false
_G.verbose = os.getenv("VERBOSE") and true or false
local print = _G.print
function _G.__log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
    print(str)
end

local skip = {
    "stack traceback:",
    "debug/.*%.lua",
    "test%.lua",
    "test/.*%.lua",
    "prelude/.*%.lua",
    "prelude%.lua",
    "%[C%]"
}

function _G.log(str)
    assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))

    local traceback = string.lines(debug.traceback())
    local filename = ''
    local lineno = ''
    for l in traceback do
        l = l:gsub('^%s+', '')
        if not table.any(skip, l:matched_by()) then
            lineno = l:match(':%d+:')
            filename = l:sub(1, (l:find(lineno) or #l + 1) - 1)
            break
        end
    end
    local where = filename .. lineno
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

