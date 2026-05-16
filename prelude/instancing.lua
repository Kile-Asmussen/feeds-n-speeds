
local __pairs = pairs
local __type = type
local __rawget = rawget
local __rawset = rawset
local __print = print

-- because Factorio doesn't instance mods, we have to do it here

local _FNS = {}

for _, k in ipairs{
  -- standard library
  'assert', 'bit32', 'collectgarbage', 'coroutine', 'debug',
  'dofile', 'error', 'getmetatable', 'io', 'ipairs', 'load',
  'loadfile', 'loadstring', 'math', 'module', 'next', 'os',
  'package', 'pairs', 'pcall', 'print', 'rawequal', 'rawget',
  'rawlen', 'rawset', 'require', 'select', 'setmetatable',
  'string', 'table', 'tonumber', 'tostring', 'type', 'unpack',
  'xpcall',
  -- tables
  'string', 'debug', 'os', 'math', 'io', 'bit32', 'table', 'package',
  -- factorio
  'data', 'remote', 'settings', 'mods', 'script', 'defines', "log",
} do
  _FNS[k] = _ENV[k]
end

_FNS.string = string and {
  byte = string.byte,
  char = string.char,
  dump = string.dump,
  find = string.find,
  format = string.format,
  gmatch = string.gmatch,
  gsub = string.gsub,
  len = string.len,
  lower = string.lower,
  match = string.match,
  rep = string.rep,
  reverse = string.reverse,
  sub = string.sub,
  upper = string.upper,
  -- backports, don't exist in standalone 5.2, will be provided in 
  -- test.lua at some point if I need them
  packsize = string.packsize,
  pack = string.pack,
  pack = string.pack,
}

_FNS.debug = debug and {
  setlocal = debug.setlocal,
  setupvalue = debug.setupvalue,
  getupvalue = debug.getupvalue,
  getuservalue = debug.getuservalue,
  setmetatable = debug.setmetatable,
  traceback = debug.traceback,
  gethook = debug.gethook,
  debug = debug.debug,
  sethook = debug.sethook,
  upvalueid = debug.upvalueid,
  getregistry = debug.getregistry,
  getlocal = debug.getlocal,
  getmetatable = debug.getmetatable,
  getinfo = debug.getinfo,
  upvaluejoin = debug.upvaluejoin,
  setuservalue = debug.setuservalue,
}

-- kept for debug/test purposes
_FNS.os = os and {
  date = os.date,
  clock = os.clock,
  time = os.time,
  rename = os.rename,
  tmpname = os.tmpname,
  exit = os.exit,
  setlocale = os.setlocale,
  difftime = os.difftime,
  remove = os.remove,
  getenv = os.getenv,
  execute = os.execute,
}

_FNS.math = math and {
  acos = math.acos,
  sin = math.sin,
  abs = math.abs,
  frexp = math.frexp,
  huge = math.huge,
  pi = math.pi,
  log10 = math.log10,
  atan = math.atan,
  tan = math.tan,
  deg = math.deg,
  tanh = math.tanh,
  sqrt = math.sqrt,
  sinh = math.sinh,
  randomseed = math.randomseed,
  rad = math.rad,
  max = math.max,
  fmod = math.fmod,
  random = math.random,
  ceil = math.ceil,
  ldexp = math.ldexp,
  floor = math.floor,
  pow = math.pow,
  min = math.min,
  exp = math.exp,
  cosh = math.cosh,
  log = math.log,
  atan2 = math.atan2,
  cos = math.cos,
  asin = math.asin,
  modf = math.modf,
}

_FNS.bit32 = bit32 and {
  arshift = bit32.arshift,
  bnot = bit32.bnot,
  bor = bit32.bor,
  band = bit32.band,
  rshift = bit32.rshift,
  btest = bit32.btest,
  lrotate = bit32.lrotate,
  bxor = bit32.bxor,
  replace = bit32.replace,
  lshift = bit32.lshift,
  rrotate = bit32.rrotate,
  extract = bit32.extract,
}

-- kept for test/debuglib stuff for my standalone stuff
_FNS.io = io and {
  input = io.input,
  open = io.open,
  tmpfile = io.tmpfile,
  lines = io.lines,
  stderr = io.stderr,
  close = io.close,
  stdin = io.stdin,
  stdout = io.stdout,
  flush = io.flush,
  read = io.read,
  write = io.write,
  type = io.type,
  popen = io.popen,
  output = io.output,
}

_FNS.table = table and {
  insert = table.insert,
  pack = table.pack,
  sort = table.sort,
  remove = table.remove,
  maxn = table.maxn,
  unpack = table.unpack,
  concat = table.concat,
}

_FNS.package = package and {
  loadlib = package.loadlib,
  cpath = package.cpath,
  seeall = package.seeall,
  searchers = package.searchers,
  path = package.path,
  config = package.config,
  preload = package.preload,
  loaded = package.loaded,
  searchpath = package.searchpath,
  loaders = package.loaders,
}

_ENV._G = nil

local function replace_contents(dst, src, rec)
  local ind = rec and "" or "  "

  for k, replacement in __pairs(src) do 
    if __type(__rawget(dst, k)) == 'table' and __type(replacement) == 'table' and rec then
      replace_contents(dst[k], replacement, false)
    else
      __rawset(dst, k, replacement)
    end
  end

  for k, _ in __pairs(dst) do
    if __rawget(src, k) == nil then
      __rawset(dst, k, nil)
    end
  end
end

local _FNS_BACKUP = {}
local _FNS_IS_INSTANCED = false

function _FNS.fns_instance()
  if _FNS_IS_INSTANCED then return end
  replace_contents(_FNS_BACKUP, _ENV, true)
  replace_contents(_ENV, _FNS, true)
  _FNS_IS_INSTANCED = true
end

_ENV.fns_instance = _FNS.fns_instance

function _FNS.fns_restore()
  if not _FNS_IS_INSTANCED then return end
  replace_contents(_FNS, _ENV, true)
  replace_contents(_ENV, _FNS_BACKUP, true)
  _FNS_IS_INSTANCED = false
end

_ENV.fns_restore = _FNS.fns_restore