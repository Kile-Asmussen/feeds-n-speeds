require 'prelude'
require 'test-config'

local debuglib = require 'debuglib'
local tweaks = require 'tweaks'

local args = table.new( ... )

if #args == 0 then
    log("No arguments given")
    os.exit(1)
end

local last = args:remove()

local tbl = table.descend(data.raw, args:unpack())
table.new(tbl)

if type(tbl) == 'table' then
    if tbl[last] then
        log(debuglib.sprint(tbl[last]))
        os.exit(0)
    end

    local new = table.new()
    last = last:gsub('%-', '%%-')

    for k, v in tbl:pairs() do
        if type(k) == 'string' and k:match(last) then
            new[k] = v
        end
    end

    if new:is_hash() then
        log(debuglib.sprint(new))
        os.exit(0)
    end
end

log("Not found: " .. args:concat(' > ') .. ' > ' .. last)
os.exit(1)