require 'prelude'

local barelling = namespace 'extras.barelling'
barelling.enabled = true

function barelling.data()
    data:extend(
        require 'extras.barelling.tap'
    )

    for _, asm in pairs(data.raw['assembling-machine']) do
        if table.index_of(asm.crafting_categories, 'crafting-with-fluid') then
            table.insert(asm.crafting_categories, fns 'barelling')
        end
    end
end

function barelling.data2()
    table.insert(data.raw.technology['fluid-handling'].effects, {
        type='unlock-recipe', recipe=fns 'barrel-tapper'
    })
end

function barelling.data_updates()
    for _, fl in pairs(data.raw.fluid) do
        data.raw.recipe[fl .. '-barrel'].category = fns 'barelling'
        data.raw.recipe['empty-' .. fl .. '-barrel'].category = fns 'barelling'
    end
end