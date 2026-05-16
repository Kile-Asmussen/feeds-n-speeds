
package.path = './lualib/?.lua;' .. package.path
_ENV.remote = { add_interface = function() end, interfaces = {} }
_ENV.script = {}
setmetatable(script, {
    __index = function(script, key)
        if key:find("on_") == 1 then
            script[key] = function() end
        end
        return script[key]
    end
})
_ENV.defines = { }
setmetatable(defines, {
    __index = function(defines, key)
        defines[key] = { __n = 1 }
        setmetatable(defines[key], {
            __index = function(def_key, name)
                def_key[name] = def_key.__n
                def_key.__n = def_key.__n + 1
                return def_key[name]
            end
        })
        return defines[key]
    end
})


local __fns_existing_keys = {}
local pairs, ipairs = pairs, ipairs
local table = table
local print = print
local rawset = rawset

for k, v in pairs(_ENV) do
    __fns_existing_keys[k] = v
end

_ENV.circuit_connector_definitions = {
    create_single = function() return {} end,
    create_vector = function() return {} end
}

require 'lualib.dataloader'
__fns_existing_keys.data = _ENV.data
require 'lualib.util'
require 'lualib.math3d'
require 'lualib.space-finish-script'
require 'lualib.bonus-gui-ordering'
require 'lualib.resource-autoplace'
require 'lualib.data-duplicate-checker'
require 'lualib.circuit-connector-generated-definitions'
require 'lualib.silo-script'
require 'lualib.autoplace_utils'
require 'lualib.math2d'
require 'lualib.crash-site'
require 'lualib.collision-mask-util'
require 'lualib.circuit-connector-sprites'
require 'lualib.collision-mask-defaults'
require 'lualib.mod-gui'
require 'lualib.production-score'
require 'lualib.surface-render-parameter-effects'
require 'lualib.sound-util'
require 'lualib.meld'
require 'lualib.story'
require 'lualib.kill-score'
require 'lualib.event_handler'

local x = {}
for k, v in pairs(_ENV) do
    if __fns_existing_keys[k] ~= v then
        table.insert(x, k)
    end
end
table.sort(x)
for _, v in ipairs(x) do
    if type(_ENV[v]) == 'table' then
        print("_ENV." .. v .. " = nil")
    end
end
