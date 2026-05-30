--! data: changes to oil recipes

for _, rec in ipairs{
    'heavy-oil-cracking',
    'light-oil-cracking',
    'advanced-oil-processing',
} do
    rec = data.raw.recipe[rec]
    if rec then
        table.find_matching(
            rec.ingredients,
            {type='fluid',name='water'}
        ).name='steam'
    end
end