require 'prelude'

local loading = require 'loading'

local extras = namespace('extras')

function extras.create_toggles()
    loading.execute(extras, loading.create_toggle, 'create_toggle')
end

function extras.read_toggles()
    loading.execute(extras, loading.read_toggle, 'read_toggle')
end

function extras.settings()
    loading.execute(extras, 'settings')
end

function extras.settings_updates()
    loading.execute(extras, 'settings_updates')
end

function extras.settings_final_fixes()
    loading.execute(extras, 'settings_final_fixes')
end

function extras.data()
    loading.execute(extras, 'data')
end

function extras.data_updates()
    loading.execute(extras, 'data_updates')
end

function extras.data_final_fixes()
    loading.execute(extras, 'data_final_fixes')
end

extras.chests = require('extras.chests')
extras.radars = require('extras.radars')
extras.alt_recipes = require('extras.alt_recipes')

return extras:__seal()