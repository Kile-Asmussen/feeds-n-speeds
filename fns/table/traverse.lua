
local table = _ENV.table
local assert = _ENV.assert

local function __search(tbl, fn)
    if fn(tbl) then return tbl end

    if type(tbl) ~= 'table' then return nil end

    for k, v in pairs(tbl) do
        local found = __search(v, fn)
        if found then return found end
    end

    return nil
end

function table.search(tbl, thing)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(thing) ~= 'function' then
        return __search(tbl, table.pattern(thing))
    else
        return __search(tbl, thing)
    end
end

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
end

function table.traverse(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    __traverse(tbl, func)
end

function table.replace(tbl, a, b)
  table.traverse(tbl, function(v)
    if a == v then
      return b, true
    end
  end)
end

local function __descend(tbl, keys)
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return tbl, false
        end

        if tbl[key] ~= nil then
            tbl = tbl[key]
        else
            return tbl, false
        end
    end
    
    return tbl, true
end

function table.descend(...)
    local n = select('#', ...) 
    if n == 1 then
        local keys = ...
        assert(type(keys) == "table", "argument #1 must be a table", 2)
        return function(tbl)
            assert(type(tbl) == "table", "argument #1 must be a table", 2)
            return __descend(tbl, keys)
        end
    else
        local tbl, keys = ...
        assert(type(tbl) == "table", "argument #1 must be a table", 2)
        assert(type(keys) == "table", "argument #2 must be a table", 2)
        return __descend(tbl, keys)
    end
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

function table.access(...)
    local n = select('#', ...)
    if n == 1 then
        local keys = ...
        assert(type(keys) == "table", "argument #1 must be a table")
        return function(tbl)
            assert(type(tbl) == "table", "argument #1 must be a table")
            return __access(tbl, keys)
        end
    else
        local tbl, keys = ...
        assert(type(tbl) == "table", "argument #1 must be a table")
        assert(type(keys) == "table", "argument #2 must be a table")
        return __access(tbl, keys)
    end
end

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

table.assign = table.twoarg(__assign)

function table.index(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return function(k) return tbl[k] end
end

function table.newindex(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return function(k, v) tbl[k] = v return tbl end
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