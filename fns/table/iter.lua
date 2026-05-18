
function table.imap(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    for i, v in ipairs(tbl) do
        tbl[i] = func(v)
    end
    return tbl
end

function table.map(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    for k, v in pairs(tbl) do
        tbl[k] = func(v)
    end
    return tbl
end

function table.project(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    local res = {}
    for k, v in pairs(tbl) do
        local kk, vv = func(k, v)
        res[kk] = vv
    end
    return res
end

function table.collect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function or table")
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v)
    end
    return res
end

function table.icollect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function")
    local res = {}
    for i, v in ipairs(tbl) do
        local v2 = func(v)
        if v2 ~= nil then
            table.insert(res, v2)
        end
    end
    return res
end