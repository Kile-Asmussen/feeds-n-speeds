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

    local recipes = data.raw.recipe

    table.insert(recipes['gate'].ingredients, { type='item', name='iron-gear-wheel', amount=2})

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
    recipes['light-armor'].category = fns 'hand-crafting'
    recipes['shotgun-shell'].enabled = true

    data.raw.gun.pistol.attack_parameters.cooldown = 20
    data.raw.gun.pistol.attack_parameters.damage_modifier = 1.5
    
    data.raw.gun.shotgun.attack_parameters.cooldown = 100
    data.raw.gun.shotgun.attack_parameters.damage_modifier = 1.5
    data.raw.gun.shotgun.attack_parameters.movement_slow_down_factor = 0.3

    data.raw.gun['submachine-gun'].attack_parameters.cooldown = 10
    data.raw.gun['submachine-gun'].attack_parameters.movement_slow_down_factor = 0.4
    data.raw.gun['submachine-gun'].attack_parameters.damage_modifier = 1.2

    data.raw.gun['combat-shotgun'].attack_parameters.cooldown = 50
    data.raw.gun['combat-shotgun'].attack_parameters.damage_modifier = 1.2
    data.raw.gun['combat-shotgun'].attack_parameters.movement_slow_down_factor = 0.5

    recipes['flamethrower'].ingredients = {
        { type='item', name='pipe', amount=1 },
        { type='item', name='engine-unit', amount=1 },
        { type='item', name='iron-gear-wheel', amount=5 },
        { type='item', name='barrel', amount=1 },
    }

    if enabled('tweaks.malltech') then

        recipes['submachine-gun'].ingredients = {
            { type='item', name='copper-plate', amount=2 },
            { type='item', name='iron-plate', amount=4 },
            { type='item', name='iron-gear-wheel', amount=4 },
            { type='item', name='steel-plate', amount=1 },
            { type='item', name='wood', amount=2 },
        }

        if enabled('extras.heavy') then
            recipes['combat-shotgun'].ingredients = {
                { type='item', name='copper-plate', amount=4 },
                { type='item', name='iron-plate', amount=4 },
                { type='item', name='iron-gear-wheel', amount=4 },
                { type='item', name='wood', amount=2 },
                { type='item', name='steel-plate', amount=1 },
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


    recipes['railgun'].ingredients = {
        { type='item', name='tungsten-plate', amount = 10 },
        { type='item', name='carbon-fiber', amount = 10 },
        { type='item', name='supercapacitor', amount = 10 },
        { type='item', name='copper-plate', amount = 10 },
    }

end

function military.turrets()
    local recipes = data.raw.recipe

    if enabled('tweaks.malltech') then

        recipes['gun-turret'].ingredients = {
            { type='item', name='electronic-circuit', amount=8 },
            { type='item', name='steel-plate', amount=4 },
            { type='item', name='submachine-gun', amount=2 },
            { type='item', name='iron-gear-wheel', amount=8 },
            { type='item', name='stone-brick', amount=10 },
        }
        data.raw['ammo-turret']['gun-turret'].max_health = 800

        if enabled('extras.heavy') then
            recipes[fns 'shotgun-turret'].ingredients = {
                { type='item', name='electronic-circuit', amount=8 },
                { type='item', name='steel-plate', amount=4 },
                { type='item', name='combat-shotgun', amount=2 },
                { type='item', name='iron-gear-wheel', amount=8 },
                { type='item', name='stone-brick', amount=10 },
            }
            data.raw['ammo-turret'][fns 'shotgun-turret'].max_health = 900
        end

        recipes['flamethrower-turret'].ingredients = {
            { type='item', name='pump', amount=5 },
            { type='item', name='pipe', amount=10 },
            { type='item', name='flamethrower', amount=1 },
            { type='item', name='steel-plate', amount=20 },
            { type='item', name='iron-gear-wheel', amount=20 },
            { type='item', name='electronic-circuit', amount=30 },
            { type='item', name='hazard-concrete', amount=10 },
        }

        recipes['laser-turret'].ingredients = {
            { type='item', name='steel-plate', amount=10 },
            { type='item', name='battery', amount=10 },
            { type='item', name='advanced-circuit', amount=5 },
            { type='item', name='electric-engine-unit', amount=2 },
            { type='item', name='small-lamp', amount=10 },
        }

        table.append(recipes['tesla-turret'].ingredients, {
            { type='item', name='plastic-bar', amount=50 },
            { type='item', name='hazard-concrete', amount=30 },
        } )

        recipes['artillery-turret'].ingredients = {
            { type='item', name='electric-engine-unit', amount = 20 },
            { type='item', name='quality-module-2', amount = 5 },
            { type='item', name='refined-hazard-concrete', amount = 100 },
            { type='item', name='steel-plate', amount = 100 },
            { type='item', name='radar', amount = 30 },
            { type='item', name='tungsten-plate', amount = 30 },
        }

        recipes['rocket-turret'].ingredients = {
            { type='item', name='hazard-concrete', amount = 10 },
            { type='item', name='electric-engine-unit', amount = 4 },
            { type='item', name='steel-plate', amount = 20 },
            { type='item', name='processing-unit', amount = 4 },
            { type='item', name='carbon-fiber', amount = 20 },
            { type='item', name='rocket-launcher', amount = 4 },
        }
        data.raw['ammo-turret']['rocket-turret'].max_health = 1000

        recipes['railgun-turret'].ingredients = {
            { type='item', name='electric-engine-unit', amount = 30 },
            { type='item', name='heat-pipe', amount = 20 },
            { type='item', name='tungsten-plate', amount = 60 },
            { type='item', name='superconductor', amount = 50 },
            { type='item', name='carbon-fiber', amount = 50 },
            { type='item', name='speed-module-3', amount = 5 },
            { type='item', name='refined-hazard-concrete', amount= 100 },
        }

    else
        data.raw['electric-turret']['tesla-turret'].max_health = 600 
    end

    data.raw['ammo-turret']['rocket-turret'].attack_parameters.cooldown = 40
    data.raw['ammo-turret']['rocket-turret'].attack_parameters.min_range = 15
    data.raw['ammo-turret']['rocket-turret'].attack_parameters.range = 40
    data.raw['ammo-turret']['railgun-turret'].attack_parameters.range = 50
    
    data.raw['ammo-turret']['railgun-turret'].max_health = 800
    data.raw['electric-turret']['laser-turret'].max_health = 600

    if enabled('extras.heavy') then
        data.raw['fluid-turret']['flamethrower-turret'].attack_parameters.fluids = {
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
            },
            { type=fns'napalm', damage_modifier = 1.35 }
        }
    end


end

function military.ammo()
    local recipes = data.raw.recipe

    capsule['grenade']

    recipes['shotgun-shell'].energy_required = 4
    recipes['shotgun-shell'].results[1].amount = 2
    recipes['piercing-shotgun-shell'].results[1].amount = 2
    recipes['firearm-magazine'].energy_required = 2
    recipes['firearm-magazine'].results[1].amount = 2

    if enabled('extras.radars') then
        recipes['artillery-shell'].ingredients = {
            { type = 'item', name = 'explosives', amount = 10 },
            { type = 'item', name = 'steel-plate', amount = 2 },
            { type = 'item', name = fns'small-radar', amount = 1 },
        }
    else
        recipes['artillery-shell'].ingredients = {
            { type = 'item', name = 'explosives', amount = 10 },
            { type = 'item', name = 'steel-plate', amount = 2 },
            { type = 'item', name = 'radar', amount = 1 },
        }
    end

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

    recipes['flamethrower-ammo'].ingredients = {
        { type = 'fluid', name = 'crude-oil', amount = 100 },
        { type = 'item', name = 'barrel', amount = 1 },
    }

    recipes['slowdown-capsule'].category = 'crafting-with-fluid'
    recipes['slowdown-capsule'].ingredients = {
        { type = 'item', name = 'sulfur', amount = 5 },
        { type = 'item', name = 'copper-cable', amount = 5 },
        { type = 'fluid', name = 'crude-oil', amount = 50 },
        { type = 'item', name = 'grenade', amount = 1 },
    }

    recipes['poison-capsule'].category = 'crafting-with-fluid'
    recipes['poison-capsule'].ingredients = {
        { type = 'item', name = 'solid-fuel', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 5 },
        { type = 'fluid', name = 'sulfuric-acid', amount = 50 },
        { type = 'item', name = 'grenade', amount = 1 },
    }   

    recipes['defender-capsule'].ingredients = {
        { type = 'item', name = 'solid-fuel', amount = 1 },
        { type = 'item', name = 'iron-gear-wheel', amount = 3 },
        { type = 'item', name = 'piercing-rounds-magazine', amount = 3 },
        { type = 'item', name = 'electronic-circuit', amount = 3 },
    }

    recipes['distractor-capsule'].ingredients = {
        { type = 'item', name = 'solid-fuel', amount = 3 },
        { type = 'item', name = 'iron-gear-wheel', amount = 3 },
        { type = 'item', name = 'advanced-circuit', amount = 1 },
        { type = 'item', name = 'battery', amount = 5 },
    }

    recipes['destroyer-capsule'].ingredients = {
        { type = 'item', name = 'rocket-fuel', amount = 1 },
        { type = 'item', name = 'iron-gear-wheel', amount = 5 },
        { type = 'item', name = 'advanced-circuit', amount = 5 },
        { type = 'item', name = 'copper-cable', amount = 10 },
        { type = 'item', name = 'battery', amount = 10 },
    }

    recipes['rocket'].ingredients = {
        { type = 'item', name = 'rocket-fuel', amount = 1 },
        { type = 'item', name = 'explosives', amount = 1 },
        { type = 'item', name = 'steel-plate', amount = 1 },
        { type = 'item', name = 'electronic-circuit', amount = 3 },
    }

    recipes['explosive-rocket'].ingredients = {
        { type = 'item', name = 'rocket-fuel', amount = 2 },
        { type = 'item', name = 'explosives', amount = 5 },
        { type = 'item', name = 'steel-plate', amount = 2 },
        { type = 'item', name = 'electronic-circuit', amount = 3 },
    }

    recipes['railgun-ammo'].ingredients = {
        { type = 'item', name = 'copper-cable', amount = 10 },
        { type = 'item', name = 'tungsten-carbide', amount = 1 },
        { type = 'item', name = 'steel-plate', amount = 5 },
    }
end

function military.projectiles()
    local rocket = data.raw.projectile.rocket 
    rocket.acceleration = 0.02
    local eff = rocket.action.action_delivery.target_effects
    table.find_matching(eff, table.matches{type='damage'}).damage.amount = 250


    local ex = data.raw.projectile['explosive-rocket']
    ex.acceleration = 0.02
    
    local ex_eff = data.raw.projectile['explosive-rocket']
        .action.action_delivery.target_effects

    table.find_matching(ex_eff, table.matches{type='damage'}).damage.amount = 100
    local nest = table.find_matching(ex_eff, table.matches{type='nested-result'})

    local nest_eff = nest.action.action_delivery.target_effects

    table.find_matching(nest_eff, table.matches{type='damage'}).damage.amount = 250
end

function military.technologies()
    local tech = data.raw.technology

    table.insert(tech['gun-turret'].prerequisites, 'military')

    -- Other turrets depend on gun turret
    table.insert(tech['laser-turret'].prerequisites, 'gun-turret')
    table.insert(tech['flamethrower'].prerequisites, 'gun-turret')
    table.insert(tech['artillery'].prerequisites, 'gun-turret')
    table.insert(tech['rocket-turret'].prerequisites, 'gun-turret')
    table.insert(tech['railgun'].prerequisites, 'gun-turret')
    table.insert(tech['tesla-weapons'].prerequisites, 'gun-turret')

    if enabled('tweaks.malltech') then
        table.insert(tech['laser-turret'].prerequisites, 'electric-engine')
    end

    tech['military'].effects = {
        { type='unlock-recipe', recipe='submachine-gun' },
        { type='unlock-recipe', recipe='combat-shotgun' },
    }

    tech['rocketry'].prerequisites = {
        'rocket-fuel',
        'explosives',
        'military-science-pack'
    }

    table.insert(tech['rocket-silo'].prerequisites, 'rocketry')

    if enabled('extras.heavy') then

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
           'flammables', 'advanced-oil-processing', 'military-science-pack'
        }
        tech['flamethrower'].unit = {
            count = 50,
            ingredients = {
                {'automation-science-pack', 1},
                {'logistic-science-pack', 1},
                {'chemical-science-pack', 1},
                {'military-science-pack', 1},
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

    tech['defender'].prerequisites = {
        'military-science-pack', 'robotics'
    }

    tech['military-3'].prerequisites = { 'explosives', 'plastics', 'military-science-pack', 'advanced-oil-processing' }

    tech['military-3'].effects = {
        { type='unlock-recipe', recipe='cluster-grenade' },
        { type='unlock-recipe', recipe='slowdown-capsule' },
        { type='unlock-recipe', recipe='poison-capsule' },
        { type='unlock-recipe', recipe=fns'submachine-gun-plastic-stock' },
        { type='unlock-recipe', recipe=fns'combat-shotgun-plastic-stock' },
    }

    if enabled('extras.altrecipes') then
        tech['military-4'].prerequisites = { 'utility-science-pack', 'military-3' }
        local altrecipes = require 'extras.altrecipes'
        tech['military-4'].localised_description = {"", { fns_locale_key('technology-description', 'military-4-mass-production') }}
        tech['military-4'].effects = table.icollect(require('extras.altrecipes.ammo'),
            function(t) return { type='unlock-recipe', recipe=t.name } end
        )
    else
        tech['military-4'].unit.count = 50
    end

    tech['discharge-defense-equipment'].prerequisites = {
        'military-3', 'solar-panel-equipment', 'power-armor', 'energy-shield-equipment'
    }

    tech['railgun'].prerequisites = {
        'metallurgic-science-pack', 
        'electromagnetic-science-pack', 
        'carbon-fiber', 
    }
    tech['railgun'].unit.ingredients = table.icollect(
        { 'automation', 'logistic', 'chemical', 'production', 'utility', 'agricultural', 'metallurgic', 'electromagnetic' },
        function(s) return { s..'-science-pack', 1 } end
    )

    tech['railgun-shooting-speed-1'].unit.ingredients = table.clone(tech['railgun'].unit.ingredients)
    tech['railgun-damage-1'].unit.ingredients = table.clone(tech['railgun'].unit.ingredients)

    fns_locale_key("modifier-description", "rocket-turret-attack-bonus")

    table.insert(tech['stronger-explosives-5'].effects,
        { type='turret-attack', modifier = 0.4, turret_id = 'rocket-turret' }
    )

    table.insert(tech['stronger-explosives-6'].prerequisites, 'planet-discovery-gleba')

    table.insert(tech['stronger-explosives-6'].effects,
        { type='turret-attack', modifier = 0.5, turret_id = 'rocket-turret' }
    )

    table.insert(tech['stronger-explosives-7'].effects,
        { type='turret-attack', modifier = 0.5, turret_id = 'rocket-turret' }
    )
end

return seal_namespace(military)