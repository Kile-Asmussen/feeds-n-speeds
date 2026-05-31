local help = ...
if help == '--help' then
    print("usage: [DEPTH=n] lua debug/data-modded.lua <category> [<prototype> ...]")
    print("inspect data.raw after loading this mod")
    print("traverses data.raw according to the given path of lua table lookups and pretty-prints the final value reached")
    print("handles integer keys too, for arrays, and use '-' as a wildcard (though it is a bit janky with the printout)")
    print("DEPTH argument determines depth of pretty printing, ")
end


local fns = require 'fns'

fns.use()

require 'test'

_ENV.QUIET = true

_ENV.modlist = {}

require('settings')
fns.use()
data.begin_data_stage()
require('data')
require('data-updates')

fns.use()

local debuglib = require 'debuglib'

fns.gadgets.descend_into_data_raw({ ... }, debuglib.recursion_limit)
