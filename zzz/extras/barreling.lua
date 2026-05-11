require 'prelude'

local barreling = namespace 'extras.barreling'
barreling.enabled = true

function barreling.data()
    data:extend(
        require 'extras.barreling.tap'
    )
end

function barreling.data2()
    table.insert(data.raw.technology['fluid-handling'].effects, {
        type='unlock-recipe', recipe=fns 'barrel-tapper'
    })
end

function barreling.data_updates()
    for _, fl in pairs(data.raw.fluid) do
        local barrel = fl.name .. '-barrel'
        local empty = 'empty-' .. fl.name .. '-barrel'
        barrel = data.raw.recipe[barrel]
        empty = data.raw.recipe[empty]
        if barrel and empty then
            barrel.category = fns'barreling'
            empty.category = fns'barreling'
        end
    end
end

return seal_namespace(barreling)