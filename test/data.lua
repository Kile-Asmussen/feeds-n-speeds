require 'prelude'

local localization = require 'test.localization'

local data = namespace 'test.data'
data.raw = table.null

function data.__count(tbl)

    if tbl == nil then
        tbl = data.raw
    end

    if type(tbl) ~= 'table' then
        return 1
    end

    local res = 0
    for _, v in pairs(tbl) do
        res = res + data.__count(v)
    end

    return res
end

local settings = namespace('test.settings')

function data.extend(self, protos)
    local simple = {}
    local bad = false
    for _, proto in ipairs(protos) do
        
        table.insert(simple, '  { name = "' .. proto.name .. '", type = "' .. proto.type .. '" }')

        if proto.type:match('%-setting$') then
            settings[proto.setting_type] = settings(proto.setting_type) or {}
            settings[proto.setting_type][proto.name] = proto
            proto.value = proto.default_value

        elseif data.raw ~= table.null then
            data.raw[proto.type] = data.raw[proto.type] or {}
            data.raw[proto.type][proto.name] = proto
        else
            bad = true
        end

        localization.register(proto)

    end
    local string = 'data:extend{\n' .. table.concat(simple, '\n') .. '\n}'
        if bad then
        error('BAD CALL TO ' .. string)
    else
        log(string)
    end
end

_G.data = data:__seal()