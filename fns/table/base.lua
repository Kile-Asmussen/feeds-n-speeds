return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local error = fns.error
    local tostring = fns.tostring
    local setmetatable = table.setmetatable

    local valid_types_map = {
        any = {
            number=true,
            boolean=true,
            string=true, 
            ['function']=true,
            table=true
        },
    }
    valid_types_map['any?'] = {}
    for k,_ in table.pairs(valid_types_map.any) do
        valid_types_map[k] = { [k] = true }
        valid_types_map[k .. '?'] = { [k] = true, ['nil'] = true }
        valid_types_map['any?'][k] = true
    end
    valid_types_map['any?']['nil'] = true

    local function valid_types_set(pattern)
        if type(pattern) == 'table' then
            return pattern
        elseif valid_types_map[pattern] then
            return valid_types_map[pattern]
        end
    end

    local function twoarg_errmsg(set)
        local tbl = {}
        for k, _ in pairs(set) do table.insert(tbl, k) end
        table.sort(tbl)
        local last = table.remove(tbl)
        if #tbl == 0 then return last else
            return table.concat(tbl, ', ') .. ', or ' .. last
        end
    end

    function table.declare_twoarg(name, ...)
        assert(type(name) == 'string', "table.declare_twoarg: argument #1 must be a string or nil")
        
        local n = select('#', ...)

        local func = table/name
        assert(type(func) == 'function', "table.declare_twoarg: argument #1 must be the name of a declared function")

        local types_1, types_2 = valid_types_map.table, valid_types_map.table

        if n == 1 then
            types_2 = ...
            types_2 = valid_types_set(types_2) or error("table.declare_twoarg: argument #2 must be a table or string", 2)
        elseif n == 2 then
            types_1, types_2 = ...
            types_1 = valid_types_set(types_1) or error("table.declare_twoarg: argument #2 must be a table or string", 2)
            types_2 = valid_types_set(types_2) or error("table.declare_twoarg: argument #3 must be a table or string", 2)
        elseif n ~= 0 then
            error("too many arguments, expected 2 to 4", 2)
        end

        local type_error_1 = twoarg_errmsg(types_1)
        local type_error_2 = twoarg_errmsg(types_2)
        local error_1 = 'fns.table.' .. name .. ": argument #1 is of wrong type, expected " .. type_error_1
        local mono_error_2 = 'fns.table.' .. name .. ": argument #1 is of wrong type, expected " .. type_error_2
        local duo_error_2 = 'fns.table.' .. name .. ": argument #2 is of wrong type, expected " .. type_error_2

        local function wrapper_function(...)
            local n = select('#', ...)
            if n == 1 then
                local arg2 = ...
                assert(types_2[type(arg2)], mono_error_2 .. ' not ' .. type(arg2))
                return function(arg1, ...)
                    assert(types_1[type(arg1)], error_1 .. ' not ' .. type(arg1))
                    return func(arg1, arg2, ...)
                end
            elseif n >= 2 then
                local arg1, arg2 = ...
                assert(types_1[type(arg1)], error_1 .. ' not ' .. type(arg1))
                assert(types_2[type(arg2)], duo_error_2 .. ' not ' .. type(arg2))
                return func(...) -- call with everything
            else
                error("wrong number of arguments, expected at least 1")
            end
        end
        if table/name then table[name] = wrapper_function end
        return wrapper_function
    end

    --- Complicated 2nd/3rd order helper function that creates utility functions with typechecking
    --- let func be a two-place function, i.e. func = function(a, b) ... end
    --- then table.twoarg(func) is a function that accepts 1-2 arguments and returns a function obeying:
    --- * table.twoarg(func)(b)(a, ...) => func(a, b, ...)
    --- * table.twoarg(func)(a, b, ...) => func(a, b, ...)
    --- (the function are not necessarily limited to two arguments, to account for
    --- nominally two arg functions that might take optional extra arguments)
    ---
    --- Optional 1-2 extra arguments to twoarg are type-checking patterns:
    --- * twoargs(func) assumes both arguments to be tables
    --- * twoarg(pattern_b, func) will only check the second argument b to func and assume a to be a table
    --- * twoarg(pattern_a, pattern_b, func) will check both arguments to func according to the patterns
    ---
    --- the type patterns can be:
    --- * a set (table mapping strings to booleans): only type names in the set allowed
    --- * name of a type: equivalent to a set of only that type name
    --- * name of a type + '?': equivalent to a set of only that type name and 'nil' (type(nil) == 'nil')
    --- * 'any': all types (excepting userdata, corountine and other exotic types)
    --- * 'any?': all types and nil
    function table.twoarg(...)
        local n = select('#', ...)
        local func, name, types_1, types_2 = nil, nil, valid_types_set('table'), valid_types_set('table')
        if n == 2 then
            func, name = ...
        elseif n == 3 then
            types_2, func, name = ...
            types_2 = valid_types_set(types_2) or error("table.twoarg: argument #1 must be a table or string", 2)
        elseif n == 4 then
            types_1, types_2, func, name = ...
            types_1 = valid_types_set(types_1) or error("table.twoarg: argument #1 must be a table or string", 2)
            types_2 = valid_types_set(types_2) or error("table.twoarg: argument #2 must be a table or string", 2)
        else
            error("table.twoarg: expected 2 to 4 arguments")
        end

        if type(func) ~= 'function' then error("table.twoarg: argument #" .. n-1 .. "must be a function") end
        name = tostring(name)

        local type_error_1 = twoarg_errmsg(types_1)
        local type_error_2 = twoarg_errmsg(types_2)
        local error_1 = 'fns.table.' .. name .. ": argument #1 is of wrong type, expected " .. type_error_1
        local mono_error_2 = 'fns.table.' .. name .. ": argument #1 is of wrong type, expected " .. type_error_2
        local duo_error_2 = 'fns.table.' .. name .. ": argument #2 is of wrong type, expected " .. type_error_2

        local function wrapper_function(...)
            local n = select('#', ...)
            if n == 1 then
                local arg2 = ...
                assert(types_2[type(arg2)], mono_error_2 .. ' not ' .. type(arg2))
                return function(arg1, ...)
                    assert(types_1[type(arg1)], error_1 .. ' not ' .. type(arg1))
                    return func(arg1, arg2, ...)
                end
            elseif n >= 2 then
                local arg1, arg2 = ...
                assert(types_1[type(arg1)], error_1 .. ' not ' .. type(arg1))
                assert(types_2[type(arg2)], duo_error_2 .. ' not ' .. type(arg2))
                return func(...) -- call with everything
            else
                error("wrong number of arguments, expected at least 1")
            end
        end

        return wrapper_function
    end

    function table.is_empty(tbl)
        assert(type(tbl) == "table", "fns.table.is_empty: argument #1 must be a table")
        return table.size(tbl) == 0
    end

    --- Attach a a default-value providing metatable to a table.
    function table.with_default(value, res)
        res = res or {}
        assert(type(res) == "table", "fns.table.with_default: argument #1 must be a table")
        assert(value ~= nil, "fns.table.with_default: argument #2 must be non-nil")
        setmetatable(res, { __index = function() return value end })
        return res
    end

end -- return function