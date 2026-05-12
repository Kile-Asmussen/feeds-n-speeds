function table.size(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k = next(tbl)
    local n = 0
    while k do
        n = n + 1
        k = next(tbl, k)
    end
    return n
end

function table.is_empty(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return not next(tbl)
end

function table.has_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.maxn(tbl) ~= 0
end

function table.is_assoc(tbl)
    if getmetatable(tbl) == table.__assoc_mt then return true end
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.is_empty(tbl) or not table.has_array(tbl)
end

function table.is_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if getmetatable(tbl) == table.__array_mt then return true end
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number'
    return k == nil
end

function table.has_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number' or k == nil
    return k ~= nil and type(k) ~= 'number'
end

local function __array_newindex(tbl, i, v)
    assert(type(i) == 'number', "cannot insert non-numerical key into array")
    assert(math.floor(i) == i, "cannot insert non-integer key into array")
    assert(i >= 1, "cannot insert zero or negative key into array")
    rawset(tbl, i, v)
end

local function __assoc_pairs()
    error("cannot iterate pairs over table.assoc", 2)
end

table.__array_mt = {
    __newindex = __array_newindex,
    __pairs = __assoc_pairs,
}

local function __assoc_newindex(tbl, k, v)
    assert(type(k) == 'string', "cannot insert non-string key into associative array")
    rawset(tbl, k, v)
end

local function __assoc_ipairs()
    error("cannot iterate ipairs over table.assoc", 2)
end

table.__assoc_mt = {
    __newindex = __assoc_newindex,
    __ipairs = __assoc_ipairs,
}

if _G.TESTING then

    function table.array(tbl)
        tbl = tbl or {}
        assert(table.is_array(tbl), "non-array table passed to table.array")
        assert(not getmetatable(tbl), "already has a metatable")
        setmetatable(tbl, table.__array_mt)
        return tbl
    end

    function table.assoc(tbl)
        tbl = tbl or {}
        assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
        assert(not getmetatable(tbl), "already has a metatable")
        setmetatable(tbl, table.__array_mt)
        return tbl
    end

else

    function table.array(tbl)
        tbl = tbl or {}
        assert(table.is_array(tbl), "non-array table passed to table.array")
        return tbl
    end

    function table.assoc(tbl)
        tbl = tbl or {}
        assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
        return tbl
    end

end

_G.assoc = table.assoc
_G.array = table.array