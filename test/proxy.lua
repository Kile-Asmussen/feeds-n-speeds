local proxy = require('namespace')('proxy')
local fns = require 'fns'
local utils = fns.utils

local function __proxy_mt_newindex(tbl, key, val)
    tbl.__real[key] = val
    local newpath = {}
    table.append(newpath, tbl.__path)
    table.insert(newpath, key)
    local fullpath = utils.tablepath(tbl.__rootname, newpath)
    table.cut(newpath, tbl.__maxdepth)
    local path = utils.tablepath(tbl.__rootname, newpath)
    tbl.__hook(not tbl.__changes[path], path, fullpath, val)
    tbl.__changes[path] = true
end

local function __proxy_mt_index(tbl, name)
    local val = tbl.__real[name]
    if type(val) == 'table' then
        local newpath = {}
        table.append(newpath, tbl.__path)
        table.insert(newpath, name)
        return proxy.makeproxy{
            tbl=val,
            rootname=tbl.__rootname,
            path=newpath,
            changes=tbl.__changes,
            hook=tbl.__hook,
            maxdepth=tbl.__maxdepth
        }
    else
        return val
    end
end

local function __proxy_next(tbl, k)
    local k = next(tbl.__real, k)
    return k, tbl[k]
end

local function __proxy_mt_pairs(tbl)
    return __proxy_next, tbl, nil
end

local function __proxy_incr(tbl, i)
    if i < #tbl.__real then
        i = i + 1
        return i, tbl.__real[i]
    end
end

local function __proxy_mt_ipairs(tbl)
    return __proxy_incr, tbl, 0
end

local function __proxy_mt_len(tbl)
    return #tbl.__real
end

local function __proxy_mt_tostring(tbl)
    return utils.tablepath(tbl.__rootname, tbl.__path) .. '=' .. tostring(tbl.__real)
end

local __proxy_mt = {
    __newindex = __proxy_mt_newindex,
    __index = __proxy_mt_index,

    __pairs = __proxy_mt_pairs,

    __ipairs = __proxy_mt_ipairs,

    __len = __proxy_mt_len,
    __tostring = __proxy_mt_tostring,
}

__proxy_mt.__metatable = __proxy_mt

local function monkeypatch()
    local next = _ENV.next
    function _ENV.next(tbl, k)
        if getmetatable(tbl) == __proxy_mt then
            return next(tbl.__real, k)
        else
            return next(tbl, k)
        end
    end

    local unpack = table.unpack
    function table.unpack(tbl)
        if getmetatable(tbl) == __proxy_mt then
            return unpack(tbl.__real)
        else
            return unpack(tbl) 
        end
    end

    local concat = table.concat
    function table.concat(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return concat(tbl.__real, ...)
        else
            return concat(tbl, ...) 
        end
    end

    local sort = table.sort
    function table.sort(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return sort(tbl.__real, ...)
        else
            return sort(tbl, ...) 
        end
    end

    local maxn = table.maxn
    function table.maxn(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return maxn(tbl.__real, ...)
        else
            return maxn(tbl, ...) 
        end
    end

    local insert = table.insert
    function table.insert(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return insert(tbl.__real, ...)
        else
            return insert(tbl, ...) 
        end
    end

    local remove = table.remove
        function table.remove(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return remove(tbl.__real, ...)
        else
            return remove(tbl, ...) 
        end
    end
    monkeypatch = function() end
end


function proxy.makeproxy(args)
    assert(type(args) == "table", "table.proxy expects a table with up to six keys: tbl, [rootname, path, hook, changes, maxdepth]")
    assert(type(args.tbl) == "table", "table.proxy mandatory key tbl must be a table")
    monkeypatch()
    args.rootname = args.rootname or tostring(args.tbl)
    args.root = args.root or args.tbl
    args.path = args.path or {}
    args.hook = args.hook or function() end
    args.changes = args.changes or {}
    args.maxdepth = args.maxdepth or 1000

    assert(type(args.path) == "table",
        "table.proxy key path must be a table")

    assert(type(args.changes) == "table",
        "table.proxy key changes must be a table")

    assert(type(args.hook) == "function",
        "table.proxy key hook must be a function")

    assert(type(args.maxdepth) == "number",
        "table.proxy key maxdepth must be a number")

    local res = {
        __real = args.tbl,
        __rootname = args.rootname,
        __path = args.path,
        __hook = args.hook,
        __changes = args.changes,
        __maxdepth = args.maxdepth
    }
    setmetatable(res, __proxy_mt)
    return res
end

function proxy.is_proxied(tbl)
    return getmetatable(tbl) == __proxy_mt
end

function proxy.unmakeproxy(tbl)
    if proxy.is_proxied(tbl) then return tbl.__real else return tbl end
end

getmetatable(proxy).__call = proxy.makeproxy

return proxy:seal()