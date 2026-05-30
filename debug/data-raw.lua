local fns = require 'fns'

fns.use()


local debuglib = require 'debuglib'

debuglib.recursion_limit = tonumber(os.getenv("DEPTH")) or 2

require 'test'

rawset(_ENV, 'modlist', {"textplates", "even-more-text-plates", "arrowplates"})

_ENV.QUIET = true
data.begin_data_stage()

fns.gadgets.descend_into_data_raw({ ... }, debuglib.recursion_limit)