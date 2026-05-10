
local namespaces = {}
local paths = {}
local sealed = {}
local parents = {}

local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable

local rawset = rawset
local rawget = rawget

local function __ns_new_key(self, name, val)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    assert(not sealed[self], 'namespace ' .. tostring(self) .. ' has been sealed')

    if isnamespace(val) and not parents[val] then
        local oldpath = paths[val]
        local parent = tostring(self)
        parents[val] = self

        if oldpath:sub(1, #parent) ~= parent then
            local newpath = tostring(self) .. '.' .. oldpath
            if namespaces[newpath] then
                error('namespace collission: ' .. newpath)
            end
            namespaces[newpath], namespaces[oldpath] = namespaces[oldpath], nil
            paths[val] = newpath
        end
    end

    return rawset(self, name, val)
end

local function __ns_lookup(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    return rawget(self, name)
end

local function __ns_not_found(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    assert(tostring(self) .. '.' .. name .. ' not found')
end

local function __ns_path(self) return paths[self] end

local __ns_mt = {
    __tostring = __ns_path,
    __index = __ns_not_found,
    __newindex = __ns_new_key,
    __div = __ns_lookup,
    __metatable = 'namespace'
}

local function namespace(path)

    assert(not namespaces[path], 'namespace collision: '.. path)

    local res = {
        require = _G.require_namespace,
        seal = _G.seal_namespace,
    }
    
    paths[res] = path
    namespaces[path] = res

    setmetatable(res, __ns_mt)

    return res
end 

local function require_namespace(self, modname)
    assert(type(modname) == 'string', "argument #1 must be a string")
        
    name = modname:gsub('[^a-zA-Z0-9]', '_')

    self[name] = require(tostring(self) .. '.' .. modname)
end

local function import(path)
    assert(type(path) == 'string', "namespace paths are strings")
    assert(namespaces[path], "namespace " .. path .. " not loaded, try require '" .. path .. "' first")
    return namespaces[path]
end

local function isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    return paths[thing] ~= nil
end

local function seal_namespace(ns, recursive)
    assert(isnamespace(ns), "argument #1 must be a namespace, not " .. tostring(ns))
    if ns / 'require' == require_namespace then
        ns.require = nil
    end
    if ns / 'seal' == seal_namespace then
        ns.seal = nil
    end

    sealed[ns] = true

    if recursive then
        for _, contained in pairs(ns) do
            if isnamespace(contained) and containing_namespace(contained) == ns then
                seal_namespace(contained)
            end
        end
    end

    return ns
end

local function containing_namespace(ns)
    assert(isnamespace(ns), "argument #1 must be a namespace, not " .. tostring(ns))
    return parents[ns]
end

local function list_namespaces()
    return table.sorted_keys(namespaces)
end

_G.namespace = namespace
_G.isnamespace = isnamespace
_G.seal_namespace = seal_namespace
_G.import = import
_G.require_namespace = require_namespace
_G.containing_namespace = containing_namespace