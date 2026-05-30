
local namespace = require 'namespace'
local gadgets = namespace 'gadgets'

local assert = _ENV.assert

local table = _ENV.table
local string = _ENV.string

function gadgets.remove_technologies(remove)
    if type(remove) == 'string' then
        remove = { [remove] = true }
    end

    if table.has_array(remove) then
        remove = table.set(remove)
    end

    for _, tech in pairs(data.raw.technology) do
        if not tech.prerequisites then goto continue end
        table.remove_matching(tech.prerequisites, table.lookup(remove))
        ::continue::
    end
    for name in pairs(remove) do
        data.raw.technology[name] = nil
    end
end

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
        offset = (expected_icon_size / 4) * (1 - scale_coefficient / 2)
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
        elseif
            vectors[k] and type(v) == 'table' and
            table.is_array(v) and table.iall(v, math.isvec)
        then
            table.map(v, function(v) return math.vecmul(v, factor) end)
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

function gadgets.bad_argument_number_nine(tbl)
    tbl = tbl or data.raw.__real or data.raw
    local problems = {}
    for category, entries in pairs(tbl) do
        for name, prototype in pairs(entries) do
            if prototype.type == nil or prototype.name == nil then
                local missing = prototype.type == nil and prototype.name == nil and "type and name"
                             or prototype.type == nil and "type"
                             or "name"
                table.insert(problems, "data.raw['" .. category .. "']['" .. name .. "'] missing " .. missing)
            end
        end
    end
    if #problems > 0 then
        error(table.concat(problems, "\n"), 2)
    end
end

local function is_glob(s)
    return s == '-'
end

-- use:  
-- local path, subtree = build_tree(args, data.raw)
-- print(utils.tablepath('data.raw', path) .. ' = ' .. debuglib.pp(subtree))
local function build_tree(path, node)
    if #path == 0 then
        if type(node) == 'table' then
            node = table.clone(node)
            node.__buffer_bare_keys = false
        end
        return {}, node
    end

    if is_glob(path[1]) then
        local res = { __buffer_bare_keys = true }
        local tail = { table.unpack(path, 2) }

        for key, subnode in pairs(node) do
            local subpath, subvalue = build_tree(tail, subnode)
            res[utils.tablepath(nil, table.append({ key }, subpath))] = subvalue
        end

        return {}, res
    else
        local new_path = table.clone(path)
        local key = table.remove(new_path, 1)
        if node[key] == nil then
            return { key }, nil
        end
        local subpath, subnode = build_tree(new_path, node[key])

        return table.append({ key }, subpath), subnode
    end
end

function gadgets.descend_into_data_raw(args, depth_limit)
    local debuglib = require 'debuglib'

    args = table.icollect(args, function(s) return tonumber(s) or s end)

    local early_globs = (is_glob(args[1]) and 1 or 0) + (is_glob(args[2]) and 1 or 0)

    if early_globs > 1 then
        error("at most one __all glob allowed in the first two arguments", 2)
    end

    local glob_count = early_globs
    for i = 3, #args do
        if is_glob(args[i]) then glob_count = glob_count + 1 end
    end

    if #args < 2 or glob_count > 0 then
        depth_limit = glob_count
    end

    local path, subtree = build_tree(args, data.raw)

    if subtree == nil then
        _ENV.print('Path not found: ' .. utils.tablepath('data.raw', args))
        return
    end

    local ix = utils.tablepath('data.raw', path)
    local buffer = debuglib.new_buffer{
        depth_limit = depth_limit,
        separator = '\n',
        indent = '  ',
        bare_keys = false,
        root = ix,
    }
    buffer:print_any(subtree)
    _ENV.print(ix .. ' = ' .. tostring(buffer))
end

-- gadgets.check_refs(source_cat, accessor, check_cat)
-- For every prototype in data.raw[source_cat], applies accessor(proto) to get a
-- name or array of names, then errors for any that don't exist in data.raw[check_cat].
-- check_cat may be a string or an array of strings; a ref is valid if found in any.
function gadgets.check_refs(source_cat, accessor, check_cat)
    local source = data.raw[source_cat]
    assert(source, "no prototype category: " .. tostring(source_cat))

    local check_cats = type(check_cat) == 'table' and check_cat or { check_cat }
    local checks = {}
    for _, cat in ipairs(check_cats) do
        if data.raw[cat] then checks[cat] = data.raw[cat] end
    end

    local function exists_in_any(ref)
        for _, cat in pairs(checks) do
            if cat[ref] then return true end
        end
        return false
    end

    local problems = {}
    for name, proto in pairs(source) do
        local val = accessor(proto)
        if val == nil then goto continue end

        local names = type(val) == 'table' and val or { val }
        for _, ref in ipairs(names) do
            if type(ref) == 'string' and not exists_in_any(ref) then
                table.insert(problems,
                    "data.raw['" .. source_cat .. "']['" .. name .. "']: " ..
                    "references missing " .. table.concat(check_cats, '/') .. " '" .. ref .. "'")
            end
        end
        ::continue::
    end

    if #problems > 0 then
        error(table.concat(problems, '\n'), 2)
    end
end

function gadgets.collect_from_list(test, access)
    return function(list)
        if type(list) ~= 'table' then return nil end
        local res = {}
        for _, v in ipairs(list) do
            if test(v) then
                local val = access(v)
                if val ~= nil then table.insert(res, val) end
            end
        end
        return #res > 0 and res or nil
    end
end

local fluid_names = gadgets.collect_from_list(table.match{type='fluid'}, table.access{'name'})
local item_names  = gadgets.collect_from_list(table.match{type='item'},  table.access{'name'})

local ITEM_CATS = {
    'ammo', 'armor', 'blueprint', 'blueprint-book', 'capsule',
    'deconstruction-item', 'gun', 'item', 'item-with-entity-data',
    'item-with-inventory', 'module', 'rail-planner', 'repair-tool',
    'selection-tool', 'space-platform-starter-pack', 'tool', 'upgrade-item',
}

function gadgets.master_check()
    gadgets.recursion_check()
    gadgets.bad_argument_number_nine()
    gadgets.check_refs('recipe', table.access{'category'}, 'recipe-category')
    gadgets.check_refs('recipe', function(p) return fluid_names(p.ingredients) end, 'fluid')
    gadgets.check_refs('recipe', function(p) return fluid_names(p.results) end, 'fluid')
    gadgets.check_refs('recipe', function(p) return item_names(p.ingredients) end, ITEM_CATS)
    gadgets.check_refs('recipe', function(p) return item_names(p.results) end, ITEM_CATS)
    gadgets.check_refs('technology', table.access{'prerequisites'}, 'technology')
end

gadgets.on_init_handlers = {}

function gadgets.on_init(handler)
    table.insert(gadgets.on_init_handlers, handler)
end

function gadgets.on_init_hook()
    for _, f in ipairs(gadgets.on_init_handlers) do
        f()
    end
end

return gadgets:seal()