local string_ = require('namespace')('string')

local __env_string = _ENV.string

function string_.use()
    _ENV.string = string_
    getmetatable("").__index = string_
end

function string_.restore()
    _ENV.string = __env_string
    getmetatable("").__index = __env_string
end

string_.use()

string.byte = __env_string.byte
string.char = __env_string.char
string.dump = __env_string.dump
string.find = __env_string.find
string.format = __env_string.format
string.gmatch = __env_string.gmatch
string.gsub = __env_string.gsub
string.len = __env_string.len
string.lower = __env_string.lower
string.match = __env_string.match
string.rep = __env_string.rep
string.reverse = __env_string.reverse
string.sub = __env_string.sub
string.upper = __env_string.upper

-- backports, don't exist in standalone 5.2, probably not needed
string.packsize = __env_string.packsize or function() error("string.packsize is not defined in test", 2) end
string.pack = __env_string.pack or function() error("string.pack is not defined in test", 2) end
string.unpack = __env_string.unpack or function() error("string.unpack is not defined in test", 2) end

require 'fns.string.extras'

return string_:seal()