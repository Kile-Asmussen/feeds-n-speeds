require 'prelude'

local loading = namespace 'loading'

function loading.execute_stage(namespace, stage, extra)
    log(tostring(namespace) .. '.' .. stage .. '()')

    extra = extra or function() end

    for domain_name, domain in pairs(namespace) do
        if type(domain) == 'table' then
            if type(domain(stage)) == 'function' then
                extra(domain, true)
                log(tostring(namespace) .. '.' .. domain_name .. '.' .. stage .. '()')
                domain(stage)()
            else
                extra(domain, false)
            end
        end
    end
end

function loading.create_toggle(domain, exists)
    if type(domain 'toggle') == 'string' then
        data:extend{{
            type = 'bool-setting',
            name = domain.toggle,
            setting_type = 'startup',
            default_value = domain.enabled,
        }}
    end
end

function loading.read_toggle(domain, exists)
    if type(domain 'toggle') == 'string' then
        domain.enabled = settings.startup[domain.toggle].value
        if exists then
            log(tostring(domain) .. '.' .. 'enabled = ' .. tostring(domain.enabled))
        end
    end
end

return loading:__seal()