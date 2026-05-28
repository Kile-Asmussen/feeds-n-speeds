local fns = require 'fns'
fns.use()

local args = { ... }
local loadstring = loadstring

require 'test'
local __log = _ENV.__log
function _ENV.log() end
function _ENV.__log() end

_ENV.modlist = {"textplates", "even-more-text-plates"}

require('settings')
data.begin_data_stage()
require('data')
require('data-updates')

local debuglib = require 'debuglib'

local fn = loadstring('return ' .. args[1])

__log(debuglib.pp(fn()))