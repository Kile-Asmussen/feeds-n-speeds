local help = ...
if help == '--help' then
    print("usage: [DEPTH=n] lua debug/data-raw.lua <category> [<prototype> ...]")
    print("inspect data.raw in vanilla factorio")
    print("traverses data.raw according to the given path of lua table lookups and pretty-prints the final value reached")
    print("handles integer keys too, for arrays, and use '-' as a wildcard (though it is a bit janky with the printout)")
end

local fns = require('fns')
local tools = require('test.tools')
local depth = tonumber(os.getenv("DEPTH")) or 2
require 'test'
local debuglib = require 'debuglib'

debuglib.recursion_limit = depth


_ENV.modlist = {"textplates", "even-more-text-plates", "arrowplates"}

_ENV.QUIET = true
begin_data_stage()

tools.descend_into_data_raw({ ... }, debuglib.recursion_limit)