require 'prelude'
require 'test'

local debuglib = require 'debuglib'

begin_data_stage 'proxy'

log(debuglib.pp(data.raw.recipe['artillery-shell'], "['artillery-shell']"))

