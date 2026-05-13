require 'prelude'

local utilities = require 'extras.utilities'
local concrete = namespace 'tweaks.concrete'

concrete.enabled = true
concrete.dependencies = table.set{ 'tweaks.water' }

function concrete.data()
    data:extend(
        require 'tweaks.concrete.stuff'
    )
end

function concrete.data2()

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
    end

    table.insert(tech['oil-processing'].prerequisites, 'concrete')
    table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')

    tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }
end

function concrete.data_updates()
    concrete.adjust_tiles()
    concrete.flooring()

    if enabled('extras.barrelling') then
        utilities.remove_unlock('water-barrel')
        utilities.remove_unlock('empty-water-barrel')

        table.append(data.raw.technology['automation-2'].effects, {
            { type='unlock-recipe', recipe='water-barrel' },
            { type='unlock-recipe', recipe='empty-water-barrel' },
        })
    end
end

local tier1 = fns('basic_pavement', '_')
local tier2 = fns('sturdy_pavement', '_')
local tier2h = fns('sturdy_pavement_hazard', '_')
local tier3 = fns('foundation_pavement', '_')
local tier3h = fns('foundation_pavement_hazard', '_')


function concrete.adjust_tiles()

    for _, item in ipairs{'stone-brick', 'concrete', 'hazard-concrete', 'refined-concrete', 'refined-hazard-concrete'} do
        data.raw.item[item].localised_description = {fns_locale_key("item-description", item)}
    end

    for _, tile in pairs(data.raw.tile) do

        if tile.name:match('stone%-path') then
            tile.walking_speed_modifier = 1.3
            tile.collision_mask.layers[tier1] = true
        end

        if tile.name:match('concrete') then
            tile.walking_speed_modifier = 1.5
            tile.collision_mask.layers[tier1] = true
            tile.collision_mask.layers[tier2] = true
            tile.collision_mask.layers[tier2h] = tile.name:match('hazard') and true or nil

            if tile.name:match('hazard') then
                tile.walking_speed_modifier = 1.0
            end

            if tile.name:match('refined') then
                tile.walking_speed_modifier = 2.0
                tile.collision_mask.layers[tier3] = true
                tile.collision_mask.layers[tier3h] = tile.name:match('hazard') and true or nil

                if tile.name:match('hazard') then
                    tile.walking_speed_modifier = 1.0
                end

            end
        end
    end

    data.raw.tile['space-platform-foundation'].collision_mask.layers = {
        [tier1] = true,
        [tier2] = true,
        [tier3] = true,
        [tier2h] = true,
        [tier3h] = true,
        ground_tile = true,
    }
    data.raw.tile['foundation'].collision_mask.layers = {
        [tier1] = true,
        [tier2] = true,
        ground_tile = true,
    }
end

return seal_namespace(concrete)