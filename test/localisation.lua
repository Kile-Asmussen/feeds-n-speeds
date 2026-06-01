
local fns = require 'fns'
local localisation = require('namespace')('test.localisation')
local debuglib = require 'debuglib'

local table = fns.table

localisation.keys = { }
localisation.skipped_keys = { }
localisation.dead_types = { }
localisation.require_descriptions = false

function localisation.add_key(cat, key, content)
    localisation.keys[cat] = localisation.keys[cat] or {}

    if localisation.keys[cat][key] == nil or table.is_empty(localisation.keys[cat][key]) then
        localisation.keys[cat][key] = content or {}
    elseif content ~= nil then
        log(
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

local ITEM_TYPES = table.set{
    'item', 'ammo', 'capsule', 'gun', 'module', 'tool', 'armor', 'repair-tool',
    'blueprint', 'blueprint-book', 'deconstruction-item', 'upgrade-item',
    'copy-paste-tool', 'selection-tool', 'spidertron-remote',
    'item-with-entity-data', 'item-with-label', 'item-with-inventory',
    'item-with-tags', 'rail-planner', 'space-platform-starter-pack',
}

local EQUIPMENT_TYPES = table.set{
    'active-defense-equipment', 'battery-equipment', 'belt-immunity-equipment',
    'energy-shield-equipment', 'equipment-ghost', 'generator-equipment',
    'inventory-bonus-equipment', 'movement-bonus-equipment',
    'night-vision-equipment', 'roboport-equipment', 'solar-panel-equipment',
}

function localisation.key_category(proto)
    if ITEM_TYPES[proto.type] then
        return 'item'
    elseif EQUIPMENT_TYPES[proto.type] then
        return 'equipment'
    elseif proto.type == 'fluid' then
        return 'fluid'
    elseif proto.type == 'tile' then
        return 'tile'
    elseif proto.type == 'recipe' then
        return 'recipe'
    elseif proto.type == 'technology' then
        return 'technology'
    elseif proto.type:match('%-setting$') then
        return 'mod-setting'
    elseif proto.type == 'noise-expression'
        or proto.type == 'noise-function'
        or proto.type == 'recipe-category'
        or proto.type == 'resource-category'
        or proto.type == 'fuel-category'
        or proto.type == 'ammo-category'
        or proto.type == 'damage-type'
        or proto.type == 'collision-layer'
        or proto.type == 'deliver-category'
        or proto.type == 'module-category'
        or proto.type == 'equipment-category'
        or proto.type == 'burner-usage'
        or proto.type == 'projectile'
        or proto.type == 'stream'
    then
        return nil
    else
        return 'entity'
    end
end

function localisation.register(proto)
    -- if proto.hidden then
        -- return
    -- end

    local proto_name = proto.name

    if proto.type == 'technology' then
        proto_name = proto_name:gsub('%-%d+$', '')
    end
    
    local category = localisation.key_category(proto)
    if not category then
        localisation.dead_types[proto.type] = true
        return
    end

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
        elseif l:match('=') then
            local key = l:gsub("=.*$", "")
            localisation.__current_locale_map[cat][key] = true
        end
    end
    file:close()
    
    return localisation.__current_locale_map
end

function localisation.add_manual_keys()
    local manual = fns.extra_localsation_keys

    for cat, list in pairs(manual) do
        for name, _ in pairs(list) do
            localisation.add_key(cat, name)
        end
    end
end

function localisation.winnow_unneeded_keys()
    local function skip_pair(base_cat, proto_name, reason)
        localisation.skip_key(base_cat .. '-name', proto_name, reason)
    end

    local function proto_has_explicit_locale(cat_name, proto_name)
        local cat = localisation.keys[cat_name]
        return cat and cat[proto_name] and not table.is_empty(cat[proto_name])
    end

    local function references_explicit_key(content)
        if type(content) == 'string' then
            return fns.explicit_localisation_keys[content] or false
        elseif type(content) == 'table' then
            for _, v in ipairs(content) do
                if references_explicit_key(v) then return true end
            end
            return false
        end
    end

    -- General pass: a non-empty localised_name/description on the prototype means
    -- Factorio uses it directly and never consults the locale file for that key.
    -- Exception: if the content references an explicitly generated locale key, it is needed.
    for cat_name, keys in pairs(localisation.keys) do
        for proto_name, content in pairs(keys) do
            if not table.is_empty(content) and not references_explicit_key(content) then
                localisation.skip_key(cat_name, proto_name, 'prototype provides localised string directly')
            end
        end
    end

    -- Item-specific pass: items with no explicit localised_name can still inherit
    -- from place_result or placed_as_equipment_result.
    local function result_covered(result_name, result_locale_cat)
        if not result_name then return false end
        -- result has explicit localised_name → Factorio uses it
        if proto_has_explicit_locale(result_locale_cat .. '-name', result_name) then return true end
        -- result has no explicit string → Factorio falls back to the locale file key
        local result_keys = localisation.keys[result_locale_cat .. '-name']
        return result_keys ~= nil and result_keys[result_name] ~= nil
    end

    for item_name, _ in pairs(localisation.keys['item-name'] or {}) do
        local proto
        for type_name, _ in pairs(ITEM_TYPES) do
            local cat = data.raw[type_name]
            if cat and cat[item_name] then
                proto = cat[item_name]
                break
            end
        end
        if not proto then goto continue end

        if result_covered(proto.place_result, 'entity') then
            skip_pair('item', item_name, 'inherited from place_result entity locale')
        elseif result_covered(proto.placed_as_equipment_result, 'equipment') then
            skip_pair('item', item_name, 'inherited from placed_as_equipment_result locale')
        end

        ::continue::
    end

    -- Recipe pass: a recipe whose main product item is already covered needs no
    -- recipe-name/description locale entry either.
    local function product_is_covered(name)
        for _, cat in ipairs{'item', 'fluid'} do
            local skipped = localisation.skipped_keys[cat .. '-name']
            if skipped and skipped[name] then return true end
            if proto_has_explicit_locale(cat .. '-name', name) then return true end
            local keys = localisation.keys[cat .. '-name']
            if keys and keys[name] then return true end
        end
        return false
    end

    local function recipe_main_product(recipe)
        if recipe.main_product == "" then return nil end
        if recipe.main_product then
            -- find it in results
            for _, r in ipairs(recipe.results or {}) do
                assert(type(r) == 'table', "recipe " .. recipe.name .. " is wonky!")
                if r.name == recipe.main_product and r.type ~= 'fluid' then
                    return r.name
                end
            end
            return nil
        end
        -- no main_product field: covered only if exactly one result of any type
        local results = recipe.results or {}
        if #results == 1 then return results[1].name end
        return nil
    end

    for recipe_name, _ in pairs(localisation.keys['recipe-name'] or {}) do
        local proto = data.raw['recipe'] and data.raw['recipe'][recipe_name]
        if not proto then goto continue2 end

        local main = recipe_main_product(proto)
        if main and product_is_covered(main) then
            skip_pair('recipe', recipe_name, 'inherited from main product item locale')
        end

        ::continue2::
    end
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

        local skipped = localisation.skipped_keys[cat] or {}

        if not cat:match('%-description$') then
        for _, key in ipairs(keys_in_cat) do
            if not skipped[key] and (not locale_map[cat] or not locale_map[cat][key]) then
                if not any then
                    any = true
                    table.insert(res, '[' .. cat .. ']')
                end
                table.insert(res, key .. '=')
            end
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

function localisation.list_dead_locale_keys()
    local res = {}

    local locale_map = localisation.current_locale_map()

    -- Derive the set of locale category prefixes that dead types could produce
    -- e.g. dead type 'noise-expression' -> 'entity-name', 'entity-description'
    -- We don't know the mapping, so we scan all locale categories for any key
    -- whose prototype type is in dead_types.
    for _, cat in ipairs(table.sorted_keys(locale_map)) do
        local any = false
        for _, key in ipairs(table.sorted_keys(locale_map[cat])) do
            if not key:match('^feeds%-n%-speeds%-') then goto next_key end
            -- A key is "dead" if it isn't tracked in localisation.keys at all,
            -- unless it was explicitly generated via fns.locale_key.
            if not (localisation.keys[cat] and localisation.keys[cat][key])
            and not (localisation.skipped_keys[cat] and localisation.skipped_keys[cat][key])
            and not fns.explicit_localisation_keys[cat .. '.' .. key]
            then
                if not any then
                    any = true
                    table.insert(res, '[' .. cat .. ']')
                end
                table.insert(res, key .. '=')
            end
            ::next_key::
        end
    end

    return table.concat(res, '\n')
end

return localisation:seal()