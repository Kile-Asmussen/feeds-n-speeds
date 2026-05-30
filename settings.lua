
local fns = require 'fns'

fns.use()

require('modules')
    .load_stage 'settings'

fns.restore()