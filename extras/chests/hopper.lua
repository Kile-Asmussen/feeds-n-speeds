-- Hopper linking control logic
-- Implementation for extras/chests.lua control() function
--
-- When a hopper is placed adjacent to a big-steel-chest, it links to that
-- chest's inventory using proxy_target_entity. When the chest is destroyed,
-- the hopper is unlinked. When a chest is placed adjacent to an unlinked
-- hopper, the hopper links to it.
--
-- Uses a neighbor graph to track adjacencies between all hoppers and chests.
-- This avoids corner cases where dying entities are still "valid" during
-- event handlers.

require 'prelude'

local hopper = namespace 'extras.chests.hopper'

-----------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------

hopper.HOPPER_NAME = fns 'big-steel-hopper'
hopper.CHEST_NAME = fns 'big-steel-chest'

-- Direction constants for 2x2 entities
-- Each direction includes the offset to find a neighbor and its opposite
hopper.DIRECTIONS = {
    north = { x =  0, y = -2, opposite = 'south' },
    south = { x =  0, y =  2, opposite = 'north' },
    west  = { x = -2, y =  0, opposite = 'east'  },
    east  = { x =  2, y =  0, opposite = 'west'  },
}

hopper.ENTITY_FILTER = {
    { filter = "name", name = hopper.HOPPER_NAME },
    { filter = "name", name = hopper.CHEST_NAME },
}

-----------------------------------------------------------------------
-- Storage management
-----------------------------------------------------------------------
-- Schema:
--   storage.neighbors[unit_number] = {
--       north = unit_number | nil,
--       south = unit_number | nil,
--       east = unit_number | nil,
--       west = unit_number | nil,
--   }
--
--   storage.hopper_links[hopper_unit_number] = chest_unit_number
--
-- The neighbors table tracks ALL adjacent hoppers and chests regardless
-- of type. The hopper_links table tracks which chest each hopper is
-- currently linked to (if any).

function hopper.init_storage()
    storage.neighbors = storage.neighbors or {}
    storage.hopper_links = storage.hopper_links or {}
end

-----------------------------------------------------------------------
-- Neighbor graph helpers
-----------------------------------------------------------------------

--- Check if an entity is one of our tracked types
--- @param entity LuaEntity
--- @return boolean
function hopper.is_tracked_entity(entity)
    local name = entity.name
    return name == hopper.HOPPER_NAME
        or name == hopper.CHEST_NAME
end

--- Check if an entity is a chest type (for linking purposes)
--- @param entity LuaEntity
--- @return boolean
function hopper.is_chest(entity)
    return entity.name == hopper.CHEST_NAME
end

--- Get the opposite direction name
--- @param dir string Direction name (north, south, east, west)
--- @return string Opposite direction name
function hopper.get_opposite_direction(dir)
    return hopper.DIRECTIONS[dir].opposite
end

--- Search for a tracked entity at the given direction offset from entity
--- @param entity LuaEntity
--- @param direction string Direction name (north, south, east, west)
--- @param exclude_id uint64|nil Unit number to exclude from search
--- @return LuaEntity|nil
function hopper.get_neighbor_at(entity, direction, exclude_id)
    local offset = hopper.DIRECTIONS[direction]
    local surface = entity.surface
    local pos = entity.position

    local search_pos = {
        x = pos.x + offset.x,
        y = pos.y + offset.y
    }

    -- Search for any of our tracked entity types
    local found = surface.find_entities_filtered{
        position = search_pos,
        radius = 0.5,
        name = { hopper.HOPPER_NAME, hopper.CHEST_NAME },
    }

    for _, ent in ipairs(found) do
        if ent.valid and ent.unit_number ~= exclude_id then
            return ent
        end
    end

    return nil
end

--- Scan all 4 directions and return table of neighbors
--- @param entity LuaEntity
--- @param exclude_id uint64|nil Unit number to exclude from search
--- @return table {north=entity|nil, south=entity|nil, east=entity|nil, west=entity|nil}
function hopper.scan_all_neighbors(entity, exclude_id)
    local result = {}
    for dir, _ in pairs(hopper.DIRECTIONS) do
        result[dir] = hopper.get_neighbor_at(entity, dir, exclude_id)
    end
    return result
end

