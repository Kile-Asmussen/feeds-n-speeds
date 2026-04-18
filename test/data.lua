require 'prelude'

local localization = require 'test.localization'

local data = namespace 'data'
data.raw = require 'raw'

local settings = namespace('settings')

function data.extend(self, protos)
    local simple = {}
    for _, proto in ipairs(protos) do
        
        table.insert(simple, '  { name = "' .. proto.name .. '", type = "' .. proto.type .. '" }')

        if proto.type:match('%-setting$') then
            settings[proto.setting_type] = settings(proto.setting_type) or {}
            settings[proto.setting_type][proto.name] = { value = proto.default_value }

        elseif data.raw[proto.type] then

            data.raw[proto.type][proto.name] = proto
            localization.register(proto)
        else
            error("unknown prototype " .. proto.type)
        end

    end
    log('data:extend{\n' .. table.concat(simple, '\n') .. '\n}')
end

_G.data = data:__seal()