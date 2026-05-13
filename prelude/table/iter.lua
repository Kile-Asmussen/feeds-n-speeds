

function table.imap(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    for k, v in ipairs(tbl) do
        tbl[k] = func(v)
    end
    return tbl
end

function table.collect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function or table")
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v, k)
    end
    return res
end

function table.icollect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function")
    local res = {}
    for i, v in ipairs(tbl) do
        local v2 = func(v, i)
        if v2 ~= nil then
            table.insert(res, v2)
        end
    end
    return res
end