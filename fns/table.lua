
local table_ = require("namespace")("table")

table_.insert = table.insert
table_.pack = table.pack
table_.sort = table.sort
table_.remove = table.remove
table_.maxn = table.maxn
table_.unpack = table.unpack
table_.concat = table.concat

table_.size = _ENV.table_size or function(tbl) 
    local n = 0 for _ in pairs(tbl) do n = n + 1 end return n
end

local __env_table = _ENV.table
function table_.use()
    _ENV.table = table_
end

function table_.restore()
    _ENV.table = __env_table
end

table_.use()

require 'fns.table.update'
require 'fns.table.iter'

table_.restore()

return table_:seal()