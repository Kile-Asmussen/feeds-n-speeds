-- Hopper linking control logic
-- Implementation for extras/chests.lua control() function
--
-- When a hopper is placed adjacent to a big-steel-chest, it links to that
-- chest's inventory using proxy_target_entity. When the chest is destroyed,
-- the hopper is unlinked. When a chest is placed adjacent to an unlinked
-- hopper, the hopper links to it.

require 'prelude'

local hopper = namespace 'extras.chests.hopper'

-----------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------

hopper.HOPPER_NAME = fns 'big-steel-hopper'
hopper.CHEST_NAME = fns 'big-steel-chest'

-- Both hopper and big-steel-chest are 2x2 entities
-- For a 2x2 entity centered at (x, y), check positions 2 tiles away in each direction
hopper.ADJACENT_OFFSETS = {
    { x =  0, y = -2 },  -- north
    { x =  0, y =  2 },  -- south
    { x = -2, y =  0 },  -- west
    { x =  2, y =  0 },  -- east
}

hopper.ENTITY_FILTER = {
    { filter = "name", name = hopper.HOPPER_NAME },
    { filter = "name", name = hopper.CHEST_NAME },
}

-----------------------------------------------------------------------
-- Storage management
-----------------------------------------------------------------------
-- Schema:
--   storage.hopper_links[hopper_unit_number] = chest_unit_number
--   storage.chest_hoppers[chest_unit_number] = { hopper_unit_number, ... }

function hopper.init_storage()
    storage.hopper_links = storage.hopper_links or {}
    storage.chest_hoppers = storage.chest_hoppers or {}
end

--- Record a link between hopper and chest in storage
--- @param hopper_id uint64
--- @param chest_id uint64
function hopper.record_link(hopper_id, chest_id)
    storage.hopper_links[hopper_id] = chest_id
    storage.chest_hoppers[chest_id] = storage.chest_hoppers[chest_id] or {}
    table.insert(storage.chest_hoppers[chest_id], hopper_id)
end

--- Remove a hopper from storage (when hopper destroyed or unlinked)
--- @param hopper_id uint64
function hopper.remove_hopper_link(hopper_id)
    local chest_id = storage.hopper_links[hopper_id]
    storage.hopper_links[hopper_id] = nil

    if chest_id and storage.chest_hoppers[chest_id] then
        local hoppers = storage.chest_hoppers[chest_id]
        for i, id in ipairs(hoppers) do
            if id == hopper_id then
                table.remove(hoppers, i)
                break
            end
        end
        -- Clean up empty table
        if #hoppers == 0 then
            storage.chest_hoppers[chest_id] = nil
        end
    end
end

--- Remove a chest from storage and return list of orphaned hopper IDs
--- @param chest_id uint64
--- @return uint64[]
function hopper.remove_chest_links(chest_id)
    local hopper_ids = storage.chest_hoppers[chest_id] or {}
    storage.chest_hoppers[chest_id] = nil

    for _, hopper_id in ipairs(hopper_ids) do
        storage.hopper_links[hopper_id] = nil
    end

    return hopper_ids
end

--- Check if a hopper is currently linked
--- @param hopper_id uint64
--- @return boolean
function hopper.is_linked(hopper_id)
    return storage.hopper_links[hopper_id] ~= nil
end

-----------------------------------------------------------------------
-- Entity lookup helpers
-----------------------------------------------------------------------

--- Find all adjacent big-steel-chests to a given entity
--- @param entity LuaEntity
--- @return LuaEntity[]
function hopper.find_adjacent_chests(entity)
    local surface = entity.surface
    local pos = entity.position
    local result = {}

    for _, offset in ipairs(hopper.ADJACENT_OFFSETS) do
        local search_pos = {
            x = pos.x + offset.x,
            y = pos.y + offset.y
        }

        local entities = surface.find_entities_filtered{
            position = search_pos,
            radius = 0.5,
            name = hopper.CHEST_NAME,
        }

        for _, found in ipairs(entities) do
            if found.name == hopper.CHEST_NAME then
                table.insert(result, found)
            end
        end
    end

    return result
end

--- Find exactly one adjacent chest, or nil if zero or multiple
--- @param entity LuaEntity
--- @return LuaEntity|nil
function hopper.find_unique_adjacent_chest(entity)
    local chests = hopper.find_adjacent_chests(entity)
    if #chests == 1 then
        return chests[1]
    end
    return nil
end

--- Find adjacent unlinked hoppers to a given entity
--- @param entity LuaEntity
--- @return LuaEntity[]
function hopper.find_adjacent_unlinked_hoppers(entity)
    local surface = entity.surface
    local pos = entity.position
    local result = {}

    for _, offset in ipairs(hopper.ADJACENT_OFFSETS) do
        local search_pos = {
            x = pos.x + offset.x,
            y = pos.y + offset.y
        }

        local entities = surface.find_entities_filtered{
            position = search_pos,
            radius = 0.5,
            name = hopper.HOPPER_NAME,
        }

        for _, found in ipairs(entities) do
            if found.valid and not hopper.is_linked(found.unit_number) then
                table.insert(result, found)
            end
        end
    end

    return result
