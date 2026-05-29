
local table = _ENV.table
local assert = _ENV.assert

local map_map = {
    key = function(k) return tostring(k) end,
    val = function(_, v) return tostring(v) end
}

function table.concat_iter(iter, base, key, join, map)
    map = map_map[map] or map or map_map['val']
    assert(type(map) == 'function', 'argument #5 (3) must be a function or "key" or "val"')

    join = join or ''
    assert(type(join) == 'string', 'argument #4 (2) must be a string')

    local res = {}
    for k, v in iter, base, key do
        table.insert(res, map(k, v))
    end
    table.concat(res, join)
end

local valid_types_map = {
    any = {
        number=true,
        boolean=true,
        string=true, 
        ['function']=true,
        table=true
    },
}
valid_types_map['any?'] = {}
for k,_ in pairs(valid_types_map.any) do
    valid_types_map[k] = { [k] = true }
    valid_types_map[k .. '?'] = { [k] = true, ['nil'] = true }
    valid_types_map['any?'][k] = true
end
valid_types_map['any?']['nil'] = true

local function __valid_types_set(pattern)
    if type(pattern) == 'table' then
        return pattern
    elseif valid_types_map[pattern] then
        return valid_types_map[pattern]
    end
end

--- complicated 2nd/3rd order helper function that creates utility functions with typechecking
--- let func be a two-place function, i.e. func = function(a, b) ... end
--- then twoarg(func) is a function that accepts 1-2 arguments and returns a function obeying:
--- * twoarg(func)(b)(a, ...) => func(a, b, ...)
--- * twoarg(func)(a, b, ...) => func(a, b, ...)
--- (the function are not necessarily limited to two arguments, to account for
--- nominally two arg functions that might take optional extra arguments)
---
--- the optional 1-2 arguments to twoarg are type-checking patterns:
--- * twoargs(func) assumes a and be to be tables
--- * twoarg(func, pattern_b) will only check the second argument b to func and assume a to be a table
--- * twoarg(func, pattern_a, pattern_b) will check both arguments to func
---
--- the type patterns can be:
--- * a set (table mapping strings to booleans): only type names in the set allowed
--- * name of a type: equivalent to a set of only that type name
--- * name of a type + '?': equivalent to a set of only that type name and 'nil' (type(nil) == 'nil')
--- * 'any': all types (excepting userdata, corountine and other exotic types)
--- * 'any?': all types and nil
function table.twoarg(func, ...)
    assert(type(func) == 'function', "argument #1 must be a function")
    
    local n = select('#', ...)

    local types_1, types_2 = valid_types_map.table, valid_types_map.table

    if n == 1 then
        types_2 = ...
        types_2 = __valid_types_set(types_2) or error("argument #2 must be a table or string", 2)
    elseif n == 2 then
        types_1, types_2 = ...
        types_1 = __valid_types_set(types_1) or error("argument #2 must be a table or string", 2)
        types_2 = __valid_types_set(types_2) or error("argument #3 must be a table or string", 2)
    elseif n ~= 0 then
        error("too many arguments, expected 1 to 3", 2)
    end

    return function(...)
        local n = select('#', ...)
        if n == 1 then
            local arg2 = ...
            assert(types_2[type(arg2)], "argument #1 is of wrong type")
            return function(arg1, ...)
                assert(types_1[type(arg1)], "argument #1 is of wrong type")
                return func(arg1, arg2, ...)
            end
        elseif n >= 2 then
            local arg1, arg2 = ...
            assert(types_1[type(arg1)], "argument #1 is of wrong type")
            assert(types_2[type(arg2)], "argument #2 is of wrong type")
            return func(...) -- call with everything
        else
            error("wrong number of arguments, expected at least 1")
        end
    end
end

table.size = _ENV.table_size or function(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local n = 0
    -- account for metatable overrides
    for _ in pairs(tbl) do
        n = n + 1
    end
    return n
end

function table.is_empty(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.size(tbl) == 0
end

function table.with_default(value, res)
    res = res or {}
    setmetatable(res, { __index = function() return value end })
    return res
end