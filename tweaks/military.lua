require 'prelude'

local military = namespace 'tweaks.military'
military.enabled = true

function military.data()
    data:extend{
        {
            type='recipe-category',
            name=fns 'hand-crafting'
        }
    }

    if enabled('tweaks.malltech') then
        data:extend(require 'tweaks.military.guns')
    end
end

function military.data_updates()
    if not military.enabled then return end

    table.insert(data.raw.character.character.crafting_categories, fns 'hand-crafting')

    local recipe = data.raw.recipe

    table.insert(recipe['gate'].ingredients, { type='item', name='iron-gear-wheel', amount=2})

    military.guns()
    military.turrets()
    military.ammo()
    military.technologies()
end

function military.guns()
    local recipes = data.raw.recipe

    recipes.pistol.enabled = true
    recipes.pistol.hidden = false
    recipes.shotgun.enabled = true
    recipes.shotgun.ingredients = {
        { type='item', name='iron-plate', amount=5 },
        { type='item', name='copper-plate', amount=5 },
        { type='item', name='wood', amount=5 },
    }
    recipes.shotgun.category = fns 'hand-crafting'
    recipes.pistol.category = fns 'hand-crafting'
    recipes['shotgun-shell'].enabled = true

    if enabled('tweaks.malltech') then

        recipes['submachine-gun'].ingredients = {
            { type='item', name='copper-plate', amount=2 },
            { type='item', name='iron-plate', amount=4 },
            { type='item', name='iron-gear-wheel', amount=4 },
            { type='item', name='wood', amount=2 },
        }

        if enabled('extras.heavy-weapons') then
            recipes['combat-shotgun'].ingredients = {
                { type='item', name='copper-plate', amount=4 },
                { type='item', name='iron-plate', amount=4 },
                { type='item', name='iron-gear-wheel', amount=4 },
                { type='item', name='wood', amount=2 },
            }
        end

    else
        recipes['submachine-gun'].ingredients = {
            { type='item', name='copper-plate', amount=5 },
            { type='item', name='iron-plate', amount=15 },
            { type='item', name='iron-gear-wheel', amount=10 },
            { type='item', name='wood', amount=5 },
        }

        recipes['combat-shotgun'].ingredients = {
            { type='item', name='copper-plate', amount=10 },
            { type='item', name='iron-plate', amount=15 },
            { type='item', name='iron-gear-wheel', amount=10 },
            { type='item', name='wood', amount=5 },
        }
    end

    recipes[fns'submachine-gun-plastic-stock'].ingredients = table.clone(recipes['submachine-gun'].ingredients)
    recipes[fns'combat-shotgun-plastic-stock'].ingredients = table.clone(recipes['combat-shotgun'].ingredients)
    table.find_matching(recipes[fns'submachine-gun-plastic-stock'].ingredients, table.matches{name='wood'}).name = 'plastic-bar'
    table.find_matching(recipes[fns'combat-shotgun-plastic-stock'].ingredients, table.matches{name='wood'}).name = 'plastic-bar'

end

function military.turrets()
    local recipes = data.raw.recipe

    if enabled('tweaks.malltech') then

        recipes['gun-turret'].ingredients = {
            { type='item', name='electronic-circuit', amount=8 },
            { type='item', name='iron-plate', amount=4 },
            { type='item', name='submachine-gun', amount=2 },
            { type='item', name='iron-gear-wheel', amount=8 },
        }

        if enabled('extras.heavy-weapons') then
            recipes[fns 'shotgun-turret'].ingredients = {
                { type='item', name='electronic-circuit', amount=8 },
                { type='item', name='iron-plate', amount=4 },
                { type='item', name='combat-shotgun', amount=2 },
                { type='item', name='iron-gear-wheel', amount=8 },
            }
        end

    end


    
    local flamer_fluids = {
        {
            type='crude-oil',
            damage_modifier=0.5
        },
        {
            type='heavy-oil',
            damage_modifier=1.0
        },
        {
            type='light-oil',
            damage_modifier=0.9
        }
    }

    if enabled('extras.heavy-weapons') then
        table.insert(flamer_fluids, { type=fns'napalm', damage_modifier = 1.35 })
    end

    data.raw['fluid-turret']['flamethrower-turret'].attack_parameters.fluids = flamer_fluids

end

