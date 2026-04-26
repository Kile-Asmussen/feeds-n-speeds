require 'prelude.table'
require 'prelude.string'

local declared_namespaces = {}
local mod_identifiers = {}
local mod_identifier_categories = {}

local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable

function _G.enabled(...)

    local res = true

    for _, v in ipairs(table.pack(...)) do
        res = res and import(v)('enabled')
    end

    return res

end

function _G.fns(category, name)
    if name == nil then
        name = category
        category = ''
    else
        assert(type(category) == 'string', "invalid category: " .. tostring(category))
    end
    
    assert(type(name) == 'string', "invalid name: " .. tostring(name))
    name, _ = string.gsub(name, '[^a-zA-Z0-9]', '-')

    name = 'feeds-n-speeds-' .. name

    mod_identifiers[name] = true

    if #category > 0 then
        mod_identifier_categories[category] = mod_identifier_categories[category] or {}
        mod_identifier_categories[category][name] = true
        category, _ = string.gsub(category, '[^a-zA-Z0-9]', '-')
        name = category .. '.' .. name
    end

    return name
end

function _G.fns_names_by_category(cat)
    if cat == nil then 
        return table.clone(mod_identifier_categories)
    end
    return table.sorted_keys(mod_identifier_categories[cat] or {})
end

function _G.import(path)
    assert(type(path) == 'string', "namespace names are strings")
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

local function __seal(self)
    self.__seal = nil
    getmetatable(self).__newindex = __sealed_newindex
    getmetatable(self).__metatable = 'namespace'
    assert(isnamespace(self), "you bungled the isnamespace function you doofus")
    return self
end

function _G.isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    
    if getmetatable(thing) == 'namespace' then return true end
    
    local mt = getmetatable(thing)

    if
        type(mt) == 'table'
        and getmetatable(mt) == nil
        and mt.__metatable == mt
        and mt.__newindex == __ns_newindex
        and mt.__index == __ns_index
        and thing.__seal == __seal
    then
        return true
    end

    return false
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

function _G.namespace(path)

    assert(not declared_namespaces[path], 'namespace '.. path .. ' already declared')

    local res = {}
    
    res.parent_namespace = table.null
    res.__seal = __seal
    
    setmetatable(res, __ns_mt(path))

    declared_namespaces[path] = res

    return res
end
