

local mod_identifiers = {}
local mod_prefixes = {}
local mod_identifier_categories = {}

function _G.fns(name, sep, ...)
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

function _G.fns_locale_key(category, name)
    assert(type(category) == 'string', "invalid category: " .. tostring(category))
    
    name = fns(name)
    
    category = string.gsub(category, '[^a-zA-Z0-9]', '-')


    mod_identifier_categories[category] = mod_identifier_categories[category] or {}
    mod_identifier_categories[category][name] = true
    
    return category .. '.' .. name
end

function _G.is_fns_name(name)
    return table.index_of(mod_prefixes,
        function(pref) return name:sub(1, #pref) == pref end)
        and true or false
end

function _G.fns_categorized_names()
    return table.collect(mod_identifier_categories, table.sorted_keys)
end

function _G.fns_declared_names()
    return table.sorted_keys(mod_identifiers)
end

function _G.fns_control_stage()
    function _G.fns(name)
        return 'feeds-n-speeds-' .. string.gsub(name, '[^a-zA-Z0-9]', '-')
    end
    function _G.fns_locale_key(category)
        return string.gsub(category, '[^a-zA-Z0-9]', '-') .. '.feeds-n-speeds-' .. string.gsub(name, '[^a-zA-Z0-9]', '-')
    end
end

function _G.prototype(...)
    local tbl = table.pack(...)
    tbl.n = nil
    table.each(tbl, table.purgemetatable)
    data:extend(tbl)
end