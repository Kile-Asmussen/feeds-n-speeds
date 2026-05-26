
local table_ = require("namespace")("table")

table_.insert = table.insert
table_.pack = table.pack
table_.sort = table.sort
table_.remove = table.remove
table_.maxn = table.maxn
table_.unpack = table.unpack
table_.concat = table.concat

table_.size = _ENV.table_size or function(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k = next(tbl)
    local n = 0
    while k do
        n = n + 1
        k = next(tbl, k)
    end
    return n
end

local __env_table = _ENV.table
local __env = {
    opairs = _ENV.opairs,
    asset = _ENV.asset,
    array = _ENV.array,
    assoc = _ENV.assoc
}

function table_.use()
    _ENV.table = table_
    rawset(_ENV, 'opairs', table_.opairs)
    rawset(_ENV, 'asset', table_.asset)
    rawset(_ENV, 'array', table_.array)
    rawset(_ENV, 'assoc', table_.assoc)
end

function table_.restore()
    _ENV.table = __env_table
    rawset(_ENV, 'opairs', __env.opairs)
    rawset(_ENV, 'asset', __env.asset)
    rawset(_ENV, 'array', __env.array)
    rawset(_ENV, 'assoc', __env.assoc)
end

_ENV.table = table_

function table.is_empty(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return not next(tbl)
end

require 'fns.table.array'
require 'fns.table.assoc'
require 'fns.table.iter'
require 'fns.table.match'
require 'fns.table.sets'
require 'fns.table.traverse'
require 'fns.table.update'
require 'fns.table.vectors'

_ENV.table = __env_table

return table_:seal()