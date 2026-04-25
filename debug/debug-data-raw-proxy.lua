require 'prelude'
require 'test'

local debuglib = require 'debuglib'

data.__begin_proxy()

log(debuglib.sprint(data.raw.recipe['artillery-shell']))

