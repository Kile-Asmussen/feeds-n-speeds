require 'prelude'

local tools = require 'tools'

for _, fl in pairs(data.raw.fluid) do
    if fl.auto_barrel then
        local barrel = fl.name .. '-barrel'
        local empty = 'empty-' .. fl.name .. '-barrel'
        barrel = data.raw.recipe[barrel]
        empty = data.raw.recipe[empty]
        if barrel and empty then
            barrel.category = fns'barrelling'
            empty.category = fns'barrelling'
        end
    end
end

tools.remove_unlock('water-barrel')
tools.remove_unlock('empty-water-barrel')

table.append(data.raw.technology['automation-2'].effects, {
    { type='unlock-recipe', recipe='water-barrel' },
    { type='unlock-recipe', recipe='empty-water-barrel' },
})