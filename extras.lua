require 'prelude'

local loading = require 'loading'

local extras = namespace 'extras'

function extras.create_toggles()
    loading.execute(extras, loading.create_toggle, 'create_toggle')
end

function extras.read_toggles()
    loading.execute(extras, loading.read_toggle, 'read_toggle')
end

function extras.settings()
    loading.execute(extras, loading.call('settings'))
end

function extras.settings_updates()
    loading.execute(extras, loading.call('settings_updates'))
end

function extras.settings_final_fixes()
    loading.execute(extras, loading.call('settings_final_fixes'))
end

function extras.control()
    loading.execute(extras, loading.if_enabled('control'))
end

function extras.data()
    loading.execute(extras, loading.if_enabled('data'))
end

function extras.data2()
    loading.execute(extras, loading.if_enabled('data2'))
end

function extras.data_updates()
    loading.execute(extras, loading.if_enabled('data_updates'))
end

function extras.data_final_fixes()
    loading.execute(extras, loading.if_enabled('data_final_fixes'))
end

extras.chests = require('extras.chests')
extras.radars = require('extras.radars')
extras.altrecipes = require('extras.altrecipes')
extras.drills = require('extras.drills')
extras.ores = require('extras.ores')
extras.energy = require('extras.energy')
extras.utilities = require('extras.utilities')
extras.roboports = require('extras.roboports')
extras.heavy = require('extras.heavy')
extras.barelling = require('extras.barelling')

return seal_namespace(extras)