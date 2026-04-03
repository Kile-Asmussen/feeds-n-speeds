require 'prelude'

local loading = require 'loading'

local extras = namespace('extras')

function extras.settings()
    loading.execute_stage(extras, 'settings', loading.create_toggle)
end

function extras.settings_updates()
    loading.execute_stage(extras, 'settings_updates')
end

function extras.settings_final_fixes()
    loading.execute_stage(extras, 'settings_final_fixes')
end

function extras.data()
    loading.execute_stage(extras, 'data', loading.read_toggle)
end

function extras.data_updates()
    loading.execute_stage(extras, 'data_updates', loading.read_toggle)
end

function extras.data_final_fixes()
    loading.execute_stage(extras, 'data_final_fixes', loading.read_toggle)
end

extras.chests = require('extras.chests')
extras.radars = require('extras.radars')

return extras:__seal()