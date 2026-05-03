require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'

_G.TESTING = false

function _G.enabled(...)

    local res = true

    for _, v in ipairs(table.pack(...)) do
        res = res and import(v)/'enabled'
    end

    return res
end
