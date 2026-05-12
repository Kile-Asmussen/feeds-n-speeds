
_ENV.functions = {}

functions.type = type

functions.__types = {
    string = true,
    number = true,
    ['function'] = true,
    userdata = true,
    coroutine = true,
    table = true
}

function functions.fail(...)
    local msg = table.pack(...)
    return function(...)
        for i,v in ipairs(msg) do
            if type(v) == 'number' then
                msg[i] = tostring(select(v, ...))
            else
                msg[i] = tostring(v)
            end
        end
        error(table.concat(msg), 2)
    end
end

function functions.assertion(pred, msg)
    return function(...)
        assert(pred(...), msg)
    end
end

function functions.as(...)
    local n = select('#', ...)

    if n == 1 then
        local as = ...
        if type(as) == 'function' then
            return function(val)
                if as(val) then return val end
            end
        elseif functions.__types[as] then
            return function(val)
                if type(val) == as then return val end
            end
        else
            error('argument #1 must be a predicate or a type name', 2)
        end
    elseif n == 2 then
        local val, as = ...
        if type(as) == 'function' then
            if as(val) then return val end
        elseif functions.__types[as] then
            if type(val) == as then return val end
        else
            error('argument #2 must be a predicate or a type name', 2)
        end
    else
        error('too many arguments, expected 2', 2)
    end
end

function functions.id(...)
    return ...
end

function functions.drop1st(f)
    f = functions.as(f, "function")
    assert(f, "argument #1 must be a function")
    return function(_, ...) return f(...) end
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

function functions.pipe(f, ...)
    if f == nil then return functions.id end

    f = functions.as(f, "function")
    assert(f, "argument #1 must be a function")

    if select('#', ...) == 0 then
        return f
    end
    local rest = functions.pipe(...)
    return function(...)
        return rest(f(...))
    end
end