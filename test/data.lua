require 'prelude'

local localization = require 'test.localization'
local debuglib = require 'debuglib'
local rawdata = require 'test.rawdata'

local data = namespace 'test.data'

_G.modlist = {}
_G.mods = table.null

data.raw = table.null

local proxied = false
local function log_change(new, cutpath, fullpath, value)
    if new then
        __log('changed ' .. cutpath:sub(#'data.raw.'+1))
    end
end

function begin_data_stage(proxy)
    if proxy then
        proxied = true
        data.raw = table.proxy({
            tbl=rawdata.load(_G.modlist),
            rootname='data.raw',
            hook=log_change,
            maxdepth=2,
        })
    else
        data.raw = rawdata.load(_G.modlist)
    end
    _G.settings = import('test.settings'):__seal()
    _G.mods = table.collect(table.set(_G.modlist), function() return 'X.X.X' end)
end

local settings = namespace 'test.settings'

function data.extend(self, protos)
    local simple = {}
    local bad = false
    for _, proto in ipairs(protos) do

        assert(proto.name:match('^feeds%-n%-speeds%-'), "prototype " .. proto.name .. " declared, should be feeds-n-speeds-" .. proto.name)

        __log(proto.type .. ' ' .. proto.name:gsub('feeds%-n%-speeds%-', "fns-"))

        if proto.type:match('%-setting$') then
            settings[proto.setting_type] = settings(proto.setting_type) or {}
            settings[proto.setting_type][proto.name] = proto
            proto.value = proto.default_value

        elseif data.raw ~= table.null then
            local raw = data.raw
            if proxied then raw = data.raw.__real end
            raw[proto.type] = raw[proto.type] or {}
            raw[proto.type][proto.name] = proto
        else
            error("call to data:extend{ { type = '" .. proto.type .. "' } } when data.raw isn't loaded")
            break
        end

        localization.register(proto)

    end
end

_G.data = data:__seal()