--- Update this entity's neighbor entry in storage
--- @param entity LuaEntity
--- @param exclude_id uint64|nil Unit number to exclude from neighbor search
function hopper.update_own_neighbors(entity, exclude_id)
    local neighbors = hopper.scan_all_neighbors(entity, exclude_id)
    local entry = {}

    for dir, neighbor in pairs(neighbors) do
        if neighbor then
            entry[dir] = neighbor.unit_number
        end
    end

    storage.neighbors[entity.unit_number] = entry
end

--- Remove this entity's entry from the neighbor storage
--- @param unit_number uint64
function hopper.clear_own_neighbors(unit_number)
    storage.neighbors[unit_number] = nil
end

--- Get the neighbor entry for a unit number
--- @param unit_number uint64
--- @return table|nil {north=unit_number|nil, ...}
function hopper.get_neighbors(unit_number)
    return storage.neighbors[unit_number]
end

-----------------------------------------------------------------------
-- Link tracking (separate from neighbor graph)
-----------------------------------------------------------------------

--- Check if a hopper is currently linked to a chest
--- @param hopper_id uint64
--- @return boolean
function hopper.is_linked(hopper_id)
    return storage.hopper_links[hopper_id] ~= nil
end

--- Record that a hopper is linked to a chest
--- @param hopper_id uint64
--- @param chest_id uint64
function hopper.record_link(hopper_id, chest_id)
    storage.hopper_links[hopper_id] = chest_id
end

--- Remove a hopper's link record
--- @param hopper_id uint64
function hopper.remove_link(hopper_id)
    storage.hopper_links[hopper_id] = nil
end

-----------------------------------------------------------------------
-- Neighbor-based entity lookup helpers
-----------------------------------------------------------------------

--- Count how many adjacent chests a hopper has (using neighbor graph)
--- @param hopper_id uint64
--- @param exclude_id uint64|nil Unit number to exclude from count
--- @return number, uint64|nil Count and single chest ID if count is 1
function hopper.count_adjacent_chests(hopper_id, exclude_id)
    local neighbors = storage.neighbors[hopper_id]
    if not neighbors then
        return 0, nil
    end

    local count = 0
    local single_chest_id = nil

    for _, neighbor_id in pairs(neighbors) do
        if neighbor_id ~= exclude_id then
            local ent = game.get_entity_by_unit_number(neighbor_id)
            if ent and ent.valid and hopper.is_chest(ent) then
                count = count + 1
                single_chest_id = neighbor_id
            end
        end
    end

    if count == 1 then
        return 1, single_chest_id
    else
        return count, nil
    end
end

--- Find exactly one adjacent chest for a hopper, or nil if zero or multiple
--- @param hopper_id uint64
--- @param exclude_id uint64|nil Unit number to exclude
--- @return LuaEntity|nil
function hopper.find_unique_adjacent_chest(hopper_id, exclude_id)
    local count, chest_id = hopper.count_adjacent_chests(hopper_id, exclude_id)
    if count == 1 and chest_id then
        local ent = game.get_entity_by_unit_number(chest_id)
        if ent and ent.valid then
            return ent
        end
    end
    return nil
end

--- Get all neighbor unit numbers as a list (for iteration)
--- @param unit_number uint64
--- @return uint64[]
function hopper.get_neighbor_ids(unit_number)
    local neighbors = storage.neighbors[unit_number]
    if not neighbors then
        return {}
    end

    local result = {}
    for _, neighbor_id in pairs(neighbors) do
        table.insert(result, neighbor_id)
    end
    return result
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
    hopper.remove_link(hopper_entity.unit_number)
end

--- Try to link a hopper to its unique adjacent chest (if any)
--- @param hopper_entity LuaEntity
--- @param exclude_id uint64|nil Chest ID to exclude from consideration
function hopper.try_link_hopper(hopper_entity, exclude_id)
    local chest = hopper.find_unique_adjacent_chest(hopper_entity.unit_number, exclude_id)
    if chest then
        hopper.link(hopper_entity, chest)
    end
end

--- Re-evaluate linking for a hopper after neighbor changes
--- @param hopper_entity LuaEntity
--- @param exclude_id uint64|nil ID to exclude (dying entity)
function hopper.reevaluate_hopper_link(hopper_entity, exclude_id)
    local currently_linked = hopper.is_linked(hopper_entity.unit_number)
    local chest = hopper.find_unique_adjacent_chest(hopper_entity.unit_number, exclude_id)

    if chest then
        -- Exactly one adjacent chest - link to it
        hopper.link(hopper_entity, chest)
    elseif currently_linked then
        -- Multiple or zero chests - unlink
        hopper.unlink(hopper_entity)
    end
