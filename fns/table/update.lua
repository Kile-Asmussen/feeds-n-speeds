
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

local function __merge(tbl1, tbl2)
    for k, v in table.opairs(tbl2) do
        if type(v) ~= 'function' then tbl1[k] = v end
    end
    for k, f in table.opairs(tbl2) do
        if type(f) == 'function' then tbl1[k] = f(tbl1[k]) end
    end
    return tbl1
end

local function __merge_rec(tbl1, tbl2)
    for k, v in table.opairs(tbl2) do
        if type(v) ~= 'function' then tbl1[k] = v end
    end
    for k, f in table.opairs(tbl2) do
        if type(f) == 'function' then tbl1[k] = f(tbl1[k], tbl1) end
    end
    return tbl1
end

table.merge = table.twoarg(__merge)
table.merge_rec = table.twoarg(__merge_rec)

function table.with(func, ...)
    assert(type(func) == "function", "argument #1 must be a function")
    local args = { ... }
    return function(val)
        assert(type(val) == "table", "argument #1 must be a table")
        return func(val, table.unpack(args))
    end
end