return function(table, fns)

    local assert = fns.assert
    local pairs = table.pairs

    function table.override(tbl1, tbl2)
        for k, v in pairs(tbl2) do
            tbl1[k] = v
        end

        return tbl1
    end
    table.declare_twoarg('override')

    function table.replace(tbl1, tbl2)
        for k, _ in pairs(tbl1) do
            if tbl2[k] ~= nil then
                tbl1[k] = tbl2[k]
            end
        end

        return tbl1
    end
    table.declare_twoarg('replace')

    function table.include(tbl1, tbl2)
        for k, v in pairs(tbl2) do
            if tbl1[k] == nil then
                tbl1[k] = v
            end
        end

        return tbl1
    end
    table.declare_twoarg('include')

    function table.transmute(tbl1, tbl2)
        for k, _ in pairs(tbl1) do
            local func = tbl2[k]
            assert(type(func) == 'function', "fns.table.transmute: argument #2 must only contain functions")
            tbl1[k] = func(tbl1)
        end
    end
    table.declare_twoarg('transmute')

    function table.append(tbl1, tbl2)
        for i = 1, #tbl2 do
            table.insert(tbl1, tbl2[i])
        end
        return tbl1
    end
    table.declare_twoarg('append')

    function table.cut(tbl, n)
        while #tbl > n do
            table.remove(tbl)
        end
    end
    table.declare_twoarg('cut', 'number')

    function table.flatten_keys(tbl)
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

    local merge
    --- Merge tbl2 into tbl1
    --- tlb2 and its subtables can have special keys
    ---
    --- __rec : boolean?
    --- if __rec is set to true, then merge all subtables instead of overwriting
    --- despite the name 'rec' as in 'recursion', this does not propagate to subtables
    --- it only applies for this single level
    ---
    --- __merge : boolean?
    --- if set in a sub-table will override the behavior of __rec set in the containing table
    function table.merge(tbl1, tbl2)
        tbl2 = table.flatten_keys(tbl2)
        local strict = tbl2.__strict and true or false

        for k, v in pairs(tbl2) do
            if k == '__merge' or k == '__rec' or k == '__strict' then goto continue end

            if strict and tbl1[k] == nil then
                error("Strict merge failed to find extant key " .. k, 2)
            end
        
            local t = type(v)
        
            if t == 'function' then
                tbl1[k] = v(tbl1[k])
        
            elseif t == 'table' and type(tbl1[k]) == 'table' then

                if (tbl2.__rec or v.__merge == true) and v.__merge ~= false then
                    merge(tbl1[k], v)
                else
                    tbl1[k] = v
                end
                
            else
                tbl1[k] = v
            end
        
            ::continue::
        end
        return tbl1
    end
    merge = table.merge
    table.declare_twoarg('merge')
end