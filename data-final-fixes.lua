require 'prelude'
local debuglib = require 'debuglib'
local tweaks = require 'tweaks'
local extras =  require 'extras'

extras.data_final_fixes()
tweaks.data_final_fixes()

debuglib.recursion_limit = 100

log("\n\n\nDATA_RAW_BEGIN\n\n\n" ..

'return ' .. debuglib.sprint(data.raw)

.. "\n\n\nDATA_RAW_END\n\n\n")