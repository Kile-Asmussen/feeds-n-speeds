--! data: create new collision layers for pavement types

local fns = require 'fns'

local stone_path = fns.name_ 'basic_pavement'
local concrete = fns.name_ 'sturdy_pavement'
local hazard_concrete = fns.name_ 'sturdy_pavement_hazard'
local refined_concrete = fns.name_ 'foundation_pavement'
local refined_hazard_concrete = fns.name_ 'foundation_pavement_hazard'

data:extend{
    { type = 'collision-layer', name = stone_path },
    { type = 'collision-layer', name = concrete },
    { type = 'collision-layer', name = hazard_concrete },
    { type = 'collision-layer', name = refined_concrete },
    { type = 'collision-layer', name = refined_hazard_concrete }
}

for _, item in ipairs{'stone-brick', 'concrete', 'hazard-concrete', 'refined-concrete', 'refined-hazard-concrete'} do
    data.raw.item[item].localised_description = {fns.locale_key("item-description", item)}
end

for _, tile in pairs(data.raw.tile) do

    if tile.name:match('stone%-path') then
        tile.walking_speed_modifier = 1.3
        tile.collision_mask.layers[stone_path] = true
    end

    if tile.name:match('concrete') then
        tile.walking_speed_modifier = 1.5
        tile.collision_mask.layers[stone_path] = true
        tile.collision_mask.layers[concrete] = true
        if tile.name:find('hazard', 1, true) then
            tile.collision_mask.layers[hazard_concrete] = true
        end

        if tile.name:match('hazard') then
            tile.walking_speed_modifier = 0.9
        end

        if tile.name:match('refined') then
            tile.walking_speed_modifier = 2.0
            tile.collision_mask.layers[refined_concrete] = true
            if tile.name:find('hazard', 1, true) then
                tile.collision_mask.layers[refined_hazard_concrete] = true
            end

            if tile.name:match('hazard') then
                tile.walking_speed_modifier = 1.0
            end

        end
    end
end

data.raw.tile['space-platform-foundation'].collision_mask.layers = {
    [stone_path] = true,
    [concrete] = true,
    [refined_concrete] = true,
    [hazard_concrete] = true,
    [refined_hazard_concrete] = true,
    ground_tile = true,
}

data.raw.tile['foundation'].collision_mask.layers = {
    [stone_path] = true,
    [concrete] = true,
    ground_tile = true,
}