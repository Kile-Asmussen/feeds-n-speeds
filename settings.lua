-- -- local tweaks = require 'tweaks'
-- local extras = require 'extras'

-- extras.create_toggles()
-- tweaks.create_toggles()

-- extras.settings()
-- tweaks.settings()

fns_instance()

require('modules')
    .load_stage 'settings'

fns_restore()