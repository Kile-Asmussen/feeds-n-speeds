require 'prelude'

local utilities = namespace 'extras.utilities'

function utilities.resource_autoplace_all_patches(tbl)

    local expr = table.concat{
        "resource_autoplace_all_patches{",
        "frequency_multiplier=var('control:", tbl.name, ":frequency'),",
        "size_multiplier=var('control:", tbl.name, ":size'),",
        "starting_patch_set_index = ", tbl.starting_patch_set_index, ",",
        "regular_patch_set_index=", tbl.regular_patch_set_index, ",",
        "base_density=", tbl.base_density or 4, ",",
        "base_spots_per_km2=", tbl.base_spots_per_km2 or 2.5, ",",
        "candidate_spot_count=", tbl.candidate_spot_count or 21, ",",
        "has_starting_area_placement=", tbl.has_starting_area_placement or 0, ",",
        "random_spot_size_minimum=", tbl.random_spot_size_minimum or 0.25, ",",
        "random_spot_size_maximum=", tbl.random_spot_size_maximum or 2, ",",
        "regular_blob_amplitude_multiplier=", tbl.regular_blob_amplitude_multiplier or 0.125, ",",
        "regular_patch_set_count=", tbl.regular_patch_set_count or "default_regular_resource_patch_set_count", ",",
        "regular_rq_factor=", tbl.regular_rq_factor or 0.11, ",",
        "seed1=", tbl.seed1 or 400, ",",
        "starting_blob_amplitude_multiplier=", tbl.starting_blob_amplitude_multiplier or 0.125, ",",
        "starting_patch_set_count=", tbl.starting_patch_set_count or "default_starting_resource_patch_set_count", ",",
        "starting_rq_factor=", tbl.starting_rq_factor or 12/70, "}",
    }
    return expr

end

function utilities.settings()
    data:extend{{
        type = 'bool-setting',
        name = fns 'restart-toggle',
        order='a',
        setting_type = 'startup',
        default_value = true,
    }}
end

utilities.icon_sizes = {
    technology = 256,
    recipe = 64,
    item = 64,
}

utilities.placements = {
    upleft = { -8, 8 },
    loleft = { -8, 8 },
    upright = { 8, -8 },
    loright = { 8, 8 },
}

function utilities.iconify(thing, other_icon, placement)
    placement = placement or 'loleft'

    thing.icons = {
        {
            icon = thing.icon,
            scale = 0.5,
            icon_size = utilities.icon_sizes[thing.type] or error("unrecognized icon-having thing: "..thing.type)
        },
        {
            icon = other_icon,
            icon_size = 64,
            floating = true,
            scale = 0.25,
            shift = table.dup(utilities.placements[placement]) or error("unknown placement " .. placement),
        }
    }
    thing.icon = nil
end

utilities.science_pack_tier = {
    ["automation-science-pack"]      = 1,
    ["logistic-science-pack"]        = 2,
    ["military-science-pack"]        = 3,
    ["chemical-science-pack"]        = 3,
    ["production-science-pack"]      = 4,
    ["utility-science-pack"]         = 4,
    ["space-science-pack"]           = 5,
    ["metallurgic-science-pack"]     = 6,
    ["electromagnetic-science-pack"] = 6,
    ["agricultural-science-pack"]    = 6,
    ["cryogenic-science-pack"]       = 7,
    ["promethium-science-pack"]      = 8,
}

local entity_to_techs = table.null

function utilities.entity_tier(name)
    if entity_to_techs ~= table.null then goto result end

    entity_to_techs = {}

    for _, tech in pairs(data.raw.technology) do
        for _, eff in ipairs(tech.effects or table.null) do
            if eff.type == 'unlock-recipe' then
                for _, res in pairs(data.raw.recipe[eff.recipe].results) do
                    if res.type == 'item' then
                        local place =data.raw.item[res.name].placeable_result
                        if data.raw.item[res.name].placeable_result then
                            entity_to_techs[place] = entity_to_techs[place] or {}
                            table.insert(entity_to_techs[place], tech.name)
                        end
                    end
                end
            end
        end
    end

    ::result::
    if not entity_to_techs[name] then return 0 end
    return table.max(table.collect(entity_to_techs[name], utilities.highest_unlock))
end

function utilities.highest_tier_pack(name)
    local technology = data.raw.technology[name]
    assert(technology, "no such technology: " .. name)
    if not technology.unit then return 0 end

    local highest = table.max(technology.unit.ingredients, function(u, v)
        return utilities.science_pack_tier[u[1]] < utilities.science_pack_tier[v[1]]
    end)
    return utilities.science_pack_tier[highest[1]]
end

local highest_unlock = {}

function utilities.highest_unlock(name)
    if not highest_unlock[name] then
        local tech = data.raw.technology[name]
        local prereqs = table.collect(tech.prerequisites, utilities.highest_unlock)
        table.insert(prereqs, utilities.highest_unlock(name))
        highest_unlock[name] = table.max(prereqs)
    end
    return highest_unlock[name]
end

function utilities.remove_unlock(name)
    assert(data.raw.recipe[name] , "no such recipe: " .. name)

    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            table.remove_matching(tech.effects, { type='unlock-recipe', name=name })
        end
    end
end

utilities.si_prefixes = {
    'k', 'M', 'G', 'T',
    k = 1000,
    M = 1000 * 1000,
    G = 1000 * 1000 * 1000,
    T = 1000 * 1000 * 1000 * 1000,
}

function utilities.to_si(energy)
    local si = utilities.si_prefixes 
    local i = 1
    for i = 1, #si do

        energy = energy / 1000

        if energy < 1000 then
            break
        end
    end
    energy = tostring(energy)
    local num = energy:match('%d+%.%d%d?%d?') or energy:match('%d+')
    return num .. si[i]
end

function utilities.to_joules(energy)
    return utilities.to_si(energy) .. 'J'
end

function utilities.to_watts(energy)
    return utilities.to_si(energy) .. 'W'
end

function utilities.joules_or_watts(energy)
    assert(type(energy) == 'string', "argument #1 must be a string")
    local unit = energy:sub(#energy)
    assert(unit == 'J' or unit == 'W', "argument #1 must end in J or W not: " .. unit)
    local si = energy:sub(#energy - 1, #energy - 1)
    assert(utilities.si_prefixes[si], "argument #1 must have an SI-prefix")
    local num = tonumber(energy:sub(1, #energy - 2)) 
    assert(type(num) == 'number', "argument #1 must have a numeric part")
    return num * utilities.si_prefixes[si]
end

return seal_namespace(utilities)