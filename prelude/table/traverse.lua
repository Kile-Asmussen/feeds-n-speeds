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
    local keys = table.pack(...)
    
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
    local keys = table.pack(...)
    
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

function table.at(...)
    local args = table.pack(...)
    return function(tbl) return table.access(tbl, table.unpack(args)) end
end

function table.index(tbl)
    return function(...) return table.access(tbl, ...) end
end