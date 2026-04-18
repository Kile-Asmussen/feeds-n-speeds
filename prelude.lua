require 'prelude.table'
require 'prelude.string'

local declared_namespaces = {}

local mod_identifiers = {}

local function fns(name)
    assert(type(name) == 'string', "invalid name: " .. tostring(name))
    name, _ = string.gsub(name, '[^a-zA-Z0-9]', '-')
    local res = 'feeds-n-speeds-' .. name
    mod_identifiers[res] = true
    return res
end

local function fnsidentifiers()
    return table.sorted_keys(mod_identifiers)
end

local function import(path)
    assert(declared_namespaces[path], 'no such namespace ' .. path)
    return declared_namespaces[path]
end

local function __sealed_newindex(self)
    error(tostring(self) .. ' has been sealed')
end

local function __ns_index(self, name)
    assert(tostring(self) .. '.' .. name .. ' not found')
end

local __rawset = rawset

local function __ns_newindex(self, name, value)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    if isnamespace(value) then
        value.parent_namespace = self
    end
    __rawset(self, name, value)
end

local __getmetatable = getmetatable

local function isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    if __getmetatable(thing) == 'namespace' then return true end
    if type(__getmetatable(thing) ~= 'table') then return false end
    if __getmetatable(thing).__metatable == __getmetatable(thing) then return false end
    return false
end

local function __seal(self)
    self.__seal = nil
    __getmetatable(self).__newindex = __sealed_newindex
    __getmetatable(self).__metatable = 'namespace'
    assert(isnamespace(self), "you bungled the isnamespac function you doofus")
    return self
end

local __rawget = rawget
local function __ns_call(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    return __rawget(self, name)
end

local function __ns_mt(path) 
    local res = {
        __tostring = function() return path end,
        __index = __ns_index,
        __newindex = __ns_newindex,
        __call = __ns_call
    }

    res.__metatable = res

    return res
end

local __setmetatable = setmetatable

local function namespace(path, res)

    assert(not declared_namespaces[path], 'namespace '.. path .. ' already declared')

    res = res or {}
    
    res.parent_namespace = table.null
    res.__seal = __seal
    
    __setmetatable(res, __ns_mt(path))

    declared_namespaces[path] = res

    return res
end

_G.fns = fns
_G.fnsidentifiers = fnsidentifiers
_G.import = import
_G.isnamespace = isnamespace
_G.namespace = namespace