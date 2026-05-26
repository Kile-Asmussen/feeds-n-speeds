-- -- local tweaks = require 'tweaks'
-- local extras = require 'extras'

-- extras.create_toggles()
-- tweaks.create_toggles()

-- extras.settings()
-- tweaks.settings()

local fns = require 'fns'

fns.use()

require('modules')
    .load_stage 'settings'

fns.restore()