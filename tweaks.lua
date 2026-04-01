require 'prelude'

local tweaks = namespace 'tweaks'

function tweaks.__execute(name, extra)
    for domain_name, domain in pairs(tweaks) do
        if type(domain) == 'table' then
            if type(extra) == 'function' then
                extra(domain, domain_name)
            end
            if type(domain(name)) == 'function' then
                domain(name)()
            end
        end
    end
end

function tweaks.__create_toggle(domain, domain_name)
    if type(domain 'toggle') == 'string' then
        data:extend{{
            type = 'bool-setting',
            name = domain.toggle,
            setting_type = 'startup',
            default_value = domain.enabled,
        }}
    end
end

function tweaks.__read_toggle(domain, domain_name)
    if type(domain 'toggle') == 'string' then
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

tweaks.chest = require 'tweaks.chests'
tweaks.concrete = require 'tweaks.concrete'
tweaks.electric = require 'tweaks.electric'
tweaks.inserter = require 'tweaks.inserter'
tweaks.nuclear = require 'tweaks.nuclear'
tweaks.ores = require 'tweaks.ores'

return tweaks:__seal()