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

local settings = namespace 'test.settings'

function data.extend(self, protos)
    local simple = {}
    local bad = false
    for _, proto in ipairs(protos) do

        log(proto.name:gsub('feeds%-n%-speeds%-', 'fns \'') .. '\' => ' .. proto.type)

        if proto.type:match('%-setting$') then
            settings[proto.setting_type] = settings(proto.setting_type) or {}
            settings[proto.setting_type][proto.name] = proto
            proto.value = proto.default_value

        elseif data.raw ~= table.null then
            data.raw[proto.type] = data.raw[proto.type] or {}
            data.raw[proto.type][proto.name] = proto
        else
            error("call to data:extend{ { type = '" .. rp .. "' } } when data.raw isn't loaded")
            break
        end

        localization.register(proto)

    end
end

_G.data = data:__seal()