end

-----------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------

--- Handle any tracked entity being placed
--- Updates neighbor graph and triggers linking logic
--- @param event EventData.on_built_entity
function hopper.on_entity_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not hopper.is_tracked_entity(entity) then return end

    -- Step 1: Populate our own neighbor entry
    hopper.update_own_neighbors(entity)

    -- Step 2: Update each neighbor's entry (they will now find us)
    -- Also re-evaluate hopper links for any affected hoppers
    local neighbor_ids = hopper.get_neighbor_ids(entity.unit_number)
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            hopper.update_own_neighbors(neighbor)

            -- If the neighbor is a hopper, re-evaluate its linking
            if neighbor.name == hopper.HOPPER_NAME then
                hopper.reevaluate_hopper_link(neighbor)
            end
        end
    end

    -- Step 3: If the placed entity is a hopper, try to link it
    if entity.name == hopper.HOPPER_NAME then
        hopper.try_link_hopper(entity)
    end
end

--- Handle any tracked entity being destroyed
--- Updates neighbor graph (excluding dying entity) and re-evaluates links
--- @param event EventData.on_entity_died|EventData.on_player_mined_entity|EventData.on_robot_mined_entity
function hopper.on_entity_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not hopper.is_tracked_entity(entity) then return end

    local dying_id = entity.unit_number

    -- Step 1: Get our current neighbors before removing our entry
    local neighbor_ids = hopper.get_neighbor_ids(dying_id)

    -- Step 2: Remove our entry from storage
    hopper.clear_own_neighbors(dying_id)

    -- Step 3: If we're a hopper, clear our link record
    if entity.name == hopper.HOPPER_NAME then
        hopper.remove_link(dying_id)
    end

    -- Step 4: Update each neighbor's entry (excluding dying entity)
    -- and re-evaluate hopper links
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            -- Update neighbor's entry, excluding the dying entity
            hopper.update_own_neighbors(neighbor, dying_id)

            -- If the neighbor is a hopper, re-evaluate its linking
            if neighbor.name == hopper.HOPPER_NAME then
                hopper.reevaluate_hopper_link(neighbor, dying_id)
            end
        end
    end
end

-----------------------------------------------------------------------
-- Design notes:
-----------------------------------------------------------------------
--
-- NEIGHBOR GRAPH ARCHITECTURE:
--
-- The neighbor graph (storage.neighbors) tracks which entities are
-- adjacent to each other in the 4 cardinal directions. This solves
-- a key problem: during entity destruction events, the dying entity
-- is still "valid" and can be found by surface.find_entities_filtered.
--
-- By maintaining our own neighbor graph:
-- - We can pass exclude_id to prevent finding dying entities
-- - Each entity only updates its OWN storage entry (no recursion risk)
-- - Neighbor updates are triggered explicitly, not implicitly
--
-- LINKING RULES:
--
-- 1. Multiple adjacent chests: Hopper remains unlinked (ambiguous target).
--    Only links when exactly one adjacent chest exists.
--
-- 2. Neighbor changes: When the neighbor graph changes for a hopper,
--    we re-evaluate whether it should be linked. If it was linked
--    but now has 0 or 2+ adjacent chests, it gets unlinked.
--
-- 3. Chest destroyed: Neighbors update their graphs, hoppers re-evaluate
--    linking (excluding the dying chest from consideration).
--
-- 4. Visual feedback: Not implemented. Could add flying text on link.
--
-- 5. Hopper prototype has 'get-by-unit-number' flag, enabling efficient
--    lookup via game.get_entity_by_unit_number().
--
-- 6. Event filters include all relevant entity names for performance.
--    script_raised_* events don't support filters.
--
-- NO RECURSION GUARANTEE:
--
-- update_own_neighbors() only modifies the calling entity's storage entry.
-- It does NOT call neighbors to update themselves. Only on_entity_built
-- and on_entity_destroyed iterate over neighbors in a flat loop, and
-- those neighbors only update their own entries.

return hopper:__seal()
