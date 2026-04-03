require 'prelude'
local tweaks = require 'tweaks'
local extras = require 'extras'

extras.create_toggles()
tweaks.create_toggles()

extras.read_toggles()
tweaks.read_toggles()

extras.settings()
tweaks.settings()
