
require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'
require 'prelude.functions'


function _G.enabled(...)

    local res = true

    for _, v in ipairs(table.pack(...)) do
        res = res and import(v)/'enabled'
    end

    return res
end

_G.array = table.array
_G.assoc = table.assoc
_G.asset = table.asset
_G.module = nil
