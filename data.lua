local fns = require 'fns'

fns.use()

require('modules')
    .load_stage 'data'

fns.restore()