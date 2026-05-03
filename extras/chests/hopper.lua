
require 'prelude'

local hopper = namespace 'extras.chests.hopper'

local fns_hopper = fns 'big-steel-hopper'
local fns_chest = fns 'big-steel-chest'

hopper.max_link_distance = 10.01

hopper.cardinal_directions = {
    north = { x =  0, y = -2, opposite = 'south' },
    south = { x =  0, y =  2, opposite = 'north' },
    west  = { x = -2, y =  0, opposite = 'east'  },
    east  = { x =  2, y =  0, opposite = 'west'  },
}

hopper.entity_filter = {
    { filter = "name", name = fns_hopper },
    { filter = "name", name = fns_chest },
}

function hopper.init_storage()
    storage.neighbors = storage.neighbors or {}
    storage.hopper_links = storage.hopper_links or {}
end

function hopper.on_load()
    -- nothing so far
end

function hopper.is_tracked_entity(entity)
    local name = entity.name
    return name == fns_hopper
        or name == fns_chest
end

function hopper.is_chest(entity)
    return entity.name == fns_chest
end

function hopper.is_hopper(entity)
    return entity.name == fns_hopper
end

function hopper.get_neighbor_at(entity, direction, exclude_id)
    local offset = hopper.cardinal_directions[direction]
    local surface = entity.surface
    local pos = entity.position

    local search_pos = {
        x = pos.x + offset.x,
        y = pos.y + offset.y
    }

        local found = surface.find_entities_filtered{
        position = search_pos,
        radius = 0.5,
        name = { fns_hopper, fns_chest },
    }

    for _, ent in ipairs(found) do
        if ent.valid and ent.unit_number ~= exclude_id then
            return ent
        end
    end

    return nil
end

function hopper.scan_all_neighbors(entity, exclude_id)
    local result = {}
    for dir, _ in pairs(hopper.cardinal_directions) do
        result[dir] = hopper.get_neighbor_at(entity, dir, exclude_id)
    end
    return result
end

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

function hopper.clear_own_neighbors(unit_number)
    storage.neighbors[unit_number] = nil
end


function hopper.record_link(hopper_id, chest_id)
    storage.hopper_links[hopper_id] = chest_id
end

function hopper.remove_link(hopper_id)
    storage.hopper_links[hopper_id] = nil
end

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


function hopper.flood_fill_cluster(start_entity, exclude_id)
    local visited = {}
    local hoppers = {}
    local chests = {}
    local queue = {}
    local min_id = start_entity.unit_number

    table.insert(queue, start_entity)
    visited[start_entity.unit_number] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)

        if hopper.is_hopper(current) then
            table.insert(hoppers, current)
        elseif hopper.is_chest(current) then
            table.insert(chests, current)
        end

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

function hopper.manhattan_distance(a, b)
    local pa, pb = a.position, b.position
    return math.abs(pa.x - pb.x) + math.abs(pa.y - pb.y)
end

function hopper.link_cluster(start_entity, exclude_id)
    local hoppers, chests = hopper.flood_fill_cluster(start_entity, exclude_id)

    for _, hopper_entity in ipairs(hoppers) do
        local nearby_chest = nil
        local nearby_count = 0

        for _, chest in ipairs(chests) do
            if hopper.manhattan_distance(hopper_entity, chest) <= hopper.max_link_distance then
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

function hopper.link(hopper_entity, chest)
    local was_unlinked = hopper_entity.proxy_target_entity == nil

    hopper_entity.proxy_target_entity = chest
    hopper_entity.proxy_target_inventory = defines.inventory.chest
    hopper.record_link(hopper_entity.unit_number, chest.unit_number)

    if was_unlinked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-cross]")
    end
end

function hopper.unlink(hopper_entity)
    local was_linked = hopper_entity.proxy_target_entity ~= nil

    hopper_entity.proxy_target_entity = nil
    hopper.remove_link(hopper_entity.unit_number)

    if was_linked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-diagonal-cross]")
    end
end


function hopper.on_entity_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not hopper.is_tracked_entity(entity) then return end

        hopper.update_own_neighbors(entity)

        local neighbor_ids = hopper.get_neighbor_ids(entity.unit_number)
    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            hopper.update_own_neighbors(neighbor)
        end
    end

        hopper.link_cluster(entity)
end

function hopper.on_entity_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not hopper.is_tracked_entity(entity) then return end

    local dying_id = entity.unit_number

        local neighbor_ids = hopper.get_neighbor_ids(dying_id)

        hopper.clear_own_neighbors(dying_id)

        if hopper.is_hopper(entity) then
        hopper.remove_link(dying_id)
    end

        for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            hopper.update_own_neighbors(neighbor, dying_id)
        end
    end

            local evaluated = {}      for _, neighbor_id in ipairs(neighbor_ids) do
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


return seal_namespace(hopper)
