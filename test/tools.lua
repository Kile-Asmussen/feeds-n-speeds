
local fns = require 'fns'
local debuglib = require 'debuglib'
local utils = fns.utils
local table = fns.table
local tools = require('namespace')('test.tools')

function tools.recursion_check(tbl, seen, path, root)
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
            tools.recursion_check(v, seen, path, root)
            table.remove(path)
        end
    end

    seen[tbl] = nil
end

local function bad_arg_9(problems, expected_type, val, path)
    if type(val) ~= expected_type then
        table.insert(problems, utils.tablepath('data.raw', path) .. " :: "
            .. type(val) .. "(expected " .. expected_type .. ")")
        return true
    else
        return false
    end
end

function tools.bad_argument_number_nine(tbl)
    tbl = tbl or data.raw.__real or data.raw
    local problems = {}
    for category, entries in pairs(tbl) do
        if bad_arg_9(problems, 'table', entries, { category }) then goto continue end
        
        for name, prototype in pairs(entries) do
            if bad_arg_9(problems, 'table', prototype, { category, name }) then goto continue end

            if
                not bad_arg_9(problems, 'string', prototype.name, { category, name, 'name'})
                and prototype.name ~= name
            then
                table.insert(problems, utils.tablepath('data.raw', {category, name, 'name'}) .. string.format(" ~= %q (was %q)", name, prototype.name))
            end

            if
                not bad_arg_9(problems, 'string', prototype.type, { category, name, 'type'})
                and prototype.type ~= category
            then
                table.insert(problems, utils.tablepath('data.raw', {category, name, 'type'}) .. string.format(" ~= %q (was %q)", category, prototype.type))
            end
        end

        ::continue::
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
            node = table.deepcopy(node)
            node.__buffer_bare_keys = false
        end
        return {}, node
    end

    if type(node) ~= 'table' then
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
        local new_path = table.deepcopy(path)
        local key = table.remove(new_path, 1)
        if node[key] == nil then
            return { key }, nil
        end
        local subpath, subnode = build_tree(new_path, node[key])

        return table.append({ key }, subpath), subnode
    end
end

function tools.descend_into_data_raw(args, depth_limit)
    local debuglib = require 'debuglib'

    args = table.icollect(args, function(s) return tonumber(s) or s end)

    
    if is_glob(args[1]) and is_glob(args[2]) then
        error("at most one '-' glob allowed in the first two arguments", 2)
    end

    local glob_count = 0
    local last_glob = 0
    for i = 1, #args do
        if is_glob(args[i]) then
            glob_count = glob_count + 1
            last_glob = i
        end
    end

    if #args <= 1 then
        depth_limit = 1
    elseif glob_count >= 1 then
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

-- tools.check_refs(source_cat, accessor, check_cat)
-- For every prototype in data.raw[source_cat], applies accessor(proto) to get a
-- name or array of names, then errors for any that don't exist in data.raw[check_cat].
-- check_cat may be a string or an array of strings; a ref is valid if found in any.
function tools.check_refs(source_cat, accessor, check_cat)
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

function tools.collect_from_list(test, access)
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

local fluid_names = tools.collect_from_list(table.match{type='fluid'}, table.access{'name'})
local item_names  = tools.collect_from_list(table.match{type='item'},  table.access{'name'})

local ITEM_CATS = {
    'ammo', 'armor', 'blueprint', 'blueprint-book', 'capsule',
    'deconstruction-item', 'gun', 'item', 'item-with-entity-data',
    'item-with-inventory', 'module', 'rail-planner', 'repair-tool',
    'selection-tool', 'space-platform-starter-pack', 'tool', 'upgrade-item',
}

function tools.master_check()
    tools.recursion_check()
    tools.bad_argument_number_nine()
    tools.check_refs('recipe', table.access{'category'}, 'recipe-category')
    tools.check_refs('recipe', function(p) return fluid_names(p.ingredients) end, 'fluid')
    tools.check_refs('recipe', function(p) return fluid_names(p.results) end, 'fluid')
    tools.check_refs('recipe', function(p) return item_names(p.ingredients) end, ITEM_CATS)
    tools.check_refs('recipe', function(p) return item_names(p.results) end, ITEM_CATS)
    tools.check_refs('technology', table.access{'prerequisites'}, 'technology')
end

local function parse(needle)
    if type(needle) ~= 'string' then error("expected all arguments to be strings", 3) end
    if needle == '-' then return utils.null else return string.pattern(needle, 1, true) end
end

function tools.text_search_data_raw(...)
    assert(select('#', ...) == 3, "exactly 3 arguments expected")
    local cat, prot, field = ...
    cat = parse(cat)
    prot = parse(prot)
    field = parse(field)

    local categories = {}
    local prototypes = {}
    local fields = {}
    for cat_name, category in pairs(data.raw) do
        if cat(cat_name) then
            table.insert(categories,
                utils.tablepath('data.raw', {cat_name}))
        end
        for proto_name, prototype in pairs(category) do
            if prot(proto_name) then
                table.insert(prototypes,
                    utils.tablepath('data.raw', {cat_name, proto_name}))
            end
            if type(prototype) == 'table' then
                for field_name, _ in pairs(prototype) do
                    if field(field_name) then
                        table.insert(fields,
                            utils.tablepath('data.raw', { cat_name, proto_name, field_name }))
                    end
                end
            end
        end
    end
    return categories, prototypes, fields
end


return tools:seal()