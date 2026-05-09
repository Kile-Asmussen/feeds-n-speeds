require 'prelude'

local loading = namespace 'loading'

function loading.execute(superdomain, operation)
    assert(isnamespace(superdomain), "argument #1 must be a namespace")
    assert(type(operation) ~= 'string', "argument #2 must be a function")

    local domains = {}

    for _, domain_name in ipairs(table.sorted_keys(superdomain)) do
        domain = superdomain[domain_name]
        if
            not domain_name:match('^_')
            and isnamespace(domain)
        then
            table.insert(domains, domain)
        end
    end

    table.sort(domains,
        function(d1, d2)
            return (d2/'dependencies' or table.null)[tostring(d1)]
        end 
    )

    for _, domain in ipairs(domains) do
        operation(domain)
    end
end

function loading.create_toggle(domain)
    if isnamespace(domain) and type(domain/'enabled') == 'boolean'
    then
        data:extend{{
            type = 'bool-setting',
            name = fns(tostring(domain) .. '-enable'),
            setting_type = 'startup',
            default_value = domain.enabled,
        }}
    end
end

function loading.read_toggle(domain)
    if isnamespace(domain) and type(domain/'enabled') == 'boolean'
    then
        local set = settings.startup[fns(tostring(domain) .. '-enable')]
        if set then
            domain.enabled = set.value
        end
    end
end

function loading.call(stage)
    return function(domain)
        (domain/stage or function() end)()
    end
end

function loading.if_enabled(stage)
    return function(domain)
        if domain/'enabled' then
            if type(stage) == 'string' then
                (domain/stage or function() end)()
            else
                stage(domain)
            end
        end
    end
end

return seal_namespace(loading)