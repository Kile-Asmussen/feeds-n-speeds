require 'prelude'

local debuglib = require 'debuglib'
local loading = require 'loading'

local extras = namespace('extras')

function extras.settings()
    loading.execute_stage(extras, 'settings', loading.create_toggle)
end

function extras.data()
    log(debuglib.sprint(data.raw.explosion['steel-chest-explosion']))
    loading.execute_stage(extras, 'data', loading.read_toggle)
end

extras.chests = require('extras.chests')

return extras:__seal()