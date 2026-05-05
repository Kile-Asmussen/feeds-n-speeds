require 'prelude'

local concrete = namespace 'tweaks.concrete'

concrete.enabled = true

function concrete.data()
    if not concrete.enabled then return end

    data:extend{
        require 'tweaks.concrete.simple-concrete',
    }
    data:extend(
        require 'tweaks.concrete.collision-layers'
    )
end

function concrete.data2()

    if not concrete.enabled then return end

    local recipes = data.raw.recipe
    local tech = data.raw.technology


    recipes.concrete.category = 'chemistry'
    recipes.concrete.ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    recipes['refined-concrete'].category = 'chemistry'
    recipes['refined-concrete'].ingredients = {
        { type = 'item', name = 'concrete', amount = 20 },
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    table.append(tech.concrete.effects, {
        { type = 'unlock-recipe', recipe = 'chemical-plant' },
        { type = 'unlock-recipe', recipe = fns 'simple-concrete' },
    })

    tech.concrete.prerequisites = { 'fluid-handling', 'advanced-material-processing' }
    
    table.remove_matching(tech['oil-processing'].effects,
        table.matches{ type = 'unlock-recipe', recipe = 'chemical-plant'}
    )
    
    table.insert(tech['oil-processing'].prerequisites, 'concrete')
    table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')
end

function concrete.data_updates()
    for _, tile in pairs(data.raw.tile) do

        if tile.name:match('stone%-path') then
            tile.walking_speed_modifier = 1.3
            tile.collision_mask.feeds_n_speeds_basic_pavement = true
        end

        if tile.name:match('concrete') then
            tile.walking_speed_modifier = 1.5
            tile.collision_mask.feeds_n_speeds_sturdy_pavement = true

            if tile.name:match('refined') then
                tile.walking_speed_modifier = 2.0
                tile.collision_mask.feeds_n_speeds_sturdy_pavement = true
            end
        end

        if tile.name:match('hazard') then
            tile.walking_speed_modifier = 1
            tile.collision_mask.feeds_n_speeds_hazard_marking = true
        end

    end
end

return seal_namespace(concrete)