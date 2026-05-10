
_G.functions = {}

functions.type = type

function functions.as(val, as)
    if as == nil then
        as = val
        assert(type(as) == 'string', "argument #1 must be a string")

        return function(val)
            if functions.type(val) == as then return val else return nil end
        end
    end

    assert(type(as) == 'string', "argument #2 must be a string")
    if functions.type(val) == as then return val else return nil end
end

function functions.id(val)
    return val
end

function functions.curry(f, ...)
    f = functions.as(f, "function")
    assert(f, "argument #1 must be a function")
    local args = table.pack(...)
    return function(...)
        table.append(args, table.pack(...))
        return f(table.unpack(args))
    end
end

function functions.with(...)
    local args = table.pack(...)
    return function(f)
        f = functions.as(f, "function")
        assert(f, "argument #1 must be a function")
        return f(table.unpack(args))
    end
end

function functions.comp(f, ...)
    if select('#', ...) == 0 then
        return f
    end
    local rest = functions.pipe(...)
    return function(...)
        return f(rest(...))
    end
end

function functions.pipe(f, ...)
    if select('#', ...) == 0 then
        return f
    end
    local rest = functions.pipe(...)
    return function(...)
        return rest(f(...))
    end
end