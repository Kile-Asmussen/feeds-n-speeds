
local table = _ENV.table
local assert = _ENV.assert

local function __overwrite(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end

    return tbl1
end

local function __replace(tbl1, tbl2)
    for k, _ in pairs(tbl1) do
        if tbl2[k] ~= nil then
            tbl1[k] = tbl2[k]
        end
    end

    return tbl1
end

local function __include(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        if tbl1[k] == nil then
            tbl1[k] = v
        end
    end

    return tbl1
end

local function __transmute(tbl1, tbl2)
    for k, _ in pairs(tbl1) do
        local func = tbl2[k]
        if func then
            tbl1[k] = func(tbl1)
        end
    end
end

local function __append(tbl1, tbl2)
    for i = 1, #tbl2 do
        table.insert(tbl1, tbl2[i])
    end
    return tbl1
end

local function __keep(tbl1, tbl2)
    for k, v in pairs(tbl1) do
        tbl1[k] = tbl2[k] and v or nil
    end
end

table.keep = table.twoarg(__keep)
table.overwrite = table.twoarg(__overwrite)
table.replace = table.twoarg(__replace)
table.include = table.twoarg(__include)
table.transmute = table.twoarg(__transmute)
table.append = table.twoarg(__append)

function table.cut(tbl, n)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(n) == 'number', "argument #2 must be a number")
    while #tbl > n do
        table.remove(tbl)
    end
end

function table.flatten_keys(tbl, recurse)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local res = {}
    for k, v in pairs(tbl) do
        if recurse and type(v) == 'table' then
            v = table.flatten_keys(v, true)
        end
        if type(k) == 'table' then
            for i = 1,#k do res[k[i]] = v end
        else
            res[k] = v
        end
    end
    return res
end

-- more performant as a function, since it precomputes
-- the transformation otherwise done by merge, below
local function __merge_function(tbl2)
    assert(type(tbl2) == 'table', "argument #1 must be a table")
    tbl2 = table.flatten_keys(tbl2)
    table.traverse(tbl2, function(v)
        if type(v) == 'table' then
            return __merge_function(v), true
        end
    end)
    return function(tbl1)
        assert(type(tbl1) == 'table', "argument #1 must be a table")
        return __merge(tbl1, tbl2)
    end
end
table.merge_function = __merge_function

local function __merge(tbl1, tbl2)
    tbl2 = table.flatten_keys(tbl, recurse)
    for k, v in pairs(tbl2) do
        local t = type(v) 
        if t ~= 'function' and t ~= 'table' then
            tbl1[k] = v
        end
    end
    for k, f in pairs(spec) do
        local t = type(f) 
        if t == 'function' then
            tbl1[k] = f(tbl1[k])
        elseif t == 'table' then
            __merge(tbl[k], f)
        end
    end
    return tbl1
end
table.merge = table.twoarg(__merge)

-- useful in merge to replace table with table
table.just = table.twoarg(function(_, val) return val end, 'any?', 'any?')

-- maybe useful with functions that aren't made with twoarg?
function table.with(func, ...)
    assert(type(func) == "function", "argument #1 must be a function")
    local args = { ... }
    return function(val)
        assert(type(val) == "table", "argument #1 must be a table")
        return func(val, table.unpack(args))
    end
end