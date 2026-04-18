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

-- Maximum Manhattan distance (in world coordinates) for hopper-to-chest linking
-- A hopper can connect through 4 other hoppers to reach a chest (5 hops total)
-- Each hop is 2 tiles for 2x2 entities, so max distance is 5 * 2 = 10
-- Small buffer for floating point imprecision
hopper.MAX_LINK_DISTANCE = 10.01

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

--- Check if an entity is a hopper
--- @param entity LuaEntity
--- @return boolean
function hopper.is_hopper(entity)
    return entity.name == hopper.HOPPER_NAME
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

-----------------------------------------------------------------------
-- Link tracking (separate from neighbor graph)
-----------------------------------------------------------------------

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
-- Cluster discovery (flood fill)
-----------------------------------------------------------------------

--- Flood fill from a starting entity to discover connected cluster
--- Traverses through all connected hoppers and chests.
--- @param start_entity LuaEntity The hopper or chest to start from
--- @param exclude_id uint64|nil Unit number to exclude from traversal
--- @return LuaEntity[], LuaEntity[], uint64 Lists of hoppers, chests, and lowest unit_number
function hopper.flood_fill_cluster(start_entity, exclude_id)
    local visited = {}  -- visited[unit_number] = true (set)
    local hoppers = {}  -- list of hopper entities in cluster
    local chests = {}   -- list of chest entities in cluster
    local queue = {}    -- BFS queue of entities to process
    local min_id = start_entity.unit_number

    -- Initialize with start entity
    table.insert(queue, start_entity)
    visited[start_entity.unit_number] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)

        -- Categorize current entity
        if hopper.is_hopper(current) then
            table.insert(hoppers, current)
        elseif hopper.is_chest(current) then
            table.insert(chests, current)
        end

        -- Traverse to all neighbors
        local neighbors = storage.neighbors[current.unit_number]
        if neighbors then
            for _, neighbor_id in pairs(neighbors) do
                if not visited[neighbor_id] and neighbor_id ~= exclude_id then
                    visited[neighbor_id] = true
                    min_id = math.min(min_id, neighbor_id)

                    local neighbor = game.get_entity_by_unit_number(neighbor_id)
                    if neighbor and neighbor.valid then
                        table.insert(queue, neighbor)
                    end
                end
            end
        end
    end

    return hoppers, chests, min_id
end

--- Calculate Manhattan distance between two entities
--- @param a LuaEntity
--- @param b LuaEntity
--- @return number
function hopper.manhattan_distance(a, b)
    local pa, pb = a.position, b.position
    return math.abs(pa.x - pb.x) + math.abs(pa.y - pb.y)
end

--- Evaluate and update linking for an entire cluster
--- For each hopper, links to a chest if exactly one chest is within
--- MAX_LINK_DISTANCE, otherwise unlinks the hopper.
--- @param start_entity LuaEntity Any hopper or chest in the cluster
--- @param exclude_id uint64|nil Unit number to exclude from traversal
function hopper.link_cluster(start_entity, exclude_id)
    local hoppers, chests = hopper.flood_fill_cluster(start_entity, exclude_id)

    for _, hopper_entity in ipairs(hoppers) do
        local nearby_chest = nil
        local nearby_count = 0

        for _, chest in ipairs(chests) do
            if hopper.manhattan_distance(hopper_entity, chest) <= hopper.MAX_LINK_DISTANCE then
                nearby_count = nearby_count + 1
                nearby_chest = chest
            end
        end

        if nearby_count == 1 then
            hopper.link(hopper_entity, nearby_chest)
        else
            hopper.unlink(hopper_entity)
        end
    end
end


-----------------------------------------------------------------------
-- Link/unlink operations
-----------------------------------------------------------------------

--- Display floating text at an entity's position for all nearby players
--- @param entity LuaEntity
--- @param text string Rich text to display
local function show_floating_text(entity, text)
    local pos = entity.position
    local text_pos = {pos.x - 0.25, pos.y - 0.25}
    for _, player in pairs(game.players) do
        if player.valid and player.surface == entity.surface then
            player.create_local_flying_text{
                text = text,
                position = text_pos,
                color = {1, 1, 1},
            }
        end
    end
end

--- Link a hopper to a chest
--- @param hopper_entity LuaEntity
--- @param chest LuaEntity
function hopper.link(hopper_entity, chest)
    local was_unlinked = hopper_entity.proxy_target_entity == nil

    hopper_entity.proxy_target_entity = chest
    hopper_entity.proxy_target_inventory = defines.inventory.chest
    hopper.record_link(hopper_entity.unit_number, chest.unit_number)

    if was_unlinked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-cross]")
    end
end

--- Unlink a hopper (clear proxy target)
--- @param hopper_entity LuaEntity
function hopper.unlink(hopper_entity)
    local was_linked = hopper_entity.proxy_target_entity ~= nil

    hopper_entity.proxy_target_entity = nil
    hopper.remove_link(hopper_entity.unit_number)

    if was_linked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-diagonal-cross]")
    end
end

-----------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------

--- Handle any tracked entity being placed
--- Updates neighbor graph and re-evaluates cluster linking
--- @param event EventData.on_built_entity
function hopper.on_entity_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not hopper.is_tracked_entity(entity) then return end

    -- Step 1: Populate our own neighbor entry
    hopper.update_own_neighbors(entity)

    -- Step 2: Update each neighbor's entry (they will now find us)
    local neighbor_ids = hopper.get_neighbor_ids(entity.unit_number)
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            hopper.update_own_neighbors(neighbor)
        end
    end

    -- Step 3: Re-evaluate linking for the entire cluster
    hopper.link_cluster(entity)
end

--- Handle any tracked entity being destroyed
--- Updates neighbor graph (excluding dying entity) and re-evaluates cluster linking
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
    if hopper.is_hopper(entity) then
        hopper.remove_link(dying_id)
    end

    -- Step 4: Update each neighbor's entry (excluding dying entity)
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            hopper.update_own_neighbors(neighbor, dying_id)
        end
    end

    -- Step 5: Re-evaluate linking for each neighbor's cluster
    -- Each neighbor may now be in a separate cluster
    local evaluated = {}  -- track which clusters we've already evaluated (by min_id)
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            local _, _, min_id = hopper.flood_fill_cluster(neighbor, dying_id)
            if not evaluated[min_id] then
                evaluated[min_id] = true
                hopper.link_cluster(neighbor, dying_id)
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
-- CLUSTER-BASED LINKING:
--
-- Hoppers can connect through other hoppers to reach chests further away.
-- A "cluster" is all hoppers and chests reachable via flood fill through
-- the neighbor graph.
--
-- 1. If a cluster contains exactly one chest, all hoppers link to it.
-- 2. If a cluster contains zero or multiple chests, all hoppers unlink.
-- 3. When an entity is removed, the cluster may split into multiple
--    clusters, each evaluated independently.
--
-- The flood_fill_cluster function returns the minimum unit_number found,
-- which serves as a canonical cluster identifier for deduplication.
--
-- ENTITY FLAGS:
--
-- Both hoppers and chests have 'get-by-unit-number' flag, enabling
-- efficient lookup via game.get_entity_by_unit_number().
--
-- Event filters include all relevant entity names for performance.
-- script_raised_* events don't support filters.

return hopper:__seal()
