local fns = require 'fns'
local localisation = require 'test.localisation'
local debuglib = require 'debuglib'
local rawdata = require 'test.rawdata'

local namespace = require 'namespace'
local utils = fns.utils
local table = fns.table

local proxy = require 'test.proxy'

local data = namespace('test.data')

rawset(_ENV, 'modlist', table.null)
rawset(_ENV, 'mods', table.null)
rawset(_ENV, 'settings', {})

data.raw = fns.table.null

setmetatable(_ENV.settings, {
    __index = function() die("_ENV.settings is not available at this time") end,
    __newindex = function() die("_ENV.settings is not available at this time") end,
})

local function log_change(new, cutpath, fullpath, value)
    if new then __log(cutpath:replace_prefix('data.raw'):replace_prefix('.') .. ' = ...') end
end

function data.begin_data_stage(proxied)
    if proxied then
        __log("beginning data stage proxied")
        data.raw = proxy.makeproxy{
            tbl=rawdata.load(_ENV.modlist),
            rootname='data.raw',
            hook=log_change,
            maxdepth=2,
        }
    else
        __log("beginning data stage")
        data.raw = rawdata.load(_ENV.modlist)
    end
    rawset(_ENV, 'settings', namespace.import('test.settings'):seal())
    rawset(_ENV, 'mods', table.collect(table.set(_ENV.modlist), function() return 'X.X.X' end))
end

function data.begin_control_stage()
    rawset(_ENV, 'storage', {})
end

local settings = namespace 'test.settings'

function data.extend(self, protos)

    local line = debug.getline(2)

    assert(table.is_array(protos), "data:extend called with non-array")

    for i, proto in ipairs(protos) do

        assert(fns.identifiers[proto.name], "not an fns-based name: " .. proto.name)

        proto.__declared_at = line

        if proto.type:endswith('-setting') and data.raw == table.null then

            settings[proto.setting_type] = settings/proto.setting_type or {}

            if settings[proto.setting_type][proto.name] then
                error(i .. ":" .. proto.setting_type .. " "
                .. proto.name .. " already declared!\ninitially:" ..
                    settings[proto.setting_type][proto.name].__declared_at .. "\nnow:" .. line, 2)
            end

            proto.value = proto.default_value
            settings[proto.setting_type][proto.name] = proto

        elseif data.raw ~= table.null then

            if proto.type:endswith('-setting') then error("attempted to declare setting " .. proto.name .. " at data stage", 2) end

            local raw = data.raw
            if proxy.is_proxied(data.raw) then raw = data.raw.__real end

            raw[proto.type] = raw[proto.type] or {}

            if raw[proto.type][proto.name] then
                error(i .. ":" ..proto.type .. " "
                .. proto.name .. " already declared!\ninitially:" ..
                    raw[proto.type][proto.name].__declared_at .. "\nnow:" .. line, 2)
            end
            raw[proto.type][proto.name] = proto
        else
            error("call to data:extend{ { type = '" .. proto.type .. "' } } when data.raw isn't loaded")
            break
        end

        __log("data:extend{{ type = " .. ("%q"):format(proto.type) .. ", name = fns " .. ("%q"):format(proto.name:replace_prefix('feeds-n-speeds-')) .. " }}")

        localisation.register(proto)
    end
end

local proxy = require 'test.proxy'


rawset(_ENV, 'data', data:seal())