
local table = _ENV.table
local assert = _ENV.assert

function table.is_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.is_empty(tbl) or not table.has_array(tbl)
end

function table.has_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    for k, v in pairs(tbl) do
        if type(k) ~= 'number' then return true end
    end
    return false
end

function table.has_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    for _, v in ipairs(tbl) do return true end
    return false
end

function table.is_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return  table.is_empty(tbl) or not table.has_assoc(tbl)
end

function table.dup_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local res = {}
    for _, v in ipairs(tbl) do
        table.insert(res, v)
    end
    return res
end

function table.dup_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local res = {}
    for k, v in pairs(tbl) do
        if type(k) ~= 'number' then
            res[k] = v
        end
    end
    return res
end
