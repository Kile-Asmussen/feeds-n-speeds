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

function table.descend(tbl, ...)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local keys = { ... }
    
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

function table.access(tbl, ...)
    assert(type(tbl) == "table", "argument #1 must be a table")

    local keys = { ... }
    
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

function table.assign(tbl, value, ...)
    assert(type(tbl) == "table", "argument #1 must be a table")

    local keys = { ... }
    assert(#keys >= 1, "expected at least 3 arguments")

    local last = table.remove(keys)

    local down = tbl
    
    for _, key in ipairs(keys) do
        if down[key] == nil then down[key] = {} end

        if type(down[key]) ~= 'table' then
            down[key] = { __assign  = down[key] }
        end

        down = down[key]
    end
    
    down[last] = value

    return tbl
end

function table.at(...)
    local args = { ... }
    return function(tbl) return table.access(tbl, table.unpack(args)) end
end

function table.into(tbl)
    return function(...) return table.access(tbl, ...) end
end

function table.writing(value, ...)
    local args = { ... }
    return function(tbl) return table.assign(tbl, value, table.unpack(args)) end
end

function table.index(tbl)
    return function(k) return tbl[k] end
end

function table.newindex(tbl)
    return function(k, v) tbl[k] = v return tbl end
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
        extra = tbl
        return function(tbl)
            assert(type(tbl) == "table", "argument #1 must be a table")
            return __merge(tbl, extra)
        end
    else
        assert(type(extra) == "table", "argument #2 must be a table")

        return __merge(tbl, extra)
    end

end