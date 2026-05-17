

local tier1 = fns('basic_pavement', '_')
local tier2 = fns('sturdy_pavement', '_')
local tier2h = fns('sturdy_pavement_hazard', '_')
local tier3 = fns('foundation_pavement', '_')
local tier3h = fns('foundation_pavement_hazard', '_')
local none = 'ground_tile'

local locale_keys = {
    [none] = 'bare-ground-machinery',
    [tier1] = 'simple-machinery',
    [tier2] = 'machinery',
    [tier2h] = 'dangerous-machinery',
    [tier3] = 'heavy-machinery',
    [tier3h] = 'dangerous-heavy-machinery',
}

local needs_paving = {
    ['assembling-machine'] = {
        ['assembling-machine-1'] = tier1,
        ['assembling-machine-2'] = tier2,
        ['assembling-machine-3'] = tier2h,
        ['chemical-plant'] = tier2,
        ['oil-refinery'] = tier2,
        ['biochamber'] = tier1,
        ['centrifuge'] = tier2h,
        ['cryogenic-plant'] = tier3,
        ['electromagnetic-plant'] = tier3,
        ['foundry'] = tier2,
        ['captive-biter-spawner'] = none
    },

    ['mining-drill'] = {
        ['burner-mining-drill'] = none,
        [fns 'burner-mining-drill-fluid'] = none,
        ['electric-mining-drill'] = none,
        [fns 'electric-mining-drill-fluid'] = none,
        ['big-mining-drill'] = none,
        ['pumpjack'] = none,
    },

    ['lab'] = {
        ['lab'] = tier1,
        ['biolab'] = { none },
    },

    ['agricultural-tower'] = {
        ['agricultural-tower'] = tier1
    },

    ['furnace'] = {
        ['steel-furnace'] = tier1,
        ['electric-furnace'] = tier2,
        ['recycler'] = tier2h,
    },

    ['boiler'] = {
        ['boiler'] = tier1,
        -- [fns 'electroboiler'] = tier1,
        ['heat-exchanger'] = tier2h,
    },

    ['reactor'] = {
        ['nuclear-reactor'] = tier3h,
    },

    ['fusion-reactor'] = {
        ['fusion-reactor'] = tier3h
    },

    ['fusion-generator'] = {
        ['fusion-generator'] = tier3h
    },

    ['generator'] = {
        ['steam-engine'] = tier1,
        ['steam-turbine'] = tier2,
    },

    ['inserter'] = {
        ['long-handed-inserter'] = tier1,
        ['fast-inserter'] = tier1,
        ['bulk-inserter'] = tier2,
        ['stack-inserter'] = tier2h,
    },

    ['electric-pole'] = {
        ['substation'] = tier2h
    },

    ['container'] = {
        -- [fns 'big-steel-chest'] = tier1
    },

    ['proxy-container'] = {
        -- [fns 'big-steel-hopper'] = tier1
    },

    ['logistic-container'] = {
        ['storage-chest'] = tier1,
        ['passive-provider-chest'] = tier1,
        ['active-provider-chest'] = tier2h,
        ['requester-chest'] = tier2,
        ['buffer-chest'] = tier2,
    },

    ['roboport'] = {
        ['roboport'] = tier2,
        -- [fns 'logistics-roboport'] = tier3h,
        -- [fns 'sleeper-roboport'] = tier2,
        -- [fns 'construction-roboport'] = tier1,
    },

    ['accumulator'] = {
        ['accumulator'] = tier2h,
    },

    ['arithmetic-combinator'] = {
        ['arithmetic-combinator'] = tier1,
    },

    ['decider-combinator'] = {
        ['decider-combinator'] = tier1,
    },

    ['selector-combinator'] = {
        ['selector-combinator'] = tier2,
    },

    ['lightning-attractor'] = {
        ['lightning-collector'] = tier2h,
    },

    ['rocket-silo'] = {
        ['rocket-silo'] = tier3h
    },

    ['cargo-landing-pad'] = {
        ['cargo-landing-pad'] = tier3h
    },

    ['cargo-bay'] = {
        ['cargo-bay'] = tier3
    },

    ['beacon'] = {
        ['beacon'] = tier2h
    }
}

local function radius(ent)
    if ent.type == 'mining-drill' then
        local rad = ent.resource_searching_radius
        return { { -rad - 1, -rad - 1 }, { rad + 1, rad + 1 } }
    else
        return table.clone(ent.collision_box)
    end
end

for proto, entities in pairs(needs_paving) do
    for ent, val in pairs(entities) do
        val = table.clone(val)
        if not data.raw[proto] or not data.raw[proto][ent] then die("no such prototype: "
            ..string.tablepath('data.raw', { proto, ent })) end

        local entity = data.raw[proto][ent]

        local colliding_tiles = {}
        if val == none then colliding_tiles = { layers = { [tier1] = true } } end

        table.merge(entity, {
            tile_buildability_rules = {
                {
                    area = radius(entity),
                    required_tiles = {
                        layers = { [val] = true }
                    },
                    colliding_tiles = colliding_tiles,
                    remove_on_collision = true,
                }
            },
            localised_description = {"", 
                {"?", {"", {"entity-description." .. entity.name}, " "}, ""},
                {fns_locale_key("entity-description", locale_keys[val])},
            }
        })

    end
end