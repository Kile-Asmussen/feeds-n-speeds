require 'prelude'

data = namespace('data')
data.raw = require 'raw'

setmetatable(_G, {
    __index = function(_, name) error('global ' .. name .. ' not found') end
})

local debuglib = require 'debuglib'

function log(str) print(str) end

settings = namespace('settings')
settings.startup = {}


function data.extend(self, protos)
    local simple = {}
    for _, proto in ipairs(protos) do
        
        table.insert(simple, '  { name = "' .. proto.name .. '", type = "' .. proto.type .. '" }')

        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type][proto.name] = { value = proto.default_value }
        end
    end
    log('data:extend{\n' .. table.concat(simple, '\n') .. '\n}')
end

settings:__seal()
data:__seal()