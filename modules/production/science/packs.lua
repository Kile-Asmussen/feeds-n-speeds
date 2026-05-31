--! data: change recipes for all science packs
local tech = data.raw.technology
local recipes = data.raw.recipe

tech['automation-science-pack'].research_trigger = {
    type = 'build-entity',
    entity = 'lab'
}

table.append(tech['logistic-science-pack'].prerequisites, {'logistics', 'automation', 'lamp'})
table.append(tech['chemical-science-pack'].prerequisites, {'automation-2'})
table.append(tech['military-science-pack'].prerequisites, {'automation-2', 'oil-gathering'})
table.append(tech['utility-science-pack'].prerequisites, {'automation-2'})
table.append(tech['production-science-pack'].prerequisites, {'automation-2', 'electric-energy-distribution-2'})
table.remove_matching(tech['production-science-pack'].prerequisites, 'advanced-material-processing-2')

recipes['automation-science-pack'].ingredients = {
    { type = 'item', name = 'iron-plate', amount = 2 },
    { type = 'item', name = 'copper-plate', amount = 2 },
    { type = 'item', name = 'stone-brick', amount = 1 },
}

recipes['logistic-science-pack'].ingredients = {
    { type = 'item', name = 'inserter', amount = 1 },
    { type = 'item', name = 'transport-belt', amount = 1 },
    { type = 'item', name = 'small-lamp', amount = 1 },
}

recipes['chemical-science-pack'].category = 'crafting-with-fluid'
recipes['chemical-science-pack'].ingredients = {
    { type = 'item', name = 'engine-unit', amount = 2 },
    { type = 'item', name = 'advanced-circuit', amount = 3 },
    { type = 'item', name = 'concrete', amount = 10 },
    { type = 'fluid', name = 'sulfuric-acid', amount = 10 },
}

recipes['military-science-pack'].category = 'crafting-with-fluid'
recipes['military-science-pack'].ingredients = {
    { type = 'item', name = 'piercing-rounds-magazine', amount = 1 },
    { type = 'item', name = 'grenade', amount = 1 },
    { type = 'item', name = 'stone-wall', amount = 2 },
    { type = 'fluid', name = 'crude-oil', amount = 10 },
}

recipes['production-science-pack'].category = 'crafting-with-fluid'
recipes['production-science-pack'].ingredients = {
    { type = 'item', name = 'rail', amount = 40 },
    { type = 'item', name = 'substation', amount = 1 },
    { type = 'item', name = 'productivity-module', amount = 1 },
    { type = 'fluid', name = 'steam', amount = 200 },
}

recipes['utility-science-pack'].emissions_multiplier = 1.5
recipes['utility-science-pack'].category = 'crafting-with-fluid'
table.insert(recipes['utility-science-pack'].ingredients,
    { type = 'fluid', name = 'water', amount = 1000 }
)
