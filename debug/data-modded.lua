local fns = require 'fns'

fns.use()

require 'test'

_ENV.QUIET = true

_ENV.modlist = {}

require('settings')
fns.use()
data.begin_data_stage()
require('data')
require('data-updates')

fns.use()

local debuglib = require 'debuglib'

fns.gadgets.descend_into_data_raw({ ... }, debuglib.recursion_limit)
