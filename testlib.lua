require('data.raw')
require('debuglib')
require('table-upgrades')

function log(...)
    print(...)
end

settings = {}

function data.extend(self, protos)
    for _, proto in ipairs(protos) do
        print("Adding prototype:")
        debuglib.print(proto)
        print()

        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type] = settings[proto.setting_type] or {}
            settings[proto.setting_type][proto.name] = proto.default_value
        end
    end
end