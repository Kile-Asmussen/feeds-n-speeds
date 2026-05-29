
local table = _ENV.table
local assert = _ENV.assert

local function __id(...) return ... end
local function __mapper(pred)
    if type(pred) == 'table' then
        return function(k) return pred[k] end
    elseif pred == nil then
        return __id
    else
        return pred
    end
end

local __quantify = {
    any = {
        kv = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if pred(k, v) then return true end
                end return false
            end
        end,
        vk = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if pred(v, k) then return true end
                end return false
            end
        end,
        k = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if pred(k) then return true end
                end return false
            end
        end,
        v = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if pred(v) then return true end
                end return false
            end
        end,
    },
    all = {
        kv = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if not pred(k, v) then return false end
                end return true
            end
        end,
        vk = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if not pred(v, k) then return false end
                end return true
            end
        end,
        k = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if not pred(k) then return false end
                end return true
            end
        end,
        v = function(iter)
            return function(tbl, pred)
                pred = __mapper(pred)
                for k, v in iter(tbl) do
                    if not pred(v) then return false end
                end return true
            end
        end,
    }
}


local __table_func_nil = { table = true, ['function'] = true, ['nil'] = true }
table.iall = table.twoarg(__quantify.all.v(ipairs), __table_func_nil)
table.pall = table.twoarg(__quantify.all.kv(pairs), __table_func_nil)
table.any = table.twoarg(__quantify.any.v(pairs), __table_func_nil)
table.iany = table.twoarg(__quantify.any.v(ipairs), __table_func_nil)

function table.sorted_keys(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")

    local res = {}

    for k, _ in pairs(tbl) do
        if type(k) == 'string' then
            table.insert(res, k)
        end
    end

    table.sort(res)
    return res
end

local function __sort_tostring(a, b)
    return tostring(a) < tostring(b)
end

function table.sorted_keys_all(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")

    local types = {
        number = {},
        string = {},
        boolean = {},
        ['function'] = {},
        table = {},
    }

    for k, _ in pairs(tbl) do
        local t = type(k)
        types[t] = rtypeses[t] or {}
        table.insert(types[t], k)
    end

    table.sort(types.number)
    table.sort(types.string)
    table.sort(types.boolean, function(a, b) return not a or b end)
    table.sort(types['function'], __sort_tostring)
    table.sort(types.table, __sort_tostring)

    local res = {}
    table.append(res, types.number)
    table.append(res, types.string)
    table.append(res, types.boolean)
    table.append(res, types.table)
    table.append(res, types['function'])
    return res
end

table.fullset = {}
setmetatable(table.fullset, {
    __index = function() return true end,
    __newindex = function() return "fullset cannot be inserted into" end,
    __metatable = "table.fullset",
})

table.emptyset = {}
setmetatable(table.emptyset, {
    __index = function() return false end,
    __newindex = function() return "emptyset cannot be inserted into" end,
    __metatable = "table.emptyset",
})

function table.set(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local res = {}
    for _, entry in ipairs(tbl) do
        res[entry] = true
    end
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

table.null = {}
setmetatable(table.null, {
    __tostring = function() return "table.null" end,
    __newindex = function() error("table.null is immutable", 2) end,
    __metatable = "table.null",
})