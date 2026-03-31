require('data.raw')
require('debuglib')
require('upgrades')

function log(str) print(str) end

settings = {}



function data.extend(self, protos)
    for _, proto in ipairs(protos) do
        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type] = settings[proto.setting_type] or {}
            settings[proto.setting_type][proto.name] = proto.default_value

            log('EXTEND ' .. proto.setting_type .. proto.name:rpad(30) .. string.bool(proto.default_value):rpad(5) .. proto.type)

        end
    end
end