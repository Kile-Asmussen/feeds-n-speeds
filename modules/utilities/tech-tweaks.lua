--! data: general technology localisation, prerequisite, and cost tweaks — does not touch technologies modified elsewhere
local fns = require 'fns'

local lk = fns.locale_key

fns.table.merge(data.raw.technology, {
    __rec = true,
})
