
return function(table, fns)
    local assert = fns.assert

    local pairs = table.pairs
    local ipairs = table.ipairs
    local type = fns.type

    local function mapper(func)
        if type(func) == 'table' then
            return function(k) return func[k] end
        else
            return func
        end
    end

    local function_or_table = { ['function'] = true, table = true }

    function table.imap(tbl, func)
        func = mapper(func)
        for i = 1, #tbl do
            tbl[i] = func(tbl[i], i)
        end
        return tbl
    end
    table.twoarg(function_or_table, table.imap, 'imap')

    function table.map(tbl, func)
        func = mapper(func)
        for k, v in pairs(tbl) do
            tbl[k] = func(v, k)
        end
        return tbl
    end
    table.map = table.twoarg(function_or_table, table.map, 'map')

    function table.collect(tbl, func)
        local func = mapper(func)
        local res = {}
        for k, v in pairs(tbl) do
            res[k] = func(v, k)
        end
        return res
    end
    table.collect = table.twoarg(function_or_table, table.collect, 'collect')

    function table.icollect(tbl, func)
        local func = mapper(func)
        local res, n = {}, 1
        for i = 1, #tbl do
            local v = func(tbl[i])
            if v ~= nil then
                res[n] = v
                n = n + 1
            end
        end
        return res
    end
    table.icollect = table.twoarg(function_or_table, table.icollect, 'icollect')

    local function opairs_iter(state)
        state.i = state.i + 1
        local key = state.keys[state.i]
        if key then 
            return key, state.tbl[key]
        end
    end

    --- Iterate over ordered string keys
    function table.opairs(tbl, mapper)
        assert(type(tbl) == 'table', "fns.table.opairs: argument #1 must be a table")
        assert(mapper == nil or type(mapper) == 'function' or type(mapper) == 'table', "fns.table.opairs: argument #2 must be a table or function")
        return opairs_iter, { i=0, keys=table.sorted_keys(tbl, mapper), tbl=tbl }, nil
    end

end