

local mod_identifiers = {}
local mod_identifier_categories = {}

function _G.fns(name, ...)
    assert(select('#', ...) == 0, "too many arguments")
    assert(type(name) == 'string', "invalid name: " .. tostring(name))

    name = string.gsub(name, '[^a-zA-Z0-9]', '-')
    name = 'feeds-n-speeds-' .. name
    mod_identifiers[name] = true

    return name
end

function _G.fns_locale_key(category, name)
    assert(type(category) == 'string', "invalid category: " .. tostring(category))
    
    category = string.gsub(category, '[^a-zA-Z0-9]', '-')

    name = fns(name)

    mod_identifier_categories[category] = mod_identifier_categories[category] or {}
    mod_identifier_categories[category][name] = true
    
    return category .. '.' .. name
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

