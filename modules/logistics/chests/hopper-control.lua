-- control: mechanics for the hopper entity
local fns = require 'fns'

local fns_hopper = fns 'hopper'
local fns_chest = 'steel-chest'

local normal_link_distance = 10.01
local quality_distance_increase = 2.0

local cardinal_directions = {
    north = { x =  0, y = -2, opposite = 'south' },
    south = { x =  0, y =  2, opposite = 'north' },
    west  = { x = -2, y =  0, opposite = 'east'  },
    east  = { x =  2, y =  0, opposite = 'west'  },
}

local entity_filter = {
    { filter = "name", name = fns_hopper },
    { filter = "name", name = fns_chest },
}

local function init_storage()
    storage.neighbors = storage.neighbors or {}
    storage.hopper_links = storage.hopper_links or {}
end

local function on_load()
    -- nothing so far
end

local function is_tracked_entity(entity)
    local name = entity.name
    return name == fns_hopper
        or name == fns_chest
end

local function is_chest(entity)
    return entity.name == fns_chest
end

local function is_hopper(entity)
    return entity.name == fns_hopper
end

local function get_neighbor_at(entity, direction, exclude_id)
    local offset = cardinal_directions[direction]
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

local function scan_all_neighbors(entity, exclude_id)
    local result = {}
    for dir, _ in pairs(cardinal_directions) do
        result[dir] = get_neighbor_at(entity, dir, exclude_id)
    end
    return result
end

local function update_own_neighbors(entity, exclude_id)
    local neighbors = scan_all_neighbors(entity, exclude_id)
    local entry = {}

    for dir, neighbor in pairs(neighbors) do
        if neighbor then
            entry[dir] = neighbor.unit_number
        end
    end

    storage.neighbors[entity.unit_number] = entry
end

local function clear_own_neighbors(unit_number)
    storage.neighbors[unit_number] = nil
end


local function record_link(hopper_id, chest_id)
    storage.hopper_links[hopper_id] = chest_id
end

local function remove_link(hopper_id)
    storage.hopper_links[hopper_id] = nil
end

local function get_neighbor_ids(unit_number)
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


local function flood_fill_cluster(start_entity, exclude_id)
    local visited = {}
    local hoppers = {}
    local chests = {}
    local queue = {}
    local min_id = start_entity.unit_number
    local min_quality = start_entity.quality.level

    table.insert(queue, start_entity)
    visited[start_entity.unit_number] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)
        min_quality = math.min(min_quality, current.quality.level)


        if current.name == fns_hopper then
            table.insert(hoppers, current)
        elseif current.name == fns_chest then
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

    return hoppers, chests, min_id, min_quality
end

local function manhattan_distance(a, b)
    local pa, pb = a.position, b.position
    return math.abs(pa.x - pb.x) + math.abs(pa.y - pb.y)
end

local link, unlink

local function link_cluster(start_entity, exclude_id)
    local hoppers, chests, min_id, min_quality = flood_fill_cluster(start_entity, exclude_id)

    local max_dist = min_quality * quality_distance_increase + normal_link_distance

    for _, hopper_entity in ipairs(hoppers) do
        local nearby_chest = nil
        local nearby_count = 0

        for _, chest in ipairs(chests) do
            if manhattan_distance(hopper_entity, chest) <= max_dist then
                nearby_count = nearby_count + 1
                nearby_chest = chest
            end
        end

        if nearby_count == 1 then
            link(hopper_entity, nearby_chest)
        else
            unlink(hopper_entity)
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

link = function(hopper_entity, chest)
    local was_unlinked = hopper_entity.proxy_target_entity == nil

    hopper_entity.proxy_target_entity = chest
    hopper_entity.proxy_target_inventory = defines.inventory.chest
    record_link(hopper_entity.unit_number, chest.unit_number)

    if was_unlinked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-cross]")
    end
end

unlink = function(hopper_entity)
    local was_linked = hopper_entity.proxy_target_entity ~= nil

    hopper_entity.proxy_target_entity = nil
    remove_link(hopper_entity.unit_number)

    if was_linked then
        show_floating_text(hopper_entity, "[virtual-signal=shape-diagonal-cross]")
    end
end


local function on_entity_built(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    update_own_neighbors(entity)

    local neighbor_ids = get_neighbor_ids(entity.unit_number)

    for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            update_own_neighbors(neighbor)
        end
    end

    link_cluster(entity)
end

local function on_entity_destroyed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end
    if not is_tracked_entity(entity) then return end

    local dying_id = entity.unit_number

        local neighbor_ids = get_neighbor_ids(dying_id)

        clear_own_neighbors(dying_id)

        if is_hopper(entity) then
        remove_link(dying_id)
    end

        for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            update_own_neighbors(neighbor, dying_id)
        end
    end

            local evaluated = {}      for _, neighbor_id in ipairs(neighbor_ids) do
        local neighbor = game.get_entity_by_unit_number(neighbor_id)
        if neighbor and neighbor.valid then
            local _, _, min_id = flood_fill_cluster(neighbor, dying_id)
            if not evaluated[min_id] then
                evaluated[min_id] = true
                link_cluster(neighbor, dying_id)
            end
        end
    end
end

fns.gadgets.on_init(init_storage)

script.on_load(on_load)

script.on_configuration_changed(init_storage)

script.on_event(defines.events.on_built_entity, on_entity_built, entity_filter)
script.on_event(defines.events.on_robot_built_entity, on_entity_built, entity_filter)
script.on_event(defines.events.script_raised_built, on_entity_built, entity_filter)
script.on_event(defines.events.script_raised_revive, on_entity_built, entity_filter)

script.on_event(defines.events.on_entity_died, on_entity_destroyed, entity_filter)
script.on_event(defines.events.on_player_mined_entity, on_entity_destroyed, entity_filter)
script.on_event(defines.events.on_robot_mined_entity, on_entity_destroyed, entity_filter)
script.on_event(defines.events.script_raised_destroy, on_entity_destroyed, entity_filter)
