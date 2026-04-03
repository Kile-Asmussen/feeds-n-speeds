require 'prelude'
local debuglib = require 'debuglib'
local tweaks = require 'tweaks'
local extras =  require 'extras'

extras.read_toggles()
tweaks.read_toggles()

extras.data_final_fixes()
tweaks.data_final_fixes()