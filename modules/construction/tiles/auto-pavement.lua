
local fns = require 'fns'

local tiers = {
    ['dirt'] = 'ground_tile',
    ['stone-path'] = fns.name_ 'basic_pavement',
    ['concrete'] = fns.name_ 'sturdy_pavement',
    ['hazard-concrete'] = fns.name_ 'sturdy_pavement_hazard',
    ['refined-concrete'] = fns.name_ 'foundation_pavement',
    ['refined-hazard-concrete'] = fns.name_ 'foundation_pavement_hazard',
}

local locale_keys = {
    ['dirt'] = 'bare-ground-machinery',
    ['stone-path'] = 'simple-machinery',
    ['concrete'] = 'machinery',
    ['hazard-concrete'] = 'dangerous-machinery',
    ['refined-concrete'] = 'heavy-machinery',
    ['refined-hazard-concrete'] = 'dangerous-heavy-machinery',
}

for _, group in pairs(data.raw) do
    for _, entity in pairs(group) do
        if type(entity) == 'table' and entity.auto_require_pavement then
            
            local tier = tiers[entity.auto_require_pavement]
            if not tier then
                error('unknown pavement tier: ' .. tostring(entity.auto_require_pavement), 1)
            end
            local required_tiles = {{ layers = {
                [ tier ] = true
            }}}

            local colliding_tiles = nil
            if entity.auto_require_pavement == 'dirt' then
                colliding_tiles = { { layers = { ['stone-path'] = true } } }
            end

            local locale_key = locale_keys[entity.auto_require_pavement]

            table.merge(entity, {
                tile_buildability_rules = {
                    {
                        area = table.clone(entity.collision_box),
                        required_tiles = required_tiles,
                        colliding_tiles = colliding_tiles,
                        remove_on_collision = true,
                    }
                },
                localised_description = {"", 
                    {"?", {"", {"entity-description." .. entity.name}, " "}, ""},
                    {fns.locale_key("entity-description", locale_key)},
                }
            })
        end
    end
end
