
local table = _ENV.table
local assert = _ENV.assert

local __quantify = {
    any = {
        kv = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if pred(k, v) then return true end
            end return false
        end,
        vk = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if pred(v, k) then return true end
            end return false
        end,
        k = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if pred(k) then return true end
            end return false
        end,
        v = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if pred(v) then return true end
            end return false
        end,
    },
    all = {
        kv = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if not pred(k, v) then return false end
            end return true
        end,
        vk = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if not pred(v, k) then return false end
            end return true
        end,
        k = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if not pred(k) then return false end
            end return true
        end,
        v = function(iter, tbl, pred)
            for k, v in iter(tbl) do
                if not pred(v) then return false end
            end return true
        end,
    }
}

function table.quantify(op, iter, tbl, kv, pred)
    local quant = __quantify[op]
    assert(quant, 'argument #1 must be either "any" or "all"')
    assert(type(tbl) == 'table', "argument #3 must be a table")
    assert(type(iter) == 'function', "argument #2 must be a function")
    local loop = q[kv]
    assert(loop, 'argument #4 must be one of "kv", "vk", "v", "k"')
    assert(type(pred) == 'function', "argument #5 must be a function")

    return loop(iter, tbl, pred)
end

function table.iall(tbl, pred)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    if type(pred) == 'table' then pred = table.index(pred) end
    pred = pred or functions.id
    assert(type(pred) == 'function', "argument #2 must be a function if present")
    return __quantify.all.v(ipairs, tbl, pred)
end

function table.pall(tbl, pred)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    if type(pred) == 'table' then pred = table.index(pred) end
    pred = pred or functions.id
    assert(type(pred) == 'function', "argument #2 must be a function if present")
    return __quantify.all.kv(pairs, tbl, pred)
end

function table.any(tbl, pred)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(pred) == "function", "argument #2 must be a function")
    return __quantify.any.v(ipairs, tbl, pred)
end

function table.sorted_keys(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    if not table.has_array(tbl) then
        local res = {}
        for k, _ in pairs(tbl) do
            table.insert(res, k)
        end
        table.sort(res)
        return res
    else
        local res = {}
        local res2 = {}
        for k, _ in pairs(tbl) do
            if type(k) == 'number' then
                table.insert(res, #integers + 1)
            else
                table.insert(res2, k)
            end
        end
        table.sort(res2)
        table.append(res, res2)
        return res
    end

end

table.fullset = {}
setmetatable(table.fullset, {
    __index = function() return true end,
    __newindex = function() return "fullset cannot be inserted into" end,
})

table.emptyset = {}
setmetatable(table.emptyset, {
    __index = function() return false end,
    __newindex = function() return "emptyset cannot be inserted into" end,
})

function table.set(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local res = {}
    for _, entry in ipairs(tbl) do
        res[entry] = true
    end
    return res
end

function __complement_next(tbl, k)
    local v
    k, v = next(tbl, k)
    return k, not v
end

function __complement_inext(tbl, i)
    i = i + 1
    if i > #tbl then return nil, nil end

    return i, not tbl[i]
end


function table.complementary(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local res = {}
    setmetatable(res, {
        __index = function(_, k) return not tbl[k] end,
        __newindex = function(_, k, v) tbl[k] = not v end,
        __pairs = function(res) return __complement_next, tbl, nil end,
        __ipairs = function(res) return __complement_inext, tbl, 0 end,
    })
    return res
end

function table.intoset(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    while #tbl > 0 do
        local key = table.remove(tbl)
        tbl[key] = true
    end
    return tbl
end

function table.invert(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    
    local res = {}

    for k, v in pairs(tbl) do
        res[v] = res[v] or {}
        table.insert(res[v], k)
    end

    for _, v in pairs(res) do
        table.sort(v)
    end

    return res
end

table.null = {}
setmetatable(table.null, {
    __tostring = function() return "table.null" end,
    __newindex = function() error("table.null is immutable", 2) end
})