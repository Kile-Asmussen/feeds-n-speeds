
local table = _ENV.table

local function __assoc_newindex(tbl, k, v)
    assert(type(k) == 'string', "cannot insert non-string key into associative array")
    rawset(tbl, k, v)
end

local function __assoc_ipairs()
    error("cannot iterate ipairs over table.assoc", 2)
end

local __assoc_mt = {
    __newindex = __assoc_newindex,
    __ipairs = __assoc_ipairs,
}

function table.is_assoc(tbl)
    if getmetatable(tbl) == __assoc_mt then return true end
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.is_empty(tbl) or not table.has_array(tbl)
end

function table.has_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number' or k == nil
    return k ~= nil and type(k) ~= 'number'
end

function table.assoc_mt(tbl)
    tbl = tbl or {}
    assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
    assert(not getmetatable(tbl), "already has a metatable")
    setmetatable(tbl, __assoc_mt)
    return tbl
end

function table.assoc(tbl)
    tbl = tbl or {}
    assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
    return tbl
end