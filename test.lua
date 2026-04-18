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

local print = _G.print
function log(str) print(str) end

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

