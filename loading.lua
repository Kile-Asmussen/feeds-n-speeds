require 'prelude'

local loading = namespace 'loading'

function loading.execute(namespace, operation)
    local domains = {}

    for _, domain in pairs(namespace) do
        if isnamespace(domain) then
            table.insert(domains, domain)
        end
    end

    table.sort(domains,
        function(d1, d2) return (d1('priority') or 0) > (d2('priority') or 0)
    )

    for _, domain in ipairs(namespace) do
        if type(operation) == 'function' then
            operation(domain)
        elseif type(operation) == 'string' then
            (domain(operation) or function() end)()
        end
    end
end

function loading.create_toggle(domain)
    if isnamespace(domain) and
        type(domain 'toggle') == 'string' and
        type(domain 'enabled') == 'boolean'
    then
        data:extend{{
            type = 'bool-setting',
            name = domain.toggle,
            setting_type = 'startup',
            default_value = domain.enabled,
        }}
    end
end

function loading.read_toggle(domain)
    if isnamespace(domain) and
        type(domain 'toggle') == 'string' and
        type(domain 'enabled') == 'boolean'
    then
        domain.enabled = settings.startup[domain.toggle].value
        log(tostring(domain) .. '.' .. 'enabled = ' .. tostring(domain.enabled))
    end
end

return loading:__seal()