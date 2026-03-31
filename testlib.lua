require('data.raw')
require('debuglib')
require('upgrades')

log = print

settings = {}



function data.extend(self, protos)
    for _, proto in ipairs(protos) do
        if table.matches({ type = 'bool-setting' }, proto) then
            settings[proto.setting_type] = settings[proto.setting_type] or {}
            settings[proto.setting_type][proto.name] = proto.default_value

            log('EXTEND', proto.setting_type, proto.default_value, proto.type, settings.startup, settings.startup[proto.name])

        end
    end
end