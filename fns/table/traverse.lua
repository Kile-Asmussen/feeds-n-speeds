
local table = _ENV.table
local assert = _ENV.assert

local function __search(any, fn)
    if fn(any) then return any end

    if type(any) ~= 'table' then return nil end

    for k, v in pairs(any) do
        local found = __search(v, fn)
        if found ~= nil then return found end
    end

    return nil
end

table.twoarg('search', __search, 'function')

local function __search_all(any, fn, hits)

    hits = hits or {}

    if fn(any) then
        table.insert(hits, any)
        return hits
    end

    if type(any) ~= 'table' then
        return hits
    end

    for k, v in pairs(any) do
        __search(v, fn, hits)
    end

    return hits
end

table.twoarg('search_all', __search_all, 'function')


local function __traverse(tbl, func)
    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            local stop, replace = func(v, k)
            if replace then
                tbl[k] = stop
            elseif not stop then
                __traverse(v, func)
            end
        else
            local value, replace = func(v, k)
            if replace then
                tbl[k] = value
            end
        end
    end
    return tbl
end

table.twoarg('traverse', __traverse, 'function')

function table.replace(tbl, a, b)
  table.traverse(tbl, function(v)
    if a == v then
      return b, true
    end
  end)
end

local function __access(tbl, keys)
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return nil
        end

        if tbl[key] ~= nil then
            tbl = tbl[key]
        else
            return nil
        end
    end
    
    return tbl
end

table.twoarg('access', __access)

local function __assign(tbl, keys)
    if #keys == 0 then
        return keys.val
    end

    local last = table.remove(keys)
    local down = tbl
    
    for _, key in ipairs(keys) do
        if down[key] == nil then down[key] = {} end

        if type(down[key]) ~= 'table' then
            down[key] = { __old = down[key] }
        end

        down = down[key]
    end
    
    down[last] = keys.val

    return tbl
end

table.twoarg('assign', __assign)

local function __apply(tbl, keys)
    if #keys == 0 then
        error("cannot apply to empty path", 3)
    end

    local last = table.remove(keys)
    local down = tbl
    
    for _, key in ipairs(keys) do
        if down[key] == nil then down[key] = {} end

        if type(down[key]) ~= 'table' then
            down[key] = { __old = down[key] }
        end

        down = down[key]
    end
    
    down[last] = keys.op(down[last])

    return tbl
end

table.twoarg('apply', __apply)

table.twoarg('index', function(tbl, k) return tbl[k] end, 'any')

function table.newindex(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return function(k, v) tbl[k] = v return tbl end
end

function table.dup(tbl)
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = v
    end
    return res
end

local function __deepcopy(tbl, res, seen, setmeta)
    if seen[tbl] then return seen[tbl] end
    if setmeta then
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                if seen[v] then
                    res[k] = seen[v]
                else
                    seen[v] = {}
                    setmetatable(seen[v], getmetatable(v))
                    res[k] = __deepcopy(v, seen[v], seen)
                end
            else
                res[k] = v
            end
        end
    else
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                seen[v] = {}
                res[k] = __deepcopy(v, seen[v], seen)
            else
                res[k] = v
            end
        end
    end

    return res
end

function table.deepcopy(tbl, setmeta)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    setmeta = setmeta and true or false
    return __deepcopy(tbl, {}, {}, setmeta)
end

local function __clone(seen, setmeta)
    if setmeta then
        local function clone(tbl)
            if type(tbl) == 'table' then
                if not seen[tbl] then
                    seen[tbl] = table.collect(tbl, clone)
                    setmetatable(seen[tbl], getmetatable(tbl))
                    return seen[tbl]
                else
                    return tbl
                end
            else
                return tbl
            end
        end
        return clone
    else
        local function clone(tbl)
            if type(tbl) == 'table' then
                if not seen[tbl] then
                    seen[tbl] = table.collect(tbl, clone)
                    return seen[tbl]
                else
                    return tbl
                end
            else
                return tbl
            end
        end
        return clone
    end
end

function table.clone(tbl, setmeta)
    setmeta = setmeta and true or false
    if type(tbl) ~= 'table' then return tbl end
    return __clone({}, setmeta)(tbl)
end

function table.lookup(tbl)
    return function(val) return tbl[val] end
end