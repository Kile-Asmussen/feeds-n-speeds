local fns = require 'fns'
fns.use()

local args = { ... }
local loadstring = loadstring

require 'test'
function _ENV.log() end
function _ENV.__log() end

_ENV.modlist = {"textplates", "even-more-text-plates", "arrowplates"}

require('settings')
begin_data_stage()
require('data')
require('data-updates')

local debuglib = require 'debuglib'

local fn, err = loadstring('return ' .. args[1])

if err then
    error(err)
end

print(debuglib.pp(fn()))