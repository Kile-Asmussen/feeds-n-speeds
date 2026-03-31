require 'prelude.table'
require 'prelude.string'

function namespace(table, name)
    if name = nil and type(table) == 'string' then
        table, name = _G, table
    end
    table[name] = rawget(table, name) or {
        namespace = _G.namespace
    }
    setmetatable(table[name], _G.__namespace_mt)
end

__namespace_mt = {
    __index = function(table, name) error((table.__namespace_name or 'global ') .. name .. ' not found') end
}

setmetatable(
    _G,
    __namespace_mt
)