local fns = require 'fns'

require('modules')
    .load_stage 'control'

script.on_init(fns.gadgets.on_init_hook)
