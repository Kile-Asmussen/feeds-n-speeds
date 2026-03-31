require('data.raw')
require('debuglib')
require('upgrades')

function log(str) print(str) end

settings = {}



function data.extend(self, protos)
    for _, proto in ipairs(protos) do

        debuglib.print(proto)

        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type] = settings[proto.setting_type] or {}
            settings[proto.setting_type][proto.name] = proto.default_value
        end
    end
end