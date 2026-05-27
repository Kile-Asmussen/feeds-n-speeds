
local table_ = require("namespace")("table")

local assert = _ENV.assert

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

function table_.use()
    _ENV.table = table_
end

function table_.restore()
    _ENV.table = __env_table
end

table_.use()

function table.twoarg(func)
    return function(tbl1, tbl2)
        assert(type(tbl1) == "table", "argument #1 must be a table")
        if tbl2 == nil then
            return function(tbl2)
                assert(type(tbl2) == "table", "argument #1 must be a table")
                return func(tbl1, tbl2)
            end
        else
            assert(type(tbl2) == "table", "argument #2 must be a table")
            return func(tbl1, tbl2)
        end
    end
end

function table.is_empty(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return not next(tbl)
end

table.size = _ENV.table_size or function(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k = next(tbl)
    local n = 0
    while k do
        n = n + 1
        k = next(tbl, k)
    end
    return n
end

require 'fns.table.iter'
require 'fns.table.match'
require 'fns.table.sets'
require 'fns.table.traverse'
require 'fns.table.update'
require 'fns.table.types'

return table_:seal()