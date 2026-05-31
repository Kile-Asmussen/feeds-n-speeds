--! data: add auto_require_pavement field to vanilla entities
local pavement = {
    ['mining-drill'] = 'dirt',
    ['accumulator'] = 'stone-path',
    ['ammo-turret'] = {},
    ['arithmetic-combinator'] = 'stone-path',
    ['assembling-machine'] = {
        ['chemical-plant'] = 'concrete',
        ['oil-refinery'] = 'concrete',
        ['centrifuge'] = 'hazard-concrete',
    },
    ['beacon'] = 'hazard-concrete',
    ['boiler'] = {
        ['boiler'] = 'stone-path',
        ['heat-exchanger'] = 'refined-concrete',
    },
    ['constant-combinator'] = false, 
    ['decider-combinator'] = 'stone-path',
    ['display-panel'] = 'stone-path',
    ['electric-pole'] = {
        ['medium-electric-pole'] = 'stone-path',
        ['big-electric-pole'] = false,
        ['substation'] = 'concrete',
    },
    ['furnace'] = {
        ['steel-furnace'] = 'stone-path',
        ['electric-furnace'] = 'concrete',
    },
    ['fusion-reactor'] = 'refined-hazard-concrete',
    ['gate'] = false,
    ['generator'] = {
        ['steam-engine'] = 'stone-path',
        ['steam-turbine'] = 'refined-concrete',
    },
    ['heat-pipe'] = false,
    ['inserter'] = {
        ['fast-inserter'] = 'stone-path',
        ['long-handed-inserter'] = 'stone-path',
        ['bulk-inserter'] = 'concrete',
        ['stack-inserter'] = 'hazard-concrete',
    },
    ['lab'] = {
        ["lab"] = 'stone-path',
        ["biolab"] = 'dirt',
    },
    ['lightning-attractor'] = false,
    ['offshore-pump'] = false,
    ['power-switch'] = 'stone-path',
    ['reactor'] = {
        ['nuclear-reactor'] = 'refined-concrete',
        ['heating-tower'] = 'concrete',
    },
    ['roboport'] = 'concrete',
    ['rocket-silo'] = 'refined-concrete',
    ['selector-combinator'] = 'stone-path',
    ['solar-panel'] = false,
    ['splitter'] = {
        ['fast-splitter'] = 'stone-path',
        ['express-splitter'] = 'concrete',
        ['turbo-splitter'] = 'hazard-concrete',
    },
    ['storage-tank'] = 'stone-path',
    ['train-stop'] = 'concrete',
    ['transport-belt'] = {
        ['fast-transport-belt'] = 'stone-path',
        ['express-transport-belt'] = 'concrete',
        ['turbo-transport-belt'] = 'hazard-concrete',
    },
    ['turret'] = false,
    ['underground-belt'] = {
        ['fast-underground-belt'] = 'stone-path',
        ['express-underground-belt'] = 'concrete',
        ['turbo-underground-belt'] = 'hazard-concrete',
    },
    ['wall'] = false,
}

for entity_type, entities in pairs(pavement) do
    if type(entities) == 'string' or entities == false then
        for _, entity in pairs(data.raw[entity_type] or {}) do
            entity.auto_require_pavement = entities
        end
    else
        for entity_name, tier in pairs(entities) do
            if not (data.raw[entity_type] and data.raw[entity_type][entity_name]) then
                error("no such prototype: " .. utils.tablepath('data.raw', { entity_type, entity_name }))
            end
            data.raw[entity_type][entity_name].auto_require_pavement = tier
        end
    end
end
