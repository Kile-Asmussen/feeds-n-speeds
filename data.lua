require 'prelude'
local tweaks = require 'tweaks'
local debuglib = require 'debuglib'
local extras = require 'extras'

debuglib.recursion_limit = 10

extras.data()
tweaks.data()