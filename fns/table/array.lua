
local table = _ENV.table
local assert = _ENV.assert

local function __array_newindex(tbl, i, v)
    assert(type(i) == 'number', "cannot insert non-numerical key into array")
    assert(math.floor(i) == i, "cannot insert non-integer key into array")
    assert(i >= 1, "cannot insert zero or negative key into array")
    rawset(tbl, i, v)
end

local function __array_pairs()
    error("cannot iterate pairs over table.assoc", 2)
end

local __array_mt = {
    __newindex = __array_newindex,
    __pairs = __array_pairs,
}

function table.has_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local n = table.maxn(tbl)
    return type(n) == 'number' and n ~= 0 
end

function table.is_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if getmetatable(tbl) == __array_mt then return true end
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number'
    return k == nil
end

function table.array_mt(tbl)
    tbl = tbl or {}
    assert(table.is_array(tbl), "non-array table passed to table.array")
    assert(not getmetatable(tbl), "already has a metatable")
    setmetatable(tbl, __array_mt)
    return tbl
end

function table.array(tbl)
    tbl = tbl or {}
    assert(table.is_array(tbl), "non-array table passed to table.array")
    return tbl
end

