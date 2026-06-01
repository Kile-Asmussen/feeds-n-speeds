return function(fns)
    fns.math = require("namespace")("math")

    fns.math.abs = _ENV.math.abs
    fns.math.acos = _ENV.math.acos
    fns.math.asin = _ENV.math.asin
    fns.math.atan = _ENV.math.atan
    fns.math.atan2 = _ENV.math.atan2
    fns.math.ceil = _ENV.math.ceil
    fns.math.cos = _ENV.math.cos
    fns.math.cosh = _ENV.math.cosh
    fns.math.deg = _ENV.math.deg
    fns.math.exp = _ENV.math.exp
    fns.math.floor = _ENV.math.floor
    fns.math.fmod = _ENV.math.fmod
    fns.math.frexp = _ENV.math.frexp
    fns.math.huge = 1.7976931348623157e+308
    fns.math.inf = _ENV.math.huge
    fns.math.ldexp = _ENV.math.ldexp
    fns.math.log = _ENV.math.log
    fns.math.log10 = _ENV.math.log10
    fns.math.max = _ENV.math.max
    fns.math.min = _ENV.math.min
    fns.math.modf = _ENV.math.modf
    fns.math.pi = _ENV.math.pi
    fns.math.pow = _ENV.math.pow
    fns.math.rad = _ENV.math.rad
    fns.math.random = _ENV.math.random
    fns.math.sin = _ENV.math.sin
    fns.math.sinh = _ENV.math.sinh
    fns.math.sqrt = _ENV.math.sqrt
    fns.math.tan = _ENV.math.tan
    fns.math.tanh = _ENV.math.tanh
    fns.math.tiny = 2.2250738585072014e-308
    fns.math.tonumber = _ENV.tonumber

    fns.math:require 'extras'

    fns.math:seal()
end