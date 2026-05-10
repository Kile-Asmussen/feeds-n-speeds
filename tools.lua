require 'prelude'

local tools = namespace 'tools'

function tools.resource_autoplace_all_patches(tbl)

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

function tools.restart_toggle()
    data:extend{{
        type = 'bool-setting',
        name = fns 'restart-toggle',
        order='a',
        setting_type = 'startup',
        default_value = true,
    }}
end

tools.icon_sizes = {
    technology = 256,
    recipe = 64,
    item = 64,
}

tools.icon_scales = {
    tiny = 0.25,
    small = 0.33,
    medium = 0.5,
    big = 0.7,
    huge = 1.0,
}

tools.icons_shifts = {
    tiny = 8,
    small = 6,
    medium = 5,
    big = 3,
    huge = 0,
}

tools.icon_placements = {
    upleft = { -1, 1 },
    loleft = { -1, 1 },
    upright = { 1, -1 },
    loright = { 1, 1 },
    center = { 0, 0 }
}

function tools.color(col)
    assert(type(col) == 'table' or type(col) == 'string', "colors must be strings or tables")
    if type(col) == 'string' then return tools.hexcolor(col) end
    assert(#col == 3 or #col == 4, "colors must have 3 or 4 components")
    assert(table.all(col, functions.as('number')), "colors must have 3 or 4 components")
end

function tools.hexcolor(hex)
    assert(type(hex) == 'string', "argument #1 must be a string")
    local color = hex:match('#(%X%X%X%X%X%X%X%X)') or hex:match('#(%X%X%X%X%X%X)')
    assert(color, "invalid color format, must be 6 or 8 hex digits")
    local res = array{}
    for i = 1,#color,2 do
        table.insert(res, tonumber(color:sub(i, i+1), 16) / 255)
    end
    return res
end

function tools.icons(icon, icon2)
    icon = assoc(icon)
    icon2 = assoc(icon)

    if not icon.shift then
        icon.shift = tools.icon_placements[icon.placement]
        if icon.shift then
            table.vecmul(icon.shift, tools.icons_shifts[icon.placement])
        end
    end

    if not icon2.shift then
        icon2.shift = tools.icon_placements[icon2.placement]
        if icon2.shift then
            table.vecmul(icon2.shift, tools.icons_shifts[icon2.placement])
        end
    end

    icon.placement = nil
    icon2.placement = nil

    icon.type = icon.type or 'item'
    icon2.type = icon2.type or 'item'

    icon.icon = icon.icon or data.raw[icon.type][icon.name].icon
    icon2.icon = icon2.icon or data.raw[icon2.type][icon2.name].icon

    icon.name = nil
    icon2.name = nil

    icon.icon_size = tools.icon_sizes[icon.type]
    icon2.icon_size = tools.icon_sizes[icon2.type]

    icon.tint = icon.tint and tools.color(icon.tint)
    icon2.tint = icon2.tint and tools.color(icon2.tint)

    icon.scale = tools.icon_scales[icon.scale] or icon.scale
    icon2.scale = tools.icon_scales[icon2.scale] or icon2.scale

    icon.float = true
    icon2.float = true

    return array{
        icon,
        icon2
    }
end

tools.science_pack_tier = {
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

function tools.entity_tier(name)
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
    return table.max(table.collect(entity_to_techs[name], tools.highest_unlock))
end

function tools.highest_tier_pack(name)
    local technology = data.raw.technology[name]
    assert(technology, "no such technology: " .. name)
    if not technology.unit then return 0 end

    local highest = table.max(technology.unit.ingredients, function(u, v)
        return tools.science_pack_tier[u[1]] < tools.science_pack_tier[v[1]]
    end)
    return tools.science_pack_tier[highest[1]]
end

local highest_unlock = {}

function tools.highest_unlock(name)
    if not highest_unlock[name] then
        local tech = data.raw.technology[name]
        local prereqs = table.collect(tech.prerequisites, tools.highest_unlock)
        table.insert(prereqs, tools.highest_unlock(name))
        highest_unlock[name] = table.max(prereqs)
    end
    return highest_unlock[name]
end

function tools.remove_unlock(name)
    assert(data.raw.recipe[name] , "no such recipe: " .. name)

    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            table.remove_matching(tech.effects, { type='unlock-recipe', recipe=name })
        end
    end
end

tools.si_prefixes = {
    'k', 'M', 'G', 'T',
    k = 1000,
    M = 1000 * 1000,
    G = 1000 * 1000 * 1000,
    T = 1000 * 1000 * 1000 * 1000,
}

function tools.to_si(energy)
    local si = ''

    for i = 1, #tools.si_prefixes do

        energy = energy / 1000

        if energy < 1000 then
            si = tools.si_prefixes[i]
            break
        end
    end
    energy = tostring(energy)
    local num = energy:match('%d+%.%d%d?%d?') or energy:match('%d+')
    return num .. si
end

function tools.to_joules(energy)
    return tools.to_si(energy) .. 'J'
end

function tools.to_watts(energy)
    return tools.to_si(energy) .. 'W'
end

function tools.joules_or_watts(energy)
    assert(type(energy) == 'string', "argument #1 must be a string")
    local unit = energy:sub(#energy)
    assert(unit == 'J' or unit == 'W', "argument #1 must end in J or W not: " .. unit)
    local si = energy:sub(#energy - 1, #energy - 1)
    assert(tools.si_prefixes[si], "argument #1 must have an SI-prefix")
    local num = tonumber(energy:sub(1, #energy - 2)) 
    assert(type(num) == 'number', "argument #1 must have a numeric part")
    return num * tools.si_prefixes[si]
end

return seal_namespace(tools)