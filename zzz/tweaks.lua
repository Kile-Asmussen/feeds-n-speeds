
local loading = require 'loading'

local tweaks = namespace 'tweaks'

function tweaks.create_toggles()
    loading.execute(tweaks, loading.create_toggle)
end

function tweaks.read_toggles()
    loading.execute(tweaks, loading.read_toggle)
end

function tweaks.settings()
    loading.execute(tweaks, loading.call('settings'))
end

function tweaks.settings_updates()
    loading.execute(tweaks, loading.call('settings_updates'))
end

function tweaks.settings_final_fixes()
    loading.execute(tweaks, loading.call('settings_final_fixes'))
end

function tweaks.control()
    loading.execute(tweaks, loading.if_enabled('control'))
end

function tweaks.data()
    loading.execute(tweaks, loading.if_enabled('data'))
end

function tweaks.data2()
    loading.execute(tweaks, loading.if_enabled('data2'))
end

function tweaks.data_updates()
    loading.execute(tweaks, loading.if_enabled('data_updates'))
end

function tweaks.data_final_fixes()
    loading.execute(tweaks, loading.if_enabled('data_final_fixes'))
end

tweaks.chests = require 'tweaks.chests'
tweaks.concrete = require 'tweaks.concrete'
tweaks.electric = require 'tweaks.electric'
tweaks.earlygame = require 'tweaks.earlygame'
tweaks.nuclear = require 'tweaks.nuclear'
tweaks.ores = require 'tweaks.ores'
tweaks.malltech = require 'tweaks.malltech'
tweaks.timewaster = require 'tweaks.timewaster'
tweaks.sulfur_processing = require 'tweaks.sulfur-processing'
tweaks.technologies = require 'tweaks.technologies'
tweaks.machines = require 'tweaks.machines'
tweaks.textplates = require 'tweaks.textplates'
tweaks.batteries = require 'tweaks.batteries'
tweaks.robotics = require 'tweaks.robotics'
tweaks.military = require 'tweaks.military'
tweaks.start = require 'tweaks.start'
tweaks.cliffsplosives = require 'tweaks.cliffsplosives'
tweaks.water = require 'tweaks.water'

return seal_namespace(tweaks)