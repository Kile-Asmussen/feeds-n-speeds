require 'prelude'

local args = table.pack(...)
local loadstring = loadstring

require 'test'
local __log = _G.__log
function _G.log() end
function _G.__log() end

_G.modlist = {"textplates", "even-more-text-plates"}

require('settings')
require('settings-updates')
require('settings-final-fixes')
begin_data_stage()
require('data')
require('data-updates')
require('data-final-fixes')

local debuglib = require 'debuglib'

local fn = loadstring('return ' .. args[1])

__log(debuglib.pp(fn()))