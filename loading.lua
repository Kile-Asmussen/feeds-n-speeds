
local debuglib = require 'debuglib'
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

    table.simple_sort(domains,
        loading.compare_dependencies
    )

    for _, domain in ipairs(domains) do
        operation(domain)
    end
end

function loading.compare_dependencies(d1, d2)

    if (d1/'dependencies') and not (d2/'dependencies') then
        if d1.dependencies[tostring(d2)] then
            return false
        else
            return true
        end
    elseif not (d1/'dependencies') and (d2/'dependencies') then
        if d2.dependencies[tostring(d1)] then
            return true
        else
            return false
        end
    elseif (d1/'dependencies') and (d2/'dependencies') then
        if d1.dependencies[tostring(d2)] and d2.dependencies[tostring(d1)] then
            error("Cyclic dependency found: " .. tostring(d1) .. ' ' .. tostring(d2))
        elseif d1.dependencies[tostring(d2)] then
            return false
        elseif d2.dependencies[tostring(d1)] then
            return true
        else
            return true
        end
    else
        return true
    end

end

function loading.create_toggle(domain)
    if isnamespace(domain) and type(domain/'enabled') == 'boolean'
    then
        data:extend{{
            type = 'bool-setting',
            name = fns(tostring(domain) .. '-enable'),
            order = 'b',
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

return loading:seal()