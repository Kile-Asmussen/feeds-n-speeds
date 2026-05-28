local fns = require 'fns'

if not data.raw.item['textplate-iron-small'] then return end

for _,material in ipairs{
    "wood", "iron", "copper", "stone", "glass"
} do
    data:extend{{
        type='technology',
        name=fns('textplates-'..material),
        effects={},
        prerequisites={},
        localised_name = {
            'technology-name.textplate',
            { 'textplates.wood-C' }
        },
        unit = { count = 1, time = 1, ingredients = { { 'automation-science-pack', 1 } } },
        icon = '__textplates__/graphics/entity/'..material..'/t.png',
        icon_size = 128,
    }}
end


local materials = {
    iron = {
        type="craft-item", item="iron-plate", auto_unlocked_by = fns "textplates-iron",
    },
    copper = {
        type="craft-item", item="iron-plate", auto_unlocked_by = fns"textplates-copper",
    },
    concrete = {
        type="craft-item", item="concrete", auto_unlocked_by = "textplates-concrete",
         prerequisites = { "concrete", fns "textplates-stone" }, 
    },
    steel = {
        type="craft-item", item="steel-plate", auto_unlocked_by = "textplates-steel",
        prerequisites = { "steel-processing", fns"textplates-iron" }
    },
    plastic = {
        type="craft-item", item="plastic-bar", auto_unlocked_by = "textplates-plastic",
        prerequisites = { "plastics", fns"textplates-wood", }
    },
    plasticcoloured = {
        auto_unlocked_by = "textplates-plastic"
    },
    wood = {
        type="mine-entity", entity="wood", auto_unlocked_by = fns"textplates-wood",
    },
    gold = {
        type="mine-entity", entity="sulfur", auto_unlocked_by = "textplates-gold"
    },
    stone = {
        type="craft-item", item="stone-brick", auto_unlocked_by = fns"textplates-stone",
        prerequisites = { fns "basic-materials-processing", fns "textplates-glass" }
    },
    glass = {
        type="mine-entity", entity="stone", auto_unlocked_by = fns"textplates-glass"
    },
    uranium = {
        type="craft-item", item="uranium-238", auto_unlocked_by = "textplates-uranium",
        prerequisites = { fns "textplates-glass", "uranium-processing" }
    }
}

for material, changes in pairs(materials) do
    if not data.raw.recipe['textplate-'..material..'-small'] then
        goto continue
    end
    data.raw.recipe["textplate-"..material.."-small"].auto_unlocked_by = changes.auto_unlocked_by
    data.raw.recipe["textplate-"..material.."-large"].auto_unlocked_by = changes.auto_unlocked_by
    if materials.prerequisites then
        data.raw.technology[changes.auto_unlocked_by].prerequisites = materials.prerequisites
    end
    if materials.type then
        data.raw.technology[changes.auto_unlocked_by].unit = nil
        data.raw.technology[changes.auto_unlocked_by].research_trigger = {
            type = changes.type, entity = changes.entity, item = changes.item,
            amount = materials.item and 1
        }
    end
    data.raw.technology[changes.auto_unlocked_by].hidden = true
    ::continue::
end