return function(fns)
    fns.table = require("namespace")("table")

    fns.table.insert = _ENV.table.insert
    fns.table.pack = _ENV.table.pack
    fns.table.sort = _ENV.table.sort
    fns.table.remove = _ENV.table.remove
    fns.table.maxn = _ENV.table.maxn
    fns.table.unpack = _ENV.table.unpack
    fns.table.concat = _ENV.table.concat

    fns.table.size = _ENV.table_size or function(tbl) local n=0 for _ in pairs(tbl) do n=n+1 end return n end
    fns.table.pairs = _ENV.pairs
    fns.table.ipairs = _ENV.ipairs
    fns.table.next = _ENV.next
    fns.table.rawset = _ENV.rawset
    fns.table.rawget = _ENV.rawget
    fns.table.setmetatable = _ENV.setmetatable
    fns.table.getmetatable = _ENV.getmetatable

    fns.table:require 'base'
    fns.table:require 'iter'
    fns.table:require 'match'
    fns.table:require 'sets'
    fns.table:require 'traverse'
    fns.table:require 'update'
    fns.table:require 'types'

    fns.table:seal()
end