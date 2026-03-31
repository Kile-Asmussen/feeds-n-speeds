require 'data.raw'
require 'debuglib'
require 'prelude'

debuglib.recursion_limit = tonumber(os.getenv("DEPTH")) or 2

function log(str) print(str) end

settings = {}



function data.extend(self, protos)
    for _, proto in ipairs(protos) do

        log('data:extend{'.. debuglib.sprint(proto) .. '}')

        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type] = settings[proto.setting_type] or {}
            settings[proto.setting_type][proto.name] = proto.default_value
        end
    end
end