end

--- Find entity by unit_number on any surface
--- @param unit_number uint64
--- @return LuaEntity|nil
function hopper.find_by_unit_number(unit_number)
    -- Expensive: scans all surfaces for entity with matching unit_number
    -- Only used during chest destruction, which is infrequent
    for _, surface in pairs(game.surfaces) do
        local hoppers = surface.find_entities_filtered{ name = hopper.HOPPER_NAME }
        for _, found in ipairs(hoppers) do
            if found.unit_number == unit_number then
                return found
            end
        end
    end
    return nil
end

-----------------------------------------------------------------------
-- Link/unlink operations
-----------------------------------------------------------------------

--- Link a hopper to a chest
--- @param hopper_entity LuaEntity
--- @param chest LuaEntity
function hopper.link(hopper_entity, chest)
    hopper_entity.proxy_target_entity = chest
    hopper_entity.proxy_target_inventory = defines.inventory.chest
    hopper.record_link(hopper_entity.unit_number, chest.unit_number)
end

--- Unlink a hopper (clear proxy target)
--- @param hopper_entity LuaEntity
function hopper.unlink(hopper_entity)
    hopper_entity.proxy_target_entity = nil
    hopper.remove_hopper_link(hopper_entity.unit_number)
end

-----------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------

--- Handle hopper placed
--- @param event EventData.on_built_entity
function hopper.on_hopper_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if entity.name ~= hopper.HOPPER_NAME then return end

    -- Only link if exactly one adjacent chest (ambiguous if multiple)
    local chest = hopper.find_unique_adjacent_chest(entity)
    if chest then
        hopper.link(entity, chest)
    end
end

--- Handle chest placed - check for adjacent unlinked hoppers
--- @param event EventData.on_built_entity
function hopper.on_chest_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if entity.name ~= hopper.CHEST_NAME then return end

    local hoppers = hopper.find_adjacent_unlinked_hoppers(entity)
    for _, found in ipairs(hoppers) do
        -- Only link if this is the hopper's only adjacent chest
        if hopper.find_unique_adjacent_chest(found) == entity then
            hopper.link(found, entity)
        end
    end
end

--- Handle hopper destroyed
--- @param event EventData.on_entity_died|EventData.on_player_mined_entity|EventData.on_robot_mined_entity
function hopper.on_hopper_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if entity.name ~= hopper.HOPPER_NAME then return end

    hopper.remove_hopper_link(entity.unit_number)
end

--- Handle chest destroyed - unlink all connected hoppers
--- @param event EventData.on_entity_died|EventData.on_player_mined_entity|EventData.on_robot_mined_entity
function hopper.on_chest_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if entity.name ~= hopper.CHEST_NAME then return end

    local orphaned_ids = hopper.remove_chest_links(entity.unit_number)

    -- Clear proxy targets on orphaned hoppers
    for _, hopper_id in ipairs(orphaned_ids) do
        local found = hopper.find_by_unit_number(hopper_id)
        if found and found.valid then
            found.proxy_target_entity = nil
            -- Check for exactly one other adjacent chest to re-link
            local new_chest = hopper.find_unique_adjacent_chest(found)
            if new_chest then
                hopper.link(found, new_chest)
            end
        end
    end
end

--- Combined handler for entity built events
--- @param event EventData.on_built_entity
function hopper.on_entity_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    if entity.name == hopper.HOPPER_NAME then
        hopper.on_hopper_built(event)
    elseif entity.name == hopper.CHEST_NAME then
        hopper.on_chest_built(event)
    end
end

--- Combined handler for entity destroyed events
--- @param event EventData.on_entity_died
function hopper.on_entity_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    if entity.name == hopper.HOPPER_NAME then
        hopper.on_hopper_destroyed(event)
    elseif entity.name == hopper.CHEST_NAME then
        hopper.on_chest_destroyed(event)
    end
end

-----------------------------------------------------------------------
-- Design notes:
-----------------------------------------------------------------------
--
-- 1. Multiple adjacent chests: Hopper fails to link (ambiguous target).
--    Only links when exactly one adjacent chest exists.
--
-- 2. Orphaned hoppers: When chest destroyed, hopper checks for exactly
--    one remaining adjacent chest to re-link. If zero or multiple,
--    remains unlinked.
--
-- 3. Visual feedback: Not implemented. Could add flying text on link.
--
-- 4. find_by_unit_number is expensive (scans all surfaces).
--    Alternative: store surface index in storage, or cache entity refs
--    and validate on access. Current approach is acceptable since chest
--    destruction is infrequent.
--
-- 5. Event filters include all relevant entity names for performance.
--    script_raised_* events don't support filters.

return hopper:__seal()
