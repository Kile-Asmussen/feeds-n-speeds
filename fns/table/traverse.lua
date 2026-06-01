
return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local error = fns.error
    local pairs = fns.table.pairs
    local ipairs = fns.table.ipairs

    local search
    function table.search(any, fn)
        if fn(any) then return any end

        if type(any) ~= 'table' then return nil end

        for k, v in pairs(any) do
            local found = search(v, fn)
            if found ~= nil then return found end
        end

        return nil
    end
    search = table.search
    table.declare_twoarg('search', 'function')


    local traverse
    function table.traverse(tbl, func)
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                local stop, replace = func(v, k)
                if replace then
                    tbl[k] = stop
                elseif not stop then
                    traverse(v, func)
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
    traverse = table.traverse

    table.declare_twoarg('traverse', 'function')

    function table.replace(tbl, a, b)
        table.traverse(tbl, function(v)
            if a == v then
            return b, true
            end
        end)
    end

    function table.access(tbl, keys)
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
    table.declare_twoarg('access')

    function table.assign(tbl, keys)
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
    table.declare_twoarg('assign')

    function table.apply(tbl, keys)
        if #keys == 0 then
            error("table.apply: cannot apply to empty path", 3)
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
    table.declare_twoarg('apply')

    function table.index(tbl)
        assert(type(tbl) == "table", "table.index: argument #1 must be a table")
        return function(k) return tbl[k] end 
    end

    function table.newindex(tbl)
        assert(type(tbl) == "table", "table.newindex: argument #1 must be a table")
        return function(k, v) tbl[k] = v return tbl end
    end

    function table.dup(tbl)
        assert(type(tbl) == "table", "table.dup: argument #1 must be a table")
        local res = {}
        for k, v in pairs(tbl) do
            res[k] = v
        end
        return res
    end

    local function deepcopy(tbl, res, seen)
        if seen[tbl] then return seen[tbl] end
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                res[k] = {}
                deepcopy(v, res[k], seen)
                seen[v] = res[k]
            else
                res[k] = v
            end
        end
    end

    function table.deepcopy(tbl)
        if type(tbl) ~= 'table' then return tbl end
        local res = {}
        deepcopy(tbl, res, {})
        return res
    end
end