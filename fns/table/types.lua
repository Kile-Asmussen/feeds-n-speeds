
local table = _ENV.table
local assert = _ENV.assert

function table.is_assoc(tbl)
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
