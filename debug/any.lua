require 'prelude'

local args = { ... }
local loadstring = loadstring

require 'test'

_ENV.modlist = {}

begin_data_stage()

local debuglib = require 'debuglib'

local fn, err = loadstring('return ' .. tostring(args[1]))

if err then
    error(err)
end

__log(debuglib.pp(fn()))