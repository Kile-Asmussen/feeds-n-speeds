local instance, restore = require 'prelude'

fns_instance()

require('modules')
    .load_stage 'data'

fns_restore()