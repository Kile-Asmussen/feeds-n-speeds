require 'prelude'

local loading = require 'loading'

local tweaks = namespace 'tweaks'

function tweaks.settings()
    loading.execute_stage(tweaks, 'settings', loading.create_toggle)
end

function tweaks.settings_updates()
    loading.execute_stage(tweaks, 'settings_updates')
end

function tweaks.settings_final_fixes()
    loading.execute_stage(tweaks, 'settings_final_fixes')
end

function tweaks.data()
    loading.execute_stage(tweaks, 'data', loading.read_toggle)
end

function tweaks.data_updates()
    loading.execute_stage(tweaks, 'data_updates', loading.read_toggle)
end

function tweaks.data_final_fixes()
    loading.execute_stage(tweaks, 'data_final_fixes', loading.read_toggle)
end

function tweaks.control()
    loading.execute_stage(tweaks, 'control', loading.read_toggle)
end

tweaks.chest = require 'tweaks.chests'
tweaks.concrete = require 'tweaks.concrete'
tweaks.electric = require 'tweaks.electric'
tweaks.inserter = require 'tweaks.inserter'
tweaks.nuclear = require 'tweaks.nuclear'
tweaks.ores = require 'tweaks.ores'

return tweaks:__seal()