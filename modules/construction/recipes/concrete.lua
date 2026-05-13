
local recipes = data.raw.recipe
local tech = data.raw.technology

recipes.concrete.ingredients = {
    { type = 'item', name = 'stone-brick', amount = 5 },
    { type = 'item', name = 'iron-stick', amount = 2 },
    { type = 'fluid', name = 'water', amount = 100 },
}
recipes.concrete.category = 'chemistry'

recipes['refined-concrete'].ingredients = {
    { type = 'item', name = 'concrete', amount = 20 },
    { type = 'item', name = 'steel-plate', amount = 1 },
    { type = 'fluid', name = 'water', amount = 100 },
}
recipes['refined-concrete'].category = 'chemistry'

if not enabled('tweaks.water') then

    utilities.remove_unlock 'chemical-plant'

    table.insert(tech.concrete.effects, { type = 'unlock-recipe', recipe = 'chemical-plant' })
    
end

if enabled('extras.barrelling') then
    utilities.remove_unlock(fns 'barrel-tapper')

    table.append(tech['automation-2'].effects, {
        { type='unlock-recipe', recipe='barrel' },
        { type='unlock-recipe', recipe=fns 'barrel-tapper' },
        { type='unlock-recipe', recipe=fns 'simple-concrete' },
        { type='unlock-recipe', recipe=fns 'mechanical-concrete' },
    })
else

    table.insert(tech.concrete.effects, { type = 'unlock-recipe', recipe = fns 'simple-concrete' })
    table.insert(tech.concrete.effects, { type = 'unlock-recipe', recipe = fns 'mechanical-concrete' })

    tech['concrete'].unit.count = 40
    tech['automation-2'].unit.count = 75
    tech['fluid-handling'].prerequisites = { 'engine', }
    tech['automation-2'].prerequisites = { 'concrete', 'fast-inserter', 'automation' }

table.insert(tech['oil-processing'].prerequisites, 'concrete')
table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')

tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }