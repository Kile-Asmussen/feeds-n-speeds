require 'prelude'

require 'test.data'
require 'test.defines'
require 'test.utils'
require 'test.script'

setmetatable(_G, {
    __index = function(_, name) error('global ' .. name .. ' not found') end
})

function log(str) print(str) end
