require 'prelude'

local localization = require 'test.localization'
local debuglib = require 'debuglib'

local data = namespace 'test.data'

data.__changes = {}



function data.__proxy(tbl, root, path)
    path = path or {}
    if type(tbl) ~= 'table' then
        return tbl
    else
        log("proxying " .. root .. debuglib.descent(table.unpack(path)))
        tbl = { __real = tbl, __root = root, __path = path }
        setmetatable(tbl, data.__proxy_mt)
        return tbl
    end
end

data.raw = table.null

function data.__begin_proxy()
    data.raw = data.__proxy(require 'test.rawdata', 'data.raw')
end

function data.__begin()
    data.raw = require 'test.rawdata'
end

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