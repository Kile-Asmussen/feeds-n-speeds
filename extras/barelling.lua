require 'prelude'

local barelling = namespace 'extras.barelling'
barelling.enabled = true

function barelling.data()
    data:extend(
        require 'extras.barelling.tap'
    )
end

function barelling.data2()
    table.insert(data.raw.technology['fluid-handling'].effects, {
        type='unlock-recipe', recipe=fns 'barrel-tapper'
    })
end

function barelling.data_updates()
    for _, fl in pairs(data.raw.fluid) do
        local barrel = fl.name .. '-barrel'
        local empty = 'empty-' .. fl.name .. '-barrel'
        barrel = data.raw.recipe[barrel]
        empty = data.raw.recipe[empty]
        if barrel and empty then
            barrel.category = fns'barelling'
            empty.category = fns'barelling'
        end
    end
end

return seal_namespace(barelling)