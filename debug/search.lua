local fns = require 'fns'
local table = fns.table
local tools = require 'test.tools'

local debuglib = require 'debuglib'

debuglib.recursion_limit = tonumber(os.getenv("DEPTH")) or 2

require 'test'

_ENV.modlist = {}

_ENV.QUIET = true
begin_data_stage()


if select('#', ...) ~= 3 then
    error("\nusage: lua debug/search.lua <category fragment> <prototype fragment> <field fragment>")
end

local catpat, protpat, fieldpat = ...

if catpat == "--help" then
    print("usage: lua debug/search.lua <fragment> <fragment> <fragment>")
    print("searches data.raw's keys at three levels: prototype category names, prototype names, prototype field names")
    print("fragments are simple text search, not lua search patterns, use '-' to omit searching that level")
    print("example: lua debug/search.lua upgrade - - # finds 'upgrade-item' the prototype category for upgrade planners")
end

local cat, prot, fields = tools.text_search_data_raw(...)

table.sort(cat)
table.sort(prot)
table.sort(fields)

if catpat == '-' and protpat == '-' and fieldpat == '-' then
    error("at least one argument must be not '-'")
end

if #cat >= 1 then
    print("CATEGORIES:")
    for _, v in ipairs(cat) do print('', v) end
end

if #prot >= 1 then
    print("\nPROTOTYPES:")
    for _, v in ipairs(prot) do print('', v) end
end

if #fields >= 1 then
    print("\nFIELDS:")
    for _, v in ipairs(fields) do print('', v) end
end

if #cat == 0 and #prot == 0 and #fields == 0 then
    print("NO RESULTS")
end
