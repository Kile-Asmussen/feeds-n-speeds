

local mod_identifiers = {}
local mod_prefixes = {}
local mod_identifier_categories = {}

function _ENV.fns(name, sep, ...)
    sep = sep or '-'
    assert(select('#', ...) == 0, "too many arguments")
    assert(type(sep) == 'string', "invalid separator: " .. tostring(sep))
    assert(type(name) == 'string', "invalid name: " .. tostring(name))

    local prefix = table.concat({'feeds', 'n', 'speeds'}, sep)
    name = prefix .. sep .. string.gsub(name, '[^a-zA-Z0-9]', sep)


    table.insert(mod_prefixes, prefix)
    mod_identifiers[name] = true

    return name
end

function _ENV.fns_locale_key(category, name)
    assert(type(category) == 'string', "invalid category: " .. tostring(category))
    
    name = fns(name)
    
    category = string.gsub(category, '[^a-zA-Z0-9]', '-')


    mod_identifier_categories[category] = mod_identifier_categories[category] or {}
    mod_identifier_categories[category][name] = true
    
    return category .. '.' .. name
end

function _ENV.is_fns_name(name)
    return table.index_of(mod_prefixes,
        function(pref) return name:sub(1, #pref) == pref end)
        and true or false
end

function _ENV.fns_categorized_names()
    return table.collect(mod_identifier_categories, table.sorted_keys)
end

function _ENV.fns_declared_names()
    return table.sorted_keys(mod_identifiers)
end

function _ENV.fns_control_stage()
    function _ENV.fns(name)
        return 'feeds-n-speeds-' .. string.gsub(name, '[^a-zA-Z0-9]', '-')
    end
    function _ENV.fns_locale_key(category)
        return string.gsub(category, '[^a-zA-Z0-9]', '-') .. '.feeds-n-speeds-' .. string.gsub(name, '[^a-zA-Z0-9]', '-')
    end
    function _ENV.assert() end
end

function _ENV.prototype(...)
    local tbl = { ... }
    table.purgemetatable(tbl)
    data:extend(tbl)
end

function _ENV.enabled(...)

    local res = true

    for _, v in ipairs{ ... } do
        res = res and import(v)/'enabled'
    end

    return res
end
