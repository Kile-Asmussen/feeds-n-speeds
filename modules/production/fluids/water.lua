require 'prelude'

local tools = require 'tools'

local fluids = data.raw.fluid
local water = fluids.water
local steam = fluids.steam

water.default_temperature = 15
water.max_temperature = 100

steam.default_temperature = 0
steam.gas_temperature = 100
steam.max_temperature = 1500