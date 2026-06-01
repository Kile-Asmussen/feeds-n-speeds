--! data-updates: change water barrels to be unlocked by automation-2, together with the barrel-tapper
local fns = require 'fns'

for _, fl in pairs(data.raw.fluid) do
    local barrel = fl.name .. '-barrel'
    local empty = 'empty-' .. fl.name .. '-barrel'
    barrel = data.raw.recipe[barrel]
    empty = data.raw.recipe[empty]
    if barrel and empty then
        barrel.category = fns 'barrelling'
        barrel.ingredients[1], barrel.ingredients[2] = barrel.ingredients[2], barrel.ingredients[1]
        empty.category = fns 'barrelling'
    end
end

data.raw.recipe['water-barrel'].auto_unlocked_by = 'automation-2'
data.raw.recipe['empty-water-barrel'].auto_unlocked_by = 'automation-2'