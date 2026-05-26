local fns = require 'fns'

fns.use()

require('modules')
    .load_stage 'control'

fns.restore()