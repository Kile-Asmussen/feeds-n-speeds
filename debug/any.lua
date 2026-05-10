require 'prelude'

local args = table.pack(...)
local loadstring = loadstring

require 'test'

begin_data_stage()


local debuglib = require 'debuglib'

local fn = loadstring('return ' .. tostring(args[1]))

__log(debuglib.pp(fn()))