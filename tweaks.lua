require 'prelude'

local loading = require 'loading'

local tweaks = namespace 'tweaks'

function tweaks.create_toggles()
    loading.execute(tweaks, loading.create_toggle, 'create_toggle')
end

function tweaks.read_toggles()
    loading.execute(tweaks, loading.read_toggle, 'read_toggle')
end

function tweaks.settings()
    loading.execute(tweaks, 'settings')
end

function tweaks.settings_updates()
    loading.execute(tweaks, 'settings_updates')
end

function tweaks.settings_final_fixes()
    loading.execute(tweaks, 'settings_final_fixes')
end

function tweaks.control()
    loading.execute(tweaks, 'control')
end

function tweaks.data()
    loading.execute(tweaks, 'data')
end

function tweaks.data_updates()
    loading.execute(tweaks, 'data_updates')
end

function tweaks.data_final_fixes()
    loading.execute(tweaks, 'data_final_fixes')
end

tweaks.chests = require 'tweaks.chests'
tweaks.concrete = require 'tweaks.concrete'
tweaks.electric = require 'tweaks.electric'
tweaks.earlygame = require 'tweaks.earlygame'
tweaks.inserter = require 'tweaks.inserter'
tweaks.nuclear = require 'tweaks.nuclear'
tweaks.ores = require 'tweaks.ores'
tweaks.malltech = require 'tweaks.malltech'
tweaks.timewaster = require 'tweaks.timewaster'
tweaks.sulfur_processing = require 'tweaks.sulfur-processing'

return tweaks:__seal()