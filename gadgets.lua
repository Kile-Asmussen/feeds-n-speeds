
local fns = require 'fns'
local namespace = require 'namespace'
local gadgets = namespace 'gadgets'

local assert = fns.assert

local table = fns.table
local string = fns.string

function gadgets.remove_unlocks(remove)
    if table.has_array(remove) then
        remove = table.set(remove)
    end
    for _, tech in pairs(data.raw.technology) do
        if not tech.effects then goto continue end
        for i = #tech.effects, 1, -1 do
            if
                tech.effects[i].type == 'unlock-recipe' and
                remove[tech.effects[i].recipe]
            then
                table.remove(tech.effects, i)
            end
        end
        ::continue::
    end
end

function gadgets.throughputs(throughputs)
    local ingredients = {}

    for k, v in table.opairs(throughputs) do
        local t

        if data.raw.fluid[k] then
            t = 'fluid'
        else
            t = 'item'
        end

        if type(v) == 'number' then
            v = { type=t, amount=v, name=k }
        else
            v = table.clone(v)
            v.type = t
            v.name = k
            if #v == 1 then
                v.amount = table.remove(v)
            elseif #v == 2 then
                v.amount_max = table.remove(v)
                v.amount_min = table.remove(v)
            end
        end
        
        table.insert(ingredients, v)
    end
    return ingredients
end

function gadgets.resource_autoplace_all_patches(tbl)

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

gadgets.icon_sizes = {
    technology = 256,
    recipe = 64,
    item = 64,
}

gadgets.icon_scales = {
    tiny = 0.25,
    small = 0.33,
    medium = 0.5,
    big = 0.7,
    huge = 1.0,
}

gadgets.icons_shifts = {
    tiny = 8,
    small = 6,
    medium = 5,
    big = 3,
    huge = 0,
}

gadgets.icon_placements = {
    upleft = { -1, 1 },
    loleft = { -1, 1 },
    upright = { 1, -1 },
    loright = { 1, 1 },
    center = { 0, 0 }
}

function gadgets.color(col)
    assert(type(col) == 'table' or type(col) == 'string', "colors must be strings or tables")
    if type(col) == 'string' then return gadgets.hexcolor(col) end
    assert(#col == 3 or #col == 4, "colors must have 3 or 4 components")
    assert(table.iall(col, functions.as('number')), "colors must have 3 or 4 components")
end

function gadgets.hexcolor(hex)
    assert(type(hex) == 'string', "argument #1 must be a string")
    local color = string.match(hex, '%X%X%X%X%X%X%X%X)') or string.match(hex, '%X%X%X%X%X%X')
    assert(color, "invalid color format, must be 6 or 8 uppercase hex digits")
    local res = {}
    for i = 1,#color,2 do
        table.insert(res, tonumber(string.sub(color, i, i+1), 16) / 255)
    end
    return res
end


gadgets.science_pack_tier = {
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

function gadgets.entity_tier(name)
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
    return table.max(table.collect(entity_to_techs[name], gadgets.highest_unlock))
end

function gadgets.highest_tier_pack(name)
    local technology = data.raw.technology[name]
    assert(technology, "no such technology: " .. name)
    if not technology.unit then return 0 end

    local highest = table.max(technology.unit.ingredients, function(u, v)
        return gadgets.science_pack_tier[u[1]] < gadgets.science_pack_tier[v[1]]
    end)
    return gadgets.science_pack_tier[highest[1]]
end

local highest_unlock = {}

function gadgets.highest_unlock(name)
    if not highest_unlock[name] then
        local tech = data.raw.technology[name]
        local prereqs = table.collect(tech.prerequisites, gadgets.highest_unlock)
        table.insert(prereqs, gadgets.highest_unlock(name))
        highest_unlock[name] = table.max(prereqs)
    end
    return highest_unlock[name]
end

gadgets.si_prefixes = {
    'k', 'M', 'G', 'T',
    k = 1000,
    M = 1000 * 1000,
    G = 1000 * 1000 * 1000,
    T = 1000 * 1000 * 1000 * 1000,
}

function gadgets.to_si(energy)
    local si = ''

    for i = 1, #gadgets.si_prefixes do

        energy = energy / 1000

        if energy < 1000 then
            si = gadgets.si_prefixes[i]
            break
        end
    end
    energy = tostring(energy)
    local num = energy:match('%d+%.%d%d?%d?') or energy:match('%d+')
    return num .. si
end

function gadgets.to_joules(energy)
    return gadgets.to_si(energy) .. 'J'
end

function gadgets.to_watts(energy)
    return gadgets.to_si(energy) .. 'W'
end

function gadgets.joules_or_watts(energy)
    assert(type(energy) == 'string', "argument #1 must be a string")
    local unit = energy:sub(#energy)
    assert(unit == 'J' or unit == 'W', "argument #1 must end in J or W not: " .. unit)
    local si = energy:sub(#energy - 1, #energy - 1)
    assert(gadgets.si_prefixes[si], "argument #1 must have an SI-prefix")
    local num = tonumber(energy:sub(1, #energy - 2)) 
    assert(type(num) == 'number', "argument #1 must have a numeric part")
    return num * gadgets.si_prefixes[si]
end

function gadgets.main_product(recipe)
    if type(recipe) == 'string' then
        assert(data.raw.recipe[recipe], "no such recipe: " .. recipe)
        recipe = data.raw.recipe[recipe]
    end

    assert(type(recipe) == 'table' and recipe.type == 'recipe', "not a recipe: " .. tostring(table.name))

    if recipe.main_product then return recipe.main_product end
    if #recipe.results == 1 then return recipe.results[1].name end
    error("recipe " .. recipe .. ' has no main product', 2)
end


function gadgets.scale_vectors_and_numbers(factor, fields, vectors, stop_at)
    assert(type(factor) == 'number', "argument #1 must be a number")
    assert(type(fields) == 'table', "argument #2 must be a table")
    assert(type(vectors) == 'table', "argument #3 must be a table")
    assert(type(stop_at) == 'table', "argument #4 must be a table")

    return function(v, k)
        if type(v) == 'table' then
            if stop_at[k] then
                return true
            end
        else
            if stop_at[k] then
                return nil, false
            end
        end

        if vectors[k] and math.isvec(v) then
            math.vecmul(v, factor)
            return true
        elseif fields[k] and type(v) == 'number' then
            return v * factor, true
        end
    end
end

function gadgets.shift_vectors(offset, fields, stop_at)
    assert(type(offset) == 'table', "argument #1 must be a number")
    assert(type(offset) == 'table', "argument #2 must be a table")
    assert(type(stop_at) == 'table', "argument #3 must be a table")

    return function(v, k)
        if type(v) == 'table' then
            if stop_at[k] then
                return true
            end
        end

        if fields[k] and math.isvec(v) then
            math.vecadd(v, offset)
            return true
        end
    end
end

return gadgets:seal()