require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'
require 'prelude.functions'

_G.TESTING = false

function _G.enabled(...)

    local res = true

    for _, v in ipairs(table.pack(...)) do
        res = res and import(v)/'enabled'
    end

    return res
end

function _G.array(tbl)
    tbl = tbl or {}
    assert(type(tbl) == 'table' and table.is_array(tbl), "non-array table passed to array")
    return tbl
end

function _G.assoc(tbl)
    tbl = tbl or {}
    assert(type(tbl) == 'table' and table.is_assoc(tbl), "non-assoc table passed to array")
    return tbl
end

_G.asset = asset
_G.module = nil
