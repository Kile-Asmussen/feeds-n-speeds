local namespace = require 'namespace'
local fns = namespace 'fns'

local __env_assert = _ENV.assert
local function assert(cond, msg)
    if not cond then error(msg, 3) end
end

_ENV.assert = assert

fns:require 'table'
fns:require 'math'
fns:require 'functions'
fns:require 'string'
fns:require 'utils'

fns.identifiers = fns.table.{}

fns.names_ = fns.table.{}

function fns.name_(name)
    local memo = fns.names_[name]
    if memo then return memo end
    assert(type(name) == 'string', "argument #1 must be a string")
    memo = 'feeds_n_speeds_' .. string.gsub(name, '[^a-zA-Z0-9]', '_')
    fns.names_[name] = memo
    fns.identifiers[memo] = true
    return memo
end

fns.names = fns.table.{}

function fns.name(name)
    local memo = fns.names[name]
    if memo then return memo end
    assert(type(name) == 'string', "argument #1 must be a string")
    memo = 'feeds-n-speeds-' .. string.gsub(name, '[^a-zA-Z0-9]', '-')
    fns.names[name] = memo
    fns.identifiers[memo] = true
    return memo
end

getmetatable(fns).__call = fns.name

fns.extra_localsation_keys = fns.table.{}

function fns.locale_key(category, name)
    fns.extra_localsation_keys[category] = fns.extra_localsation_keys[category] or fns.table.{}
    assert(fns.identifiers[name], "argument #2 must be an established mod identifier")
    fns.extra_localsation_keys[category][name] = true
    return category .. '.' .. name
end

function fns.use()
    fns.string.use()
    fns.functions.use()
    fns.table.use()
end

function fns.restore()
    fns.string.restore()
    fns.functions.restore()
    fns.table.restore()
end

_ENV.assert = __env_assert

return fns:seal()