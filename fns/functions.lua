

local functions = require("namespace")("functions")
local assert = _ENV.assert
local table = _ENV.table

local __types = {
    string = true,
    number = true,
    ['function'] = true,
    userdata = true,
    coroutine = true,
    ['nil'] = true,
    boolean = true,
    table = true
}

function functions.fail(...)
    local msg = { ... }
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
        if not pred(...) then error(msg, 2) end
    end
end

function functions.as(tp)
    assert(__types[tp], "argument #1 must be the name of a type")
    return function(x) if type(x) == tp then return x else return nil end end
end

function functions.is(tp)
    assert(__types[tp], "argument #1 must be the name of a type")
    return function(x) return type(x) == tp end
end

function functions.id(...)
    return ...
end

function functions.drop(f, n)
    assert(type(f) == 'function', "argument #1 must be a function")
    assert(type(n) == 'number' and n >= 1 and n == math.floor(n),
        "argument #2 must be a positive non-zero integer")
    return function(...) return f(select(n, ...)) end
end

function functions.curry(f, ...)
    assert(type(f) == 'function', "argument #1 must be a function")
    local outer_args = { ... }
    return function(...)
        local args = {}
        table.append(args, outer_args)
        table.append(args, { ... })
        return f(table.unpack(args))
    end
end

function functions.with(...)
    local args = { ... }
    return function(f)
        assert(type(f) == 'function', "argument #1 must be a function")
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

function functions.null(...) return nil end

local __env_functions = _ENV.functions -- probably nil

function functions.use()
    rawset(_ENV, 'functions', functions)
end

function functions.restore()
    rawset(_ENV, 'functions', __env_functions)
end

return functions:seal()