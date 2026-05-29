
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
                if (0 < v[2]) and (v[2] < 1) then
                    v.probability = table.remove(v)
                    v.amount = table.remove(v)
                else
                    v.amount_max = table.remove(v)
                    v.amount_min = table.remove(v)
                end
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


gadgets.icons_size = table.with_default(64, {
    ['space-location']  = 512,
    ['achievement']     = 128,
    ['technology']      = 256,
    ['shortcut']        = 32,
    ['small-shortcut']  = 24,
})

gadgets.scale_coefficient = table.with_default(1.0, {
    tiny   = 0.33,
    small  = 0.5,
    medium = 0.66,
    large  = 0.8,
    full   = 1.0, -- technically not needed
})

gadgets.direction = table.with_default(function(x) return nil end, {
    [true] = function(x) return { 0, 0 } end,
    c = function(x) return { 0, 0 } end, 
    l = function(x) return { -x, 0 } end,
    r = function(x) return { x, 0 } end,
    t = function(x) return { 0, -x } end,
    b = function(x) return { 0, x } end,
    tr = function(x) return { x, -x } end,
    tl = function(x) return { -x, -x } end,
    br = function(x) return { x, x } end,
    bl = function(x) return { -x, x } end, -- technically not needed
})

--- augmented IconData
--- dir : nil or c/l/r/t/b/tr/tl/br/br
---    direction to shift a floating icon in
--- size : nil or tiny/small/medium/large/full
---    how big the icon appears
--- type :  item, entity, recipe, etc.
---    determines icon size in pixels
--- col : hexadecimal tint color
--- offset: how far to move the icon in any given direction
function gadgets.icon(spec)
    local icon = spec[1] or spec.icon
    assert(type(icon) == 'string', "gadgets.icon: no icon file")
    if not icon:startswith('__') then
        icon = '__base__/graphics/' .. icon
    end

    local icon_type = spec.type or 'item'
    local expected_icon_size = gadgets.icons_size[icon_type]
    local icon_size = spec.icon_size or expected_icon_size

    local floating = spec.floating
    if floating == nil and spec.dir ~= nil then floating = true end

    local scale_coefficient = nil
    if spec.size then
        scale_coefficient = gadgets.scale_coefficient[spec.size]
    elseif spec.dir then
        scale_coefficient = 0.5
    end

    local scale = spec.scale
    if scale == nil and floating then
        scale = ((expected_icon_size / 2) / icon_size) * scale_coefficient
    end

    local offset = spec.offset
    if offset == nil and floating == true and scale_coefficient ~= nil then
        offset = (expected_icon_size / 2) * (1 - scale_coefficient)
    end

    local shift = spec.shift
    if shift == nil and spec.dir then
        shift = gadgets.direction[spec.dir](offset)
    end

    local tint = spec.tint
    if tint == nil and spec.col then
        tint = gadgets.hexcolor(spec.col)
    end

    return {
        icon      = icon,
        icon_size = icon_size,
        floating  = floating,
        shift     = shift,
        scale     = scale,
    }
end

function gadgets.icons(array)
    local merger = table.dup_assoc(array)
    local res = {}
    for _, v in ipairs(array) do
        if type(v) == 'string' then v = { v } end
        table.merge(v, merger)
        local icon = gadgets.icon(v)
        table.insert(res, icon)
    end
    return res
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


function gadgets.recursion_check(tbl, seen, path, root)
    tbl = tbl or data.raw.__real or data.raw
    root = root or 'data.raw'
    seen = seen or {}
    path = path or {}

    if seen[tbl] then
        error(utils.tablepath(root, path) .. ' == ' .. seen[tbl], 2)
    end

    seen[tbl] = utils.tablepath(root, path)

    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            table.insert(path, k)
            gadgets.recursion_check(v, seen, path, root)
            table.remove(path)
        end
    end

    seen[tbl] = nil
end

return gadgets:seal()