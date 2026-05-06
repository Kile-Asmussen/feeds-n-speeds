require 'prelude'

local utilities = require 'extras.utilities'
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
    concrete.adjust_tiles()
    concrete.flooring()
end

local tier1 = fns('basic_pavement', '_')
local tier2 = fns('sturdy_pavement', '_')
local tier2h = fns('sturdy_pavement_hazard', '_')
local tier3 = fns('foundation_pavement', '_')
local tier3h = fns('foundation_pavement_hazard', '_')

local strings = {
    [tier1] = 'simple-machinery',
    [tier2] = 'machinery',
    [tier2h] = 'dangerous-machinery',
    [tier3] = 'heavy-machinery',
    [tier3h] = 'dangerous-heavy-machinery',
}

function concrete.adjust_tiles()

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

local function search_radius(n)
    n = n or 0
    return function(ent)
        local rad = ent.resource_searching_radius
        return { { -rad - 1 - n, -rad - 1 - n}, { rad + 1 + n, rad + 1 + n} }
    end
end

local function plus(n)
    return function(ent)
        local aabb = ent.collision_box
        return { table.vecsum(aabb[1], { -n, -n }), table.vecsum(aabb[2], { n, n }) }
    end
end

local function radius(ent)
    return table.clone(ent.collision_box)
end

concrete.needs_paving = {
    ['assembling-machine'] = {
        ['assembling-machine-1'] = { tier1 },
        ['assembling-machine-2'] = { tier2 },
        ['assembling-machine-3'] = { tier2h, r=plus(1) },
        ['chemical-plant'] = { tier1 },
        ['oil-refinery'] = { tier2, r=plus(1) },
        ['biochamber'] = { tier1 },
        ['centrifuge'] = { tier2h, r=plus(2) },
        ['cryogenic-plant'] = { tier3, r=plus(2) },
        ['electromagnetic-plant'] = { tier3, r=plus(2) },
        ['foundry'] = { tier2, r=plus(2) },
        ['captive-biter-spawner'] = { no = true }
    },

    ['mining-drill'] = {
        ['burner-mining-drill'] = { no = true, r=search_radius(1) },
        [fns 'burner-mining-drill-fluid'] = { no = true, r=search_radius(1) },
        ['electric-mining-drill'] = { no = true, r=search_radius() },
        [fns 'electric-mining-drill-fluid'] = { no = true, r=search_radius() },
        ['big-mining-drill'] = { no = true, r=search_radius() },
        ['pumpjack'] = { no = true, r=plus(1) }
    },

    ['lab'] = {
        ['lab'] = { tier1 },
        ['biolab'] = { no = true },
    },

    ['agricultural-tower'] = {
        ['agricultural-tower'] = { tier1 }
    },

    ['furnace'] = {
        ['steel-furnace'] = { tier1 },
        ['electric-furnace'] = { tier2 },
        ['recycler'] = { tier2h, r=plus(1) },
    },

    ['boiler'] = {
        ['boiler'] = { tier1 },
        [fns 'electroboiler'] = { tier1 },
        ['heat-exchanger'] = { tier2h, r=plus(1) },
    },

    ['reactor'] = {
        ['nuclear-reactor'] = { tier3h, r=plus(2) },
    },

    ['fusion-reactor'] = {
        ['fusion-reactor'] = { tier3h, r=plus(2) }
    },

    ['fusion-generator'] = {
        ['fusion-generator'] = { tier3h, r=plus(2) }
    },

    ['generator'] = {
        ['steam-engine'] = { tier1 },
        ['steam-turbine'] = { tier2, r=plus(1) },
    },

    ['inserter'] = {
        ['long-handed-inserter'] = { tier1 },
        ['fast-inserter'] = { tier1 },
        ['bulk-inserter'] = { tier2 },
        ['stack-inserter'] = { tier2h },
    },

    ['electric-pole'] = {
        ['substation'] = { tier2h }
    },

    ['container'] = {
        [fns 'big-steel-chest'] = { tier1 }
    },

    ['proxy-container'] = {
        [fns 'big-steel-hopper'] = { tier1 }
    },

    ['logistic-container'] = {
        ['storage-chest'] = { tier1 },
        ['passive-provider-chest'] = { tier1 },
        ['active-provider-chest'] = { tier2h },
        ['requester-chest'] = { tier2 },
        ['buffer-chest'] = { tier2 },
    },

    ['roboport'] = {
        ['roboport'] = { tier2, r=plus(1) },
        [fns 'logistics-roboport'] = { tier3h, r=plus(1) },
        [fns 'sleeper-roboport'] = { tier2, r=plus(1) },
        [fns 'construction-roboport'] = { tier1, r=plus(1) },
    },

    ['accumulator'] = {
        ['accumulator'] = { tier2h },
    },

    ['arithmetic-combinator'] = {
        ['arithmetic-combinator'] = { tier1 },
    },

    ['decider-combinator'] = {
        ['decider-combinator'] = { tier1 },
    },

    ['selector-combinator'] = {
        ['selector-combinator'] = { tier2 },
    },

    ['lightning-attractor'] = {
        ['lightning-collector'] = { tier2h },
    },

    ['rocket-silo'] = {
        ['rocket-silo'] = { tier3h, r=plus(3) }
    },

    ['cargo-landing-pad'] = {
        ['cargo-landing-pad'] = { tier3h, r=plus(3) }
    },

    ['cargo-bay'] = {
        ['cargo-bay'] = { tier3, r=plus(1) }
    },

    ['beacon'] = {
        ['beacon'] = { tier2h, r=plus(1) }
    }
}

function concrete.flooring()

    for proto, entities in pairs(concrete.needs_paving) do
        for ent, val in pairs(entities) do
            val = table.clone(val)
            local entity = data.raw[proto][ent]
            assert(entity, "no such entity data.raw." .. proto .. "." .. ent)

            if #val == 0 then
                table.insert(val, 'ground_tile')
            end

            entity.tile_buildability_rules = {
                {
                    area = (val.r or radius)(entity),
                    required_tiles = {
                        layers = table.set(val)
                    },
                    colliding_tiles = { layers = val.no and { [tier1] = true } or {} },
                    remove_on_collision = true,
                }
            }

            if strings[val[1]] then
                entity.localised_name
                    = {fns_locale_key('item-name', strings[val[1]]),
                        entity.localised_name or {"entity-name."..entity.name}
                    }
            end
        end
    end
end

return seal_namespace(concrete)