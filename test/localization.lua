require 'prelude'

local localization = namespace 'localization'

localization.keys = {
    ['entity'] = {
        name = {},
        description = {}
    },
    ['item'] = {
        name = {},
        description = {}
    },
    ['technology'] = {
        name = {},
        description = {}
    },
}

function localization.register_name(proto)
    if proto.localised_name then return end
    if localization.keys[proto.type] then
        localization.keys[proto.type].name[proto.name] = true
    else
        localization.keys.entity.name[proto.name] = true
    end
end

function localization.register_description(proto)
    if proto.localised_description then return end
    if localization.keys[proto.type] then
        localization.keys[proto.type].description[proto.name] = true
    else
        localization.keys.entity.description[proto.name] = true
    end
end

function localization.register(proto)
    localization.register_name(proto)
    localization.register_description(proto)
end


local open_file = io.open
function localization.generate_stubs()

    local file = open_file('./locale/en/localization.cfg')
    local locale_file = file:read("*a")
    file:close()
    file = nil

    local res = table.new()

    for _, heading in ipairs({
        '[mod-setting-name]',
        '[mod-setting-description]'
    }) do
        res:insert(heading)
        for _, setting_category in pairs(settings) do
            for key, _ in pairs(setting_category)  do
                if not locale_file:match(key:gsub('%-', '%%-')) then
                    res:insert(key .. '=')
                end
            end
        end
        res:insert('')
    end

    for heading, categories in pairs(localization.keys) do
        for category, list in pairs(categories) do
            table.insert(res, '[' .. heading .. '-' .. category .. ']')
            for _, entry in ipairs(table.sorted_keys(list)) do
                if not locale_file:match(entry:gsub('%-', '%%-')) then
                    res:insert(entry .. '=')
                end
            end
            table.insert(res, '')
        end
    end

    return table.concat(res, '\n')
end

return localization:__seal()