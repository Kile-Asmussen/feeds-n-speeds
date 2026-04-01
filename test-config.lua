require 'data.raw'
require 'prelude'

setmetatable(_G, {
    __index = function(_, name) error('global ' .. name .. ' not found') end
})

local debuglib = require 'debuglib'

function log(str) print(str) end

_G.settings = {
    startup = {}
}

function data.extend(self, protos)
    for _, proto in ipairs(protos) do

        log('data:extend{'.. debuglib.sprint(proto) .. '}')

        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type][proto.name] = { value = proto.default_value }
        end
    end
end