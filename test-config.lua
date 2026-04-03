require 'prelude'

data = namespace('data')
data.raw = require 'raw'

setmetatable(_G, {
    __index = function(_, name) error('global ' .. name .. ' not found') end
})

function log(str) print(str) end

setting = namespace('settings')
setting.startup = {}

local localizations_keys = {
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

local function register_name_localization(proto)
    if proto.localised_name then return end
    if localizations_keys[proto.type] then
        localizations_keys[proto.type].name[proto.name] = true
    else
        localizations_keys.entity.name[proto.name] = true
    end
end

local function register_description_localization(proto)
    if proto.localised_description then return end
    if localizations_keys[proto.type] then
        localizations_keys[proto.type].description[proto.name] = true
    else
        localizations_keys.entity.description[proto.name] = true
    end
end

local function register_localization(proto)
    register_name_localization(proto)
    register_description_localization(proto)
end

function generate_localization_stub()

    local file = io.open('./locale/en/localization.cfg')
    local localization = file:read("*a")
    file:close()
    file = nil

    local res = table.new()

    for _, heading in ipairs({
        '[mod-setting-name]',
        '[mod-setting-description]'
    }) do
        res:insert(heading)
        for _, setting_category in pairs(setting) do
            for key, _ in pairs(setting_category)  do
                if not localization:match(key:gsub('%-', '%%-')) then
                    res:insert(key .. '=')
                end
            end
        end
        res:insert('')
    end

    for heading, categories in pairs(localizations_keys) do
        for category, list in pairs(categories) do
            table.insert(res, '[' .. heading .. '-' .. category .. ']')
            for _, entry in ipairs(table.sorted_keys(list)) do
                if not localization:match('^' .. entry:gsub('%-', '%%-')) then
                    res:insert(entry .. '=')
                end
            end
            table.insert(res, '')
        end
    end

    return table.concat(res, '\n')
end

function data.extend(self, protos)
    local simple = {}
    for _, proto in ipairs(protos) do
        
        table.insert(simple, '  { name = "' .. proto.name .. '", type = "' .. proto.type .. '" }')

        if proto.type:match('%-setting$') then

            setting[proto.setting_type][proto.name] = { value = proto.default_value }

        else if data.raw[proto.type] then

            data.raw[proto.type][proto.name] = proto
            register_localization(proto)
            
        else
            error("unknown prototype " .. proto.type)
        end
    end
end
    log('data:extend{\n' .. table.concat(simple, '\n') .. '\n}')
end

setting:__seal()
data:__seal()