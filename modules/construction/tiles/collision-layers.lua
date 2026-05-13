require 'prelude'

local tier1 = fns('basic_pavement', '_')
local tier2 = fns('sturdy_pavement', '_')
local tier2h = fns('sturdy_pavement_hazard', '_')
local tier3 = fns('foundation_pavement', '_')
local tier3h = fns('foundation_pavement_hazard', '_')

prototype(
    { type = 'collision-layer', name = tier1 },
    { type = 'collision-layer', name = tier2 },
    { type = 'collision-layer', name = tier2h },
    { type = 'collision-layer', name = tier3 },
    { type = 'collision-layer', name = tier3h }
)

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
        if tile.name:find('hazard', 1, true) then
            tile.collision_mask.layers[tier2h] = true
        end

        if tile.name:match('hazard') then
            tile.walking_speed_modifier = 0.9
        end

        if tile.name:match('refined') then
            tile.walking_speed_modifier = 2.0
            tile.collision_mask.layers[tier3] = true
            if tile.name:find('hazard', 1, true) then
                tile.collision_mask.layers[tier3h] = true
            end

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