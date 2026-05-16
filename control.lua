local restore = require 'prelude'
fns_control_stage()

-- local tweaks = require 'tweaks'
-- local extras = require 'extras'

-- tweaks.read_toggles()
-- extras.read_toggles()

-- extras.control()
-- tweaks.control()

require('modules')
    .load_stage 'control'

restore()