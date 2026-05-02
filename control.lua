require 'prelude'
local tweaks = require 'tweaks'
local extras = require 'extras'

tweaks.read_toggles()
extras.read_toggles()

extras.control()
tweaks.control()