
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
    local res = {}
    if table.has_array(tbl) then
        for k, _ in pairs(tbl) do
            if type(k) == 'number' and 1 <= k and k <= #tbl then else
                table.insert(res, k)
            end
        end
    else
        for k, _ in pairs(tbl) do
            table.insert(res, k)
        end
    end
    table.sort(res)
    return res
end

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
    return table.assoc(tbl)
end

table.null = {}
setmetatable(table.null, {
    __tostring = function() return "table.null" end,
    __newindex = function() error("table.null is immutable", 2) end
})