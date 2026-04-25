require 'prelude'

local localization = namespace 'test.localization'

localization.keys = {

}

local function lockey(proto, class)
    if
        proto.type == 'item'
        or proto.type == 'recipe'
        or proto.type == 'technology'
        or proto.type == 'autoplace-control'
    then
        return proto.type .. '-' .. class
    elseif proto.type:match("%-setting$") then
        return 'mod-setting-' .. class
    else
        return 'entity-' .. class
    end
end

function localization.register(proto)
    if proto.localised_name then return end
    
    local loc_name = lockey(proto, 'name')
    local description = lockey(proto, 'description')
    
    localization.keys[loc_name] = localization.keys[loc_name] or {}
    localization.keys[description] = localization.keys[description] or {}

    if not localization.keys[loc_name][proto.name] then
        localization.keys[loc_name][proto.name] = true
    end

    if not localization.keys[description][proto.name] then
        localization.keys[description][proto.name] = true
    end
end

local debuglib = require 'debuglib'
local open_file = io.open
function localization.generate_stubs()

    local locale_map = {}
    local heading = table.null
    
    local file = open_file('./locale/en/localization.cfg')
    for l in file:lines() do
        if l:match('%[.*%]') then
            cat = l:gsub('%[', ''):gsub('%]', '')
            heading = {}
            locale_map[cat] = heading
        else
            local key = l:gsub("=.*", "")
            heading[key] = true
        end
    end
    file:close()
    file = nil

    local res = table.new()

    local categories = table.sorted_keys(localization.keys)

    for _, cat in ipairs(categories) do
        local any = false
        
        local manual = fns_names_by_category(cat)
        table.append(manual, localization.keys[cat])
        table.sort(manual)

        for _, key in ipairs(manual) do
            if not locale_map[cat] or not locale_map[cat][key] then
                if not any then
                    any = true
                    res:insert('[' .. cat .. ']')
                end
                res:insert(key .. '=')
            end

        end
    end

    return table.concat(res, '\n')
end

return localization:__seal()