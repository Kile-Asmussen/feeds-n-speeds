require('prelude')
require('debuglib')

tweaks = tweaks or {}

function tweaks.__execute(name, extra)
    for domain_name, domain in pairs(tweaks) do
        if type(domain) == 'table' then
            if type(extra) == 'function' then
                extra(domain, domain_name)
            end
            if type(domain[name]) == 'function' then
                domain[name]()
            end
        end
    end
end

function tweaks.__create_toggle(domain, domain_name)
    if type(domain.toggle) == 'string' then
        default_value = domain.enabled_by_default or false

        local proto = {
            type = 'bool-setting',
            name = domain.toggle,
            setting_type = 'startup',
            default_value = default_value,
        }

        log(string.sprint(
            'EXTEND', debuglib.sprint(proto)
        ))

        data:extend{proto}
    end
end

function tweaks.__read_toggle(domain, domain_name)
    if type(domain.toggle) == 'string' then
        domain.enabled = settings.startup[domain.toggle].value
    end
end

function tweaks.settings()
    tweaks.__execute('settings', tweaks.__create_toggle)
end

function tweaks.settings_updates()
    tweaks.__execute('settings_updates')
end

function tweaks.settings_final_fixes()
    tweaks.__execute('settings_final_fixes')
end

function tweaks.data()
    tweaks.__execute('data', tweaks.__read_toggle)
end

function tweaks.data_updates()
    tweaks.__execute('data_updates', tweaks.__read_toggle)
end

function tweaks.data_final_fixes()
    tweaks.__execute('data_final_fixes', tweaks.__read_toggle)
end

function tweaks.control()
    tweaks.__execute('control', tweaks.__read_toggle)
end

require('tweaks.chests')
require('tweaks.concrete')
require('tweaks.electric')
require('tweaks.inserter')
require('tweaks.nuclear')
require('tweaks.ores')


