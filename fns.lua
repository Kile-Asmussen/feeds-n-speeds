local namespace = require 'namespace'
local fns = namespace 'fns'

fns.error = _ENV.error
local error = fns.error

function fns.assert(cond, msg)
    if not cond then error(msg, 3) end
end
local assert = fns.assert

local type = _ENV.type
fns.type = type

fns.select = _ENV.select
fns.print = _ENV.print


fns.tostring = _ENV.tostring
fns:require 'table'
fns:require 'string'
fns:require 'math'
fns:require 'utils'

fns.tostring = nil
fns.identifiers = {}

fns.names_ = {}

function fns.name_(name)
    local memo = fns.names_[name]
    if memo then return memo end
    assert(type(name) == 'string', "fns.name_: argument #1 must be a string")
    memo = 'feeds_n_speeds_' .. name:gsub('[^a-zA-Z0-9]', '_')
    fns.names_[name] = memo
    fns.identifiers[memo] = true
    return memo
end

fns.names = {}

function fns.name(name, _)
    if name == fns then name = _ end
    local memo = fns.names[name]
    if memo then return memo end
    assert(type(name) == 'string', "fns.name: argument #1 must be a string")
    memo = 'feeds-n-speeds-' .. name:gsub('[^a-zA-Z0-9]', '-')
    fns.names[name] = memo
    fns.identifiers[memo] = true
    return memo
end

fns.table.getmetatable(fns).__call = fns.name

fns.extra_localsation_keys = {}
fns.explicit_localisation_keys = {}

function fns.locale_key(category, name)
    if not fns.identifiers[name] then name = fns(name) end
    fns.extra_localsation_keys[category] = fns.extra_localsation_keys[category] or {}
    fns.extra_localsation_keys[category][name] = true
    local res = category .. '.' .. name
    fns.explicit_localisation_keys[res] = true
    return res
end

fns:require 'gadgets'

return fns:seal()