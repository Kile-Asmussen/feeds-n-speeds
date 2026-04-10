require 'prelude'
require 'test-config'

local debuglib = require 'debuglib'
local tweaks = require 'tweaks'

local args = table.new( ... )

local last = args:remove()

if last == nil then
    log(debuglib.sprint(data.raw))
    os.exit(1)
end

local tbl = table.descend(data.raw, args:unpack())
table.new(tbl)

if type(tbl) == 'table' then
    if tbl[last] then
        log(debuglib.sprint(tbl[last]))
        os.exit(0)
    end

    local new = table.new()
    last = last:gsub('%-', '%%-')

    local n = 0
    local value = nil
    for k, v in tbl:pairs() do
        if type(k) == 'string' and k:match(last) then
            n = n + 1
            value = v
            new[k] = v
        end
    end

    if n == 1 and value then
        log(debuglib.sprint(value))
        os.exit(0)
    elseif new:is_hash() then
        log(debuglib.sprint(new))
        os.exit(0)
    end
end

log("Not found: " .. args:concat(' > ') .. ' > ' .. last)
os.exit(1)