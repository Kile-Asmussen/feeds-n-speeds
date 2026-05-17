
local sulfur_processing = namespace 'tweaks.sulfur-processing'

sulfur_processing.enabled = true

function sulfur_processing.data()
    if not sulfur_processing.enabled then return end

    data:extend{
        require 'tweaks.sulfur-processing.purifying-oil-processing-recipe',
        require 'tweaks.sulfur-processing.purifying-advanced-oil-processing-recipe',
        require 'tweaks.sulfur-processing.purifying-heavy-oil-cracking-recipe',
    }
end

function sulfur_processing.data2()
    if not sulfur_processing.enabled then return end

    -- Modify sulfuric acid recipe: steel plate catalyst (80% return chance)
    local sulfuric_acid = data.raw.recipe['sulfuric-acid']

    table.find_matching(sulfuric_acid.ingredients,
        table.matches{ name = 'iron-plate' }
    ).name = 'steel-plate'

    table.insert(sulfuric_acid.results, {
        type = 'item',
        name = 'steel-plate',
        amount = 1,
        probability = 0.8,  -- 80% chance to return, 20% consumed
    })

    sulfuric_acid.main_product = 'sulfuric-acid'

    -- Modify sulfur recipe: coal washing process
    local sulfur = data.raw.recipe['sulfur']

    sulfur.ingredients = {
        { type = 'fluid', name = 'petroleum-gas', amount = 30 },
        { type = 'item', name = 'coal', amount = 5 },
        { type = 'fluid', name = 'water', amount = 50 },
    }

    sulfur.results = {
        { type = 'item', name = 'coal', amount = 4 },
        { type = 'item', name = 'sulfur', amount = 1 },
    }

    sulfur.emissions_multiplier = 1.5  -- 50% extra pollution
    
    sulfur.main_product = 'sulfur'

    -- Coal liquefaction has 20% chance to produce sulfur
    table.insert(data.raw.recipe['coal-liquefaction'].results, {
        type = 'item',
        name = 'sulfur',
        amount = 1,
        probability = 0.2,
    })

    -- Add purifying oil processing to sulfur-processing technology
    table.insert(
        data.raw.technology['sulfur-processing'].effects,
        { type = 'unlock-recipe', recipe = fns 'purifying-oil-processing' }
    )

    -- Add purifying advanced oil processing to advanced-oil-processing technology
    table.insert(
        data.raw.technology['advanced-oil-processing'].effects,
        { type = 'unlock-recipe', recipe = fns 'purifying-advanced-oil-processing' }
    )
    table.insert(
        data.raw.technology['advanced-oil-processing'].effects,
        { type = 'unlock-recipe', recipe = fns 'purifying-heavy-oil-cracking' }
    )

    data.raw.recipe['explosives'].ingredients = {
        { type='item', name='solid-fuel', amount=2},
        { type='fluid', name='sulfuric-acid', amount=20},
    }
end

return seal_namespace(sulfur_processing)
