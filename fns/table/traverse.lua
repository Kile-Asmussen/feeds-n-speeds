
return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local error = fns.error
    local pairs = fns.table.pairs
    local ipairs = fns.table.ipairs


    local function traverse(tbl, func)
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

    --- Iterate in depth through a table, mapping values
    ---
    --- func is a function returning 2 values:
    ---     - what to replace the current index with
    ---     - if replacing should happen
    ---
    --- in the case of a subtable, a truthy value as the replace value
    --- but a falsy should-replace value means iteration should not 
    --- proceed into the sub-table.
    function table.traverse(tbl, func)
        return traverse(tbl, func)
    end

    table.traverse = table.twoarg('function', traverse, 'traverse')

    --- Descend into a table and its subtables according to a list of keys
    --- and fetch the value at the bottom if any
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
    table.access = table.twoarg(table.access, 'access')

    --- Descend into a table and its subtables according to a list of keys
    --- and assign the keys.val value at the bottom (will create tables as necessary)
    function table.assign(tbl, keys)
        if #keys == 0 then
            if type(keys.val) == 'function' then
                return keys.val(tbl)
            else
                return keys.val
            end
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
        
        if type(keys.val) == 'function' then
            down[last] = keys.val(down[last])
        else
            down[last] = keys.val
        end

        return tbl
    end
    table.assign = table.twoarg(table.assign, 'assign')

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

    local function deepcopy(tbl, res)
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                res[k] = {}
                deepcopy(v, res[k])
            else
                res[k] = v
            end
        end
    end

    --- Fully duplicating deepcopy, not suitable for recursive tables
    function table.deepcopy(tbl)
        if type(tbl) ~= 'table' then return tbl end
        local res = {}
        deepcopy(tbl, res)
        return res
    end

    function table.select(tbl, keys)
        local res = {}
        for i = 1, #keys do
            local k = keys[i]
            res[k] = tbl[k]
        end
        return res
    end
    table.select = table.twoarg(table.select, 'select')
end