function military.ammo()
    local recipes = data.raw.recipe

    recipes['shotgun-shell'].energy_required = 4
    recipes['shotgun-shell'].results[1].amount = 4
    recipes['firearm-magazine'].energy_required = 2
    recipes['firearm-magazine'].results[1].amount = 2

    if
        enabled('extras.ores', 'extras.drills', 'tweaks.earlygame')
    then
        recipes['firearm-magazine'].ingredients = {
            { type = 'item', name = 'iron-plate', amount = 2 },
            { type = 'item', name = 'copper-plate', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }

        recipes['piercing-rounds-magazine'].ingredients = {
            { type = 'item', name = 'steel-plate', amount = 1 },
            { type = 'item', name = 'firearm-magazine', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }

        recipes['shotgun-shell'].ingredients = {
            { type = 'item', name = 'copper-plate', amount = 2 },
            { type = 'item', name = 'iron-plate', amount = 2 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 2 },
        }

        recipes['piercing-shotgun-shell'].ingredients = {
            { type = 'item', name = 'shotgun-shell', amount = 2 },
            { type = 'item', name = 'steel-plate', amount = 1 },
            { type = 'item', name = 'sulfur', amount = 1 },
            { type = 'item', name = 'coal', amount = 1 },
        }

        recipes['grenade'].ingredients = {
            { type = 'item', name = 'steel-plate', amount = 1 },
            { type = 'item', name = 'sulfur', amount = 5 },
            { type = 'item', name = 'coal', amount = 5 },
        }
    end
end

function military.technologies()
    local tech = data.raw.technology

    table.insert(tech['gun-turret'].prerequisites, 'military')

    -- Other turrets depend on gun turret
    table.insert(tech['laser-turret'].prerequisites, 'gun-turret')
    table.insert(tech['flamethrower'].prerequisites, 'gun-turret')
    table.insert(tech['artillery'].prerequisites, 'gun-turret')
    table.insert(tech['rocket-turret'].prerequisites, 'gun-turret')
    table.insert(tech['tesla-weapons'].prerequisites, 'gun-turret')

    tech['military'].effects = {
        { type='unlock-recipe', recipe='submachine-gun' },
        { type='unlock-recipe', recipe='combat-shotgun' },
    }

    if enabled('extras.heavy-weapons') then

        tech['flammables'].effects = {
            { type='unlock-recipe', recipe='flamethrower' },
            { type='unlock-recipe', recipe='flamethrower-ammo' }
        }
        tech['flammables'].localised_description = {"", { fns 'technology-description', 'flammables' }}

        tech['flamethrower'].effects = {
            { type='unlock-recipe', recipe='flamethrower-turret' },
            { type='unlock-recipe', recipe=fns 'napalm' },
            { type='unlock-recipe', recipe=fns 'flamethrower-ammo' },
        }
        tech['flamethrower'].localised_name = {"", { fns 'technology-description', 'flamethrower' }}
        tech['flamethrower'].localised_description = {"", { fns 'technology-description', 'flamethrower' }}


        tech['flamethrower'].prerequisites = {
           'flammables', 'plastics', 'advanced-oil-processing'
        }
        tech['flamethrower'].unit = {
            count = 50,
            ingredients = {
                {'automation-science', 1},
                {'logistic-science', 1},
                {'chemical-science', 1},
                {'military-science', 1},
            },
            time = 30
        }

        tech['refined-flammables-1'].prerequisites = { 'flammables' }
    end

    tech['military-2'].effects = {
        { type='unlock-recipe', recipe='piercing-shotgun-shell' },
        { type='unlock-recipe', recipe='piercing-rounds-magazine' },
        { type='unlock-recipe', recipe='grenade' },
    }

    tech['military-3'].prerequisites = { 'explosives', 'military-science-pack', 'chemical-science-pack' }

    tech['military-3'].effects = {
        { type='unlock-recipe', recipe='cluster-grenades' },
        { type='unlock-recipe', recipe='slowdown-capsule' },
        { type='unlock-recipe', recipe='poison-capsule' },
    }

    tech['military-4'].prerequisites = { 'utility-science-pack', 'military-3' }
    
    if enabled('extras.altrecipes') then
        tech['military-4'].effects = {

        }
    else
        tech['military-4'].effects = { }
        tech['military-4'].unit.count = 100
    end

end

return military:__seal()