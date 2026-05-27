
local math_ = require("namespace")("math")

local __env_math = math

function math_.use()
    _ENV.math = math_
end

function math_.restore()
    _ENV.math = __env_math
end

math_.use()

math.abs = __env_math.abs
math.acos = __env_math.acos
math.asin = __env_math.asin
math.atan = __env_math.atan
math.atan2 = __env_math.atan2
math.ceil = __env_math.ceil
math.cos = __env_math.cos
math.cosh = __env_math.cosh
math.deg = __env_math.deg
math.exp = __env_math.exp
math.floor = __env_math.floor
math.fmod = __env_math.fmod
math.frexp = __env_math.frexp
math.huge = 1.7976931348623157e+308
math.inf = __env_math.huge
math.ldexp = __env_math.ldexp
math.log = __env_math.log
math.log10 = __env_math.log10
math.max = __env_math.max
math.min = __env_math.min
math.modf = __env_math.modf
math.pi = __env_math.pi
math.pow = __env_math.pow
math.rad = __env_math.rad
math.random = __env_math.random
math.sin = __env_math.sin
math.sinh = __env_math.sinh
math.sqrt = __env_math.sqrt
math.tan = __env_math.tan
math.tanh = __env_math.tanh
math.tiny = 2.2250738585072014e-308

require 'fns.math.extras'

_ENV.math = __env_math

return math_:seal()