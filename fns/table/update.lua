
function table.overwrite(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end

    return tbl1
end

function table.replace(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, _ in pairs(tbl1) do
        if tbl2[k] ~= nil then
            tbl1[k] = tbl2[k]
        end
    end

    return tbl1
end

function table.include(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, v in pairs(tbl2) do
        if tbl1[k] == nil then
            tbl1[k] = v
        end
    end

    return tbl1
end

function table.append(tbl1, tbl2)
    assert(type(tbl1) == 'table', "argument #1 must be a table")
    assert(type(tbl2) == 'table', "argument #2 must be a table")
    for i = 1, #tbl2 do
        table.insert(tbl1, tbl2[i])
    end
    return tbl1
end

function table.cut(tbl, n)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(n) == 'number', "argument #2 must be a number")
    while #tbl > n do
        table.remove(tbl)
    end
end

local function __merge(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        if type(v) == 'function' then
            tbl1[k] = v(tbl1[k])
        else
            tbl1[k] = v
        end
    end
    return tbl1
end

function table.merge(tbl, extra) 
    assert(type(tbl) == "table", "argument #1 must be a table")

    if extra == nil then
        return table.with(table.merge, tbl)
    else
        assert(type(extra) == "table", "argument #2 must be a table")

        return __merge(tbl, extra)
    end

end

function table.with(func, ...)
    assert(type(func) == "function", "argument #1 must be a function")
    local args = { ... }
    return function(val)
        assert(type(val) == "table", "argument #1 must be a table")
        return func(val, table.unpack(args))
    end
end