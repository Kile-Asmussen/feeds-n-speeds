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

    concrete.adjust_tiles()
    concrete.flooring()
end

local tier1 = fns('basic_pavement', '_')
local tier2 = fns('sturdy_pavement', '_')
local tier3 = fns('foundation_pavement', '_')
local haz = fns('hazard_markings', '_')

function concrete.adjust_tiles()
    local tile = data.raw.tile

    for _, tile in pairs(data.raw.tile) do

        if tile.name:match('stone%-path') then
            tile.walking_speed_modifier = 1.3
            tile.collision_mask[tier1] = true
        end

        if tile.name:match('concrete') then
            tile.walking_speed_modifier = 1.5
            tile.collision_mask[tier1] = true
            tile.collision_mask[tier2] = true

            if tile.name:match('refined') then
                tile.walking_speed_modifier = 2.0
                tile.collision_mask[tier3] = true
            end
        end

        if tile.name:match('hazard') then
            tile.walking_speed_modifier = 1
            tile.collision_mask[haz] = true
        end
    end

    tile['space-platform-foundation'].collision_mask.layers = {
        [tier1] = true,
        [tier2] = true,
        [tier3] = true,
        [haz] = true,
        ground_tile = true,
    }
    tile['foundation'].collision_mask.lauers = {
        [tier1] = true,
        [tier2] = true,
        ground_tile = true,
    }
end

local function search_radius(ent)
    local rad = ent.resource_searching_radius
    return { { -rad - 1, -rad - 1 }, { rad + 1, rad + 1 } }
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
        ['assembling-machine-2'] = { tier1 },
        ['assembling-machine-3'] = { tier2, haz, r=plus(1) },
        ['chemical-plant'] = { tier1 },
        ['oil-refinery'] = { tier2, r=plus(1) },
        ['biochamber'] = { r=plus(2), no = { tier1, tier2, tier3, haz } },
        ['centrifuge'] = { tier2, haz, r=plus(2) },
        ['cryogenic-plant'] = { tier3, r=plus(2) },
        ['electromagnetic-plant'] = { tier3, r=plus(2) },
        ['foundry'] = { tier2, r=plus(2) },
        ['captive-biter-spawner'] = { no = { tier1, tier2, tier3, haz }, r=plus(2) }
    },

    ['mining-drill'] = {
        ['burner-mining-drill'] = { no = { tier1, tier2, tier3, haz }, r=search_radius },
        [fns 'burner-mining-drill-fluid'] = { no = { tier1, tier2, tier3, haz }, r=search_radius },
        ['electric-mining-drill'] = { no = { tier1, tier2, tier3, haz }, r=search_radius },
        [fns 'electric-mining-drill-fluid'] = { no = { tier1, tier2, tier3, haz, r=search_radius } },
        ['big-mining-drill'] = { no = { tier1, tier2, tier3, haz }, r=search_radius },
        ['pumpjack'] = { no = { tier1, tier2, tier3, haz }, r=search_radius }
    },

    ['lab'] = {
        ['lab'] = { tier1 },
        ['biolab'] = { r=plus(1), no = { tier1, tier2, tier3, haz } },
    },

    ['agricultural-tower'] = {
        ['agricultural-tower'] = {
            no = { tier1, tier2, tier3, haz },
            r=function(ent)
                local radius = ent.radius * math.ceil(math.abs(ent.collision_box[1][1]*2))
                return plus(radius)(ent)
            end
        }
    },

    ['furnace'] = {
        ['steel-furnace'] = { tier1 },
        ['electric-furnace'] = { tier2 },
        ['recycler'] = { tier2, haz, r=plus(1) },
    },

    ['boiler'] = {
        [fns 'electroboiler'] = { tier1 },
        ['heat-exchanger'] = { tier2, haz, r=plus(1) },
    },

    ['reactor'] = {
        ['nuclear-reactor'] = { tier3, haz, r=plus(2) },
    },

    ['fusion-reactor'] = {
        ['fusion-reactor'] = { tier3, haz, r=plus(2) }
    },

    ['fusion-generator'] = {
        ['fusion-generator'] = { tier3, haz, r=plus(2) }
    },

    ['generator'] = {
        ['steam-turbine'] = { tier2, r=plus(1) }
    },

    ['inserter'] = {
        ['long-handed-inserter'] = { tier1 },
        ['fast-inserter'] = { tier1 },
        ['bulk-inserter'] = { tier2 },
        ['stack-inserter'] = { tier2, haz },
    },

    ['electric-pole'] = {
        ['substation'] = { tier2, haz }
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
        ['active-provider-chest'] = { tier2, haz },
        ['requester-chest'] = { tier2 },
        ['buffer-chest'] = { tier2 },
    },

    ['roboport'] = {
        ['roboport'] = { tier2, r=plus(1) },
        [fns 'logistics-roboport'] = { tier3, haz, r=plus(1) },
        [fns 'sleeper-roboport'] = { tier2, r=plus(1) },
        [fns 'construction-roboport'] = { tier1 },
    },

    ['accumulator'] = {
        ['accumulator'] = { tier2, haz },
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
        ['lightning-collector'] = { tier2, haz },
    },

    ['rocket-silo'] = {
        ['rocket-silo'] = { tier3, haz, r=plus(3) }
    },

    ['cargo-landing-pad'] = {
        ['cargo-landing-pad'] = { tier3, haz, r=plus(3) }
    },

    ['cargo-bay'] = {
        ['cargo-bay'] = { tier3, r=plus(1) }
    },
}

function concrete.flooring()
    for proto, entities in pairs(concrete.needs_paving) do
        for ent, val in pairs(entities) do
            local entity = data.raw[proto][ent]
            assert(entity, "no such entity data.raw." .. proto .. "." .. ent)
            table.insert(val, 'ground_tile')
            entity.tile_buildability_rules = {
                {
                    area = (val.r or radius)(entity),
                    required_tiles = {
                        layers = table.set(val)
                    },
                    colliding_tiles = val.no and {
                        layers = table.set(val.no)
                    } or nil
                }
            }
        end
    end
end

return seal_namespace(concrete)