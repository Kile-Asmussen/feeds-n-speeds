-- Predicate for localization stub generation.
-- Returns true if a prototype's name/description stubs can be skipped
-- because Factorio will inherit them automatically.
--
-- Rules:
--   Entities: skip if there exists an item with the same name that places
--             this entity — Factorio uses the item-name locale for the entity
--             tooltip automatically.
--   Recipes:  skip if the recipe has a single result (or main_product set)
--             whose item is already localized or skippable per the above.

local ITEM_TYPES = { 'item', 'item-with-entity-data', 'tool', 'ammo',
                     'module', 'capsule', 'armor', 'gun', 'blueprint',
                     'deconstruction-item', 'upgrade-item', 'spidertron-remote' }

-- Returns the item proto (from any item-like category) that places entity_name, or nil.
local function find_placing_item(entity_name)
    for _, item_type in ipairs(ITEM_TYPES) do
        local cat = data.raw[item_type]
        if cat then
            local item = cat[entity_name]
            if item and item.place_result == entity_name then
                return item
            end
        end
    end
end

local function item_has_locale(item_name, locale_map)
    return locale_map['item-name'] and locale_map['item-name'][item_name]
end

local function entity_needs_locale(proto, locale_map)
    if proto.localised_name then return false end

    -- If an item of the same name places this entity, Factorio shows the
    -- item-name string in the entity tooltip — no entity-name stub needed.
    local placing_item = find_placing_item(proto.name)
    if placing_item then return false end

    return true
end

local function recipe_needs_locale(proto, locale_map)
    if proto.localised_name then return false end

    -- Determine the primary product item name
    local primary
    if proto.main_product ~= nil then
        if proto.main_product == "" then return true end  -- explicit multi-output
        primary = proto.main_product
    elseif proto.results and #proto.results == 1 then
        primary = proto.results[1].name
    elseif proto.result then
        primary = proto.result  -- legacy shorthand
    else
        return true  -- multiple results, no primary
    end

    -- Recipe inherits locale from the primary item if that item has a locale
    -- entry, or if that item itself doesn't need a stub (because its entity
    -- tooltip covers it).
    if item_has_locale(primary, locale_map) then return false end

    local placing_item = find_placing_item(primary)
    if placing_item then return false end

    return true
end

-- Top-level predicate: returns true if the prototype needs a stub generated.
local function needs_locale_stub(proto, locale_map)
    if proto.type == 'recipe' then
        return recipe_needs_locale(proto, locale_map)
    elseif proto.type == 'item'
        or proto.type == 'technology'
        or proto.type:match('%-setting$')
    then
        return true  -- these always need their own locale
    else
        return entity_needs_locale(proto, locale_map)
    end
end
