local fns = require 'fns'

fns.use()

require('modules')
    .load_stage 'control'

script.on_init(fns.gadgets.on_init_hook)

fns.restore()
