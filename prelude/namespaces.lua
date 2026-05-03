
local namespaces = {}
local paths = {}
local sealed = {}

local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable

local __rawset = rawset
local function __ns_newindex(self, name, value)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    if isnamespace(value) then
        value.parent_namespace = self
    end
    __rawset(self, name, value)
end

local __rawset = rawset
local function __ns_new_key(self, name, val)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    assert(not sealed[self], 'namespace ' .. tostring(self) .. ' has been sealed')
    return __rawset(self, name, val)
end

local __rawget = rawget
local function __ns_lookup(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    return __rawget(self, name)
end

local function __ns_not_found(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    assert(tostring(self) .. '.' .. name .. ' not found')
end

local function __ns_path(self) return 'namespace:' .. tostring(paths[self]) end

local __ns_mt = {
    __tostring = __ns_path,
    __index = __ns_not_found,
    __newindex = __ns_new_key,
    __div = __ns_lookup,
    __metatable = 'namespace'
}

local print = _G.print
function _G.namespace(path)

    assert(not namespaces[path], 'namespace '.. path .. ' already declared')

    local res = {}
    
    paths[res] = path
    namespaces[path] = res

    setmetatable(res, __ns_mt)

    return res
end 

function _G.import(path)
    assert(type(path) == 'string', "namespace paths are strings")
    assert(namespaces[path], "namespace " .. path .. " not loaded, try require '" .. path .. "' first")
    return namespaces[path]
end

function _G.isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    return paths[thing] ~= nil
end

function _G.seal_namespace(namespace)
    assert(isnamespace(namespace), "cannot seal " .. tostring(namespace) .. " as it is not a namespace")
    sealed[namespace] = true

    return namespace
end