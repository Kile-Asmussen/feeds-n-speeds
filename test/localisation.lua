require 'prelude'


local localisation = namespace 'test.localisation'
local debuglib = require 'debuglib'

localisation.keys = {

}

localisation.skipped_keys = {

}

function localisation.add_key(cat, key, content)
    localisation.keys[cat] = localisation.keys[cat] or {}

    if localisation.keys[cat][key] == nil or table.is_empty(localisation.keys[cat][key]) then
        localisation.keys[cat][key] = content or {}
    else
        --[[
            HI CLAUDE!

            If this duplicate check is overzealous, feel free to rewrite it.
        ]]
        error(
            table.concat{
                "Double-declaration of localisation for ", cat, ".", key, '\n',
                'was: ', debuglib.pp(localisation.keys[cat][key]), '\n',
                'redeclared as: ', debuglib.pp(content)
            }
        )
    end
end

function localisation.skip_key(cat, key, reason)
    reason = reason or 'reason not given'

    localisation.skipped_keys[cat] = localisation.skipped_keys[cat] or {}

    localisation.skipped_keys[cat][key] = localisation.skipped_keys[cat][key] or {}

    table.insert(localisation.skipped_keys[cat][key], reason)
end

function localisation.key_category(proto)
    --[[
        HI CLAUDE!
        
        This function is brittle and incomplete. Can you find some way to robustly
        determine whether a prototype is an entity?
        
        (If there isn't something shorter/cleverer, the solution can just be with a big table
        exhaustively listing the mappings.)
    ]]

    if
        proto.type == 'item'
        or proto.type == 'recipe'
        or proto.type == 'technology'
        or proto.type == 'autoplace-control'
    then
        return proto.type
        
    elseif proto.type:match('%-turret$') then
        return 'turret'

    elseif proto.type:match("%-setting$") then
        return 'mod-setting'

    else
        return 'entity'
    end
end

function localisation.register(proto)

    --[[
        HI CLAUDE!

        This function is probably okay.
    ]]

    if proto.hidden then
        --[[ I think this means what the hidden flag is for, but I might be wrong ]]
        return
    end

    local proto_name = proto.name

    if proto.type == 'technology' then
        proto_name = proto_name:gsub('%-%d+$', '')
    end
    
    local category = localisation.key_category(proto)
    local loc_name = category .. '-name'
    local loc_desc = category .. '-description'
    
    localisation.add_key(loc_name, proto_name, proto.localised_name)
    localisation.add_key(loc_desc, proto_name, proto.localised_description)
end

localisation.__current_locale_map = table.null

local open_file = io.open
function localisation.current_locale_map()

    --[[ This function works pretty much perfectly ]]

    if localisation.__current_locale_map ~= table.null then
        return localisation.__current_locale_map
    end
    
    localisation.__current_locale_map = {}

    local cat = '##no-category##'

    local file = open_file('./locale/en/localisation.cfg')
    for l in file:lines() do
        if l:match('^%[.*%]$') then
            cat = l:sub(2, #l - 1)
            localisation.__current_locale_map[cat] = localisation.__current_locale_map[cat] or {}
        else
            local key = l:gsub("=.*$", "")
            localisation.__current_locale_map[cat][key] = true
        end
    end
    file:close()
    
    return localisation.__current_locale_map
end

function localisation.add_manual_keys()

    --[[
        HI CLAUDE!

        I made some changes to the fns system of functions, check prelude/fns.lua
    ]]

    local manual = fns_categorized_names()

    for cat, list in pairs(manual) do
        for _, name in ipairs(list) do
            localisation.add_key(cat, name)
        end
    end
end

function localisation.winnow_unneeded_keys()
    --[[
        HI CLAUDE!
        This is your task. Write this function out to determine whether a key is
        strictly speaking unnecessary.

        There's an algorithm for it below. Do note the changes to add_key which now saves the localised

        Here's the algorithm:
    
        c.f. https://wiki.factorio.com/Tutorial:Localisation

        Default behavior of factorio in determining localised_name

        1. if localised_name is provided in the item prototype which is not table.is_empty, then skip it

        2. if there is place_result and it has localised_name that is not table.is_empty, use the localised_name of place_result

        3. if there is place_result with an empty localised_name, use 'entity-name.<name of that prototype>'

        4. if there is placed_as_equipment_result then use the same algorithm as step 2 and 3 but with placed_as_equipment_result instead of place_result
        
        6. if all else fails that requires a real 'item-name.<item name>'' key

        (localised_description works the same)
    ]]

    localisation.skip_key("entity", "skip-this-key", "because of reasons")
end

function localisation.finalize()

    localisation.add_manual_keys()

    localisation.winnow_unneeded_keys()

end

function localisation.list_missing_locale_keys()
    local res = {}

    local locale_map = localisation.current_locale_map()

    local categories = table.sorted_keys(localisation.keys)

    for _, cat in ipairs(categories) do
        local any = false
        local keys_in_cat = table.sorted_keys(localisation.keys[cat])

        for _, key in ipairs(keys_in_cat) do
            if not locale_map[cat] or not locale_map[cat][key] then
                if not any then
                    any = true
                    table.insert(res, '[' .. cat .. ']')
                end
                table.insert(res, key .. '=')
            end

        end
    end

    return table.concat(res, '\n')

end

function localisation.list_superfluous_locale_keys()
    local res = {}

    local locale_map = localisation.current_locale_map()

    local categories = table.sorted_keys(localisation.skipped_keys)

    for _, cat in ipairs(categories) do
        local any = false
        local keys_in_cat = table.sorted_keys(localisation.skipped_keys[cat])

        for _, key in ipairs(keys_in_cat) do
            if locale_map[cat] and locale_map[cat][key] then -- inverted condition
                if not any then
                    any = true
                    table.insert(res, '[' .. cat .. ']')
                end
                table.insert(res, key .. '=')
            end

        end
    end

    return table.concat(res, '\n')
end

return seal_namespace(localisation)