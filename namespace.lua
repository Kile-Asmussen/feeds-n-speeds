
local namespaces = {}
local paths = {}
local sealed = {}
local parents = {}
local calls = {}

local getmetatable = _ENV.getmetatable
local setmetatable = _ENV.setmetatable

local function isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    return paths[thing] ~= nil
end

local function add_namespace_key(self, name, val)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    assert(not sealed[self], 'namespace ' .. tostring(self) .. ' has been sealed')

    if isnamespace(val) and not parents[val] then
        local oldpath = paths[val]
        local parent = tostring(self)
        parents[val] = self

        if oldpath:sub(1, #parent) ~= parent then
            local newpath = tostring(self) .. '.' .. oldpath
            if namespaces[newpath] then
                error('namespace collission: ' .. newpath, 2)
            end
            namespaces[newpath], namespaces[oldpath] = namespaces[oldpath], nil
            paths[val] = newpath
        end
    end

    return rawset(self, name, val)
end

local function try_lookup(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings')
    return rawget(self, name)
end

local function key_not_found_error(self, name)
    assert(type(name) == 'string', 'namespace keys can only be strings not ' .. tostring(name))
    assert(tostring(self) .. '.' .. name .. ' not found')
end

local function get_namespace_path(self) return paths[self] end

local function require_namespace(self, modname)
    assert(type(modname) == 'string', "argument #1 must be a string")
        
    local name = modname:gsub('[^a-zA-Z0-9]', '_')

    self[name] = require(tostring(self) .. '.' .. modname)
end

local function seal_namespace(ns, recursive)
    assert(isnamespace(ns), "argument #1 must be a namespace, not " .. tostring(ns))

    if sealed[ns] then return ns end

    if ns / 'require' == require_namespace then
        ns.require = nil
    end

    if ns / 'seal' == seal_namespace then
        ns.seal = nil
    end

    sealed[ns] = true
    getmetatable(ns).__metatable = 'namespace'

    if recursive then
        for _, contained in pairs(ns) do
            if isnamespace(contained) and containing_namespace(contained) == ns then
                seal_namespace(contained)
            end
        end
    end

    return ns
end

local function new_namespace(_, path)

    assert(not namespaces[path], 'namespace collision: '.. path)

    local res = {
        require = require_namespace,
        seal = seal_namespace,
    }
    
    paths[res] = path
    namespaces[path] = res

    local mt = {
        __tostring = get_namespace_path,
        __index = key_not_found_error,
        __newindex = add_namespace_key,
        __div = try_lookup,        
    }
    mt.__metatable = mt

    setmetatable(res, mt)

    return res
end 

local function import_namespace(path)
    assert(type(path) == 'string', "namespace paths are strings")
    assert(namespaces[path], "namespace " .. path .. " not loaded, try require '" .. path .. "' first")
    return namespaces[path]
end


local function list_namespaces()
    return table.sorted_keys(namespaces)
end

local namespace = new_namespace(nil, "namespace")

namespace.import = import_namespace
namespace.is = isnamespace
namespace.list = list_namespaces
getmetatable(namespace).__call = new_namespace

-- little shuffle to return namespace.seal
namespace.seal = true
seal_namespace(namespace)

namespace.seal = seal_namespace

return namespace