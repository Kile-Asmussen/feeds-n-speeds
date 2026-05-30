-- data: add auto_require_pavement field to vanilla entities
local pavement = {
    ['mining-drill'] = 'dirt',
    ['accumulator'] = {},
    ['ammo-turret'] = {},
    ['arithmetic-combinator'] = {},
    ['assembling-machine'] = {},
    ['beacon'] = {},
    ['boiler'] = {},
    ['constant-combinator'] = {},
    ['container'] = {},
    ['decider-combinator'] = {},
    ['display-panel'] = {},
    ['electric-pole'] = {
        ['medium-electric-pole'] = 'stone-path',
        ['big-electric-pole'] = 'stone-path',
        ['substation'] = 'concrete',
    },
    ['electric-turret'] = {},
    ['fluid-turret'] = {},
    ['furnace'] = {},
    ['fusion-reactor'] = {},
    ['gate'] = {},
    ['generator'] = {},
    ['heat-pipe'] = {},
    ['inserter'] = {},
    ['lab'] = {},
    ['lamp'] = {},
    ['land-mine'] = {},
    ['lightning-attractor'] = {},
    ['logistic-container'] = {},
    ['offshore-pump'] = {},
    ['pipe'] = {},
    ['pipe-to-ground'] = {},
    ['power-switch'] = {},
    ['pump'] = {},
    ['radar'] = {},
    ['reactor'] = {},
    ['roboport'] = {},
    ['rocket-silo'] = {},
    ['selector-combinator'] = {},
    ['solar-panel'] = {},
    ['splitter'] = {},
    ['storage-tank'] = {},
    ['train-stop'] = {},
    ['transport-belt'] = {},
    ['turret'] = {},
    ['underground-belt'] = {},
    ['wall'] = {},
}

for entity_type, entities in pairs(pavement) do
    if type(entities) == 'string' then
        for _, entity in pairs(data.raw[entity_type] or {}) do
            entity.auto_require_pavement = entities
        end
    else
        for entity_name, tier in pairs(entities) do
            if not (data.raw[entity_type] and data.raw[entity_type][entity_name]) then
                die("no such prototype: " .. string.tablepath('data.raw', { entity_type, entity_name }))
            end
            data.raw[entity_type][entity_name].auto_require_pavement = tier
        end
    end
end
