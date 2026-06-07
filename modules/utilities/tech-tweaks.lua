--! data: general technology localisation, prerequisite, and cost tweaks — does not touch technologies modified elsewhere
local fns = require 'fns'

local function find_pack(name)
    local res = nil
    for pack, _ in pairs(data.raw.tool) do
        if pack:find(name, 1, true) then
            if res then error("Ambiguous science pack abbreviation: " .. name, 2) end
            res = pack
        end
    end
    return res
end

local function cost(time, count, ...)
    local ingredients = { ... }
    for i = 1, #ingredients do
        assert(type(ingredients[i]) == 'string', "science pack abbreviations must be strings")
        ingredients[i] = { find_pack(ingredients[i]), 1 }
    end
    return fns.table.assign{ 'unit', val = { count = count, time = time, ingredients = ingredients, }}
end

local lk = fns.locale_key

fns.table.merge(data.raw.technology, {
    __strict = true,
    ['circuit-network'] = cost(15, 30, 'auto', 'log'),
    ['advanced-material-processing'] = cost(30, 50, 'auto', 'log'),
})
