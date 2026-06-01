--! data: changes to oil recipes
local fns = require 'fns'
local table = fns.table

for _, rec in ipairs{
    'heavy-oil-cracking',
    'light-oil-cracking',
    'advanced-oil-processing',
} do
    rec = data.raw.recipe[rec]
    if rec then
        table.find(
            rec.ingredients,
            table.match{type='fluid',name='water'}
        ).name='steam'
    end
end