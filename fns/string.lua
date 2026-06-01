return function(fns)

    fns.string = require('namespace')('string')

    fns.string.tostring = _ENV.tostring
    fns.string.byte = _ENV.string.byte
    fns.string.char = _ENV.string.char
    fns.string.dump = _ENV.string.dump
    fns.string.find = _ENV.string.find
    fns.string.format = _ENV.string.format
    fns.string.gmatch = _ENV.string.gmatch
    fns.string.gsub = _ENV.string.gsub
    fns.string.len = _ENV.string.len
    fns.string.lower = _ENV.string.lower
    fns.string.match = _ENV.string.match
    fns.string.rep = _ENV.string.rep
    fns.string.reverse = _ENV.string.reverse
    fns.string.sub = _ENV.string.sub
    fns.string.upper = _ENV.string.upper

    fns.string.packsize = _ENV.string.packsize
    fns.string.pack = _ENV.string.pack
    fns.string.unpack = _ENV.string.unpack

    fns.string:require 'extras'

    fns.string.metatable = { __index = fns.string }

    fns.table.setmetatable(fns.table.getmetatable("").__index, fns.string.metatable)

    fns.string.icon = false
    fns.string.icon_size = false

    fns.string:seal()
end