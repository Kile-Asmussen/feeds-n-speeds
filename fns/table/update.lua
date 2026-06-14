return function(table, fns)

    local assert = fns.assert
    local pairs = table.pairs

    --- Write values of tbl2 into tbl1
    function table.override(tbl1, tbl2)
        for k, v in pairs(tbl2) do
            tbl1[k] = v
        end

        return tbl1
    end
    table.override = table.twoarg(table.override, 'override')

    --- Replace values in tbl1 with values from tbl2
    function table.replace(tbl1, tbl2)
        for k, _ in pairs(tbl1) do
            if tbl2[k] ~= nil then
                tbl1[k] = tbl2[k]
            end
        end

        return tbl1
    end
    table.replace = table.twoarg(table.replace, 'replace')

    --- Add values from tbl2 to tbl1 if the keys are not populated
    function table.include(tbl1, tbl2)
        for k, v in pairs(tbl2) do
            if tbl1[k] == nil then
                tbl1[k] = v
            end
        end

        return tbl1
    end
    table.include = table.twoarg(table.include, 'include')

    --- Apply functions tbl2 to tbl1's values according to keys
    function table.transmute(tbl1, tbl2)
        for k, _ in pairs(tbl1) do
            local func = tbl2[k]
            assert(type(func) == 'function', "fns.table.transmute: argument #2 must only contain functions")
            tbl1[k] = func(tbl1[k], tbl1)
        end
        return tbl1
    end
    table.transmute = table.twoarg(table.transmute, 'transmute')

    --- Append numeric keys to a table
    function table.append(tbl1, tbl2)
        local n = #tbl1
        for i = 1, #tbl2 do
            tbl1[n + i] = tbl2[i]
        end
        return tbl1
    end
    table.append = table.twoarg(table.append, 'append')

    --- Cut a table down to a given size
    function table.cut(tbl, n)
        for i = #tbl, n, -1 do
            tbl[i] = nil
        end
        return tbl
    end
    table.cut = table.twoarg('number', table.cut, 'cut')

    --- Delete the keys in the second table
    function table.delete(tbl1, tbl2)
        for i = 1, #tbl2 do
            tbl1[tbl2[i]] = nil
        end
        return tbl1
    end
    table.delete = table.twoarg(table.delete, 'delete')

    --- Flatten table-valued keys in tbl into their contents
    --- [{'a', 'b'}] = x   =>  a = x, b = x
    local function flatten_keys(tbl)
        assert(type(tbl) == 'table', "argument #1 must be a table")
        local res = {}
        for k, v in pairs(tbl) do
            if type(k) == 'table' then
                for i = 1,#k do res[k[i]] = v end
            else
                res[k] = v
            end
        end
        return res
    end

    local function merge(tbl1, tbl2)
        tbl2 = flatten_keys(tbl2)
        local strict = tbl2.__strict and true or false

        for k, v in pairs(tbl2) do
            if k == '__merge' or k == '__rec' or k == '__strict' or k == '__del' then goto continue end

            if strict and tbl1[k] == nil then
                error("Strict merge failed to find extant key " .. k, 2)
            end
        
            local t = type(v)
        
            if t == 'function' then
                tbl1[k] = v(tbl1[k])
        
            elseif t == 'table' and type(tbl1[k]) == 'table' then

                if (tbl2.__rec and v.__merge ~= false) or v.__merge then
                    merge(tbl1[k], v)
                else
                    tbl1[k] = v
                end
                
            else
                tbl1[k] = v
            end
        
            ::continue::
        end

        local delete = tbl2.__del

        if delete == nil then return tbl1 end

        if delete ~= nil and type(delete) ~= 'table' then
            delete = { delete }
            tbl2.__del = delete
        elseif #delete == 0 then
            delete = nil
            tbl2.__del = nil
            return tbl1
        end


        if strict then
            for i = 1, #delete do
                if tbl1[delete[i]] ~= nil then
                    tbl1[delete[i]] = nil
                else
                    error("Strict merge failed to find extant key " .. delete[i], 2)
                end
            end
        else
            for i = 1, #delete do
                tbl1[delete[i]] = nil
            end
        end

        return tbl1
    end

    --- Merge tbl2 into tbl1
    --- See fns.table.twoarg in fns/table/base.lua
    ---
    --- Non-table values in tbl2 will be inserted directly into tbl1
    --- Function values in tbl2 will be called with the corresponding value in tbl1
    ---     and the return value will be inserted
    ---
    --- Table keys in tbl2 will be unrolled into separate keys,
    ---     [{'a', 'b'}] = x   =>  a = x, b = x
    --- 
    --- Subtables will be inserted directly unless special keys are set:
    ---
    --- __rec : boolean?
    --- if __rec is set to true, then merge all subtables instead of overwriting
    --- despite the name 'rec' as in 'recursion', this does not propagate to subtables
    --- it only applies for this single level
    ---
    --- __merge : boolean?
    --- if set in a sub-table will override the behavior of __rec set in the containing table
    ---
    --- Futher special keys are available:
    ---
    --- __del : array[any]
    --- if set will delete the given keys
    ---
    --- __strict : boolean?
    --- if set, attempting to add new keys will be rejected
    function table.merge(tbl1, tbl2)
        return merge(tbl1, tbl2)
    end

    table.merge = table.twoarg(merge, 'merge')
end