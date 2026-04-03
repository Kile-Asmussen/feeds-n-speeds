require 'prelude'
local tweaks = require 'tweaks'
local extras =  require 'extras'

extras.read_toggles()
tweaks.read_toggles()

extras.settings_updates()
tweaks.settings_updates()