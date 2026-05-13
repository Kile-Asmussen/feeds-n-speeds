require 'prelude'

local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local rawdata = require 'test.rawdata'

local data = namespace 'test.data'

_ENV.modlist = table.null
_ENV.mods = table.null

data.raw = table.null
_ENV.settings = {}
setmetatable(_ENV.settings, {
    __index = function() die("_ENV.settings is not available at this time") end,
    __newindex = function() die("_ENV.settings is not available at this time") end,
})

local proxied = false
local function log_change(new, cutpath, fullpath, value)
    if new then __log(cutpath:replace_prefix('data.raw'):replace_prefix('.') .. ' = ...') end
end

function begin_data_stage(proxy)
    if proxy then
        proxied = true
        data.raw = table.proxy{
            tbl=rawdata.load(_ENV.modlist),
            rootname='data.raw',
            hook=log_change,
            maxdepth=2,
        }
    else
        data.raw = rawdata.load(_ENV.modlist)
    end
    rawset(_ENV, 'settings', import('test.settings'):seal())
    rawset(_ENV, 'mods', table.collect(table.set(_ENV.modlist), function() return 'X.X.X' end))
end

function begin_control_stage()
    rawset(_ENV, 'storage', {})
end

local settings = namespace 'test.settings'

function data.extend(self, protos)
    assert(table.is_array(protos), "data:extend called with non-array")

    for i, proto in ipairs(protos) do

        assert(table.is_assoc(proto), "data:extend argument entry #" .. i .. " is not an associative array")

        assert(is_fns_name(proto.name), "not an fns-based name: " .. proto.name)

        __log("prototype{ type = '" .. proto.type .. "', name = fns '" .. proto.name:replace_prefix('feeds-n-speeds-') .. "' }")

        if proto.type:endswith('-setting') then
            settings[proto.setting_type] = settings/proto.setting_type or {}

            assert(not settings[proto.setting_type][proto.name], proto.name .. " already declared!")

            settings[proto.setting_type][proto.name] = proto
            proto.value = proto.default_value

        elseif data.raw ~= table.null then
            local raw = data.raw
            if proxied then raw = data.raw.__real end

            
            raw[proto.type] = raw[proto.type] or {}
            assert(not raw[proto.type][proto.name], proto.name .. " already declared!")
            
            raw[proto.type][proto.name] = proto
        else
            error("call to data:extend{ { type = '" .. proto.type .. "' } } when data.raw isn't loaded")
            break
        end

        localisation.register(proto)
    end
end


_ENV.data = seal_namespace(data)  