
for _,material in ipairs{
    "wood", "iron", "copper", "stone", "glass"
} do
    prototype{
        type='technology',
        name=fns('textplates-'..material),
        effects={},
        prerequisites={},
        localised_name = {
            'technology-name.textplate',
            { 'textplates.wood-C' }
        }
        icon = '__textplates__/graphics/entity/'..material..'/t.png',
        icon_size = 128,
    }
end


local materials = {
    iron = {
        type="craft-item", item="iron-plate", unlocked_by = fns "textplates-iron",
    },
    copper = {
        type="craft-item", item="iron-plate", unlocked_by = fns"textplates-copper",
    },
    concrete = {
        type="craft-item", item="concrete", unlocked_by = "textplates-concrete",
         prerequisites = { "concrete", fns "textplates-stone" }, 
    },
    steel = {
        type="craft-item", item="steel-plate", unlocked_by = "textplates-steel",
        prerequisites = { "steel-processing", fns"textplates-iron" }
    },
    plastic = {
        type="craft-item", item="plastic-bar", unlocked_by = "textplates-plastic",
        prerequisites = { "plastics", fns"textplates-wood", }
    },
    plasticcoloured = {
        unlocked_by = "textplates-plastic"
    }
    wood = {
        type="mine-entity", entity="wood", unlocked_by = fns"textplates-wood",
    },
    gold = {
        type="mine-entity", entity="sulfur", unlocked_by = "textplates-gold"
    },
    stone = {
        type="craft-item", item="stone-brick", unlocked_by = fns"textplates-stone",
        prerequisites = { fns "basic-materials-processing", fns "textplates-glass" }
    },
    glass = {
        type="mine-entity", entity="stone", unlocked_by = fns"textplates-glass"
    },
    uranium = {
        type="craft-item", item="uranium-238", unlocked_by = "textplates-uranium"
        prerequisites = { fns "textplates-glass", "uranium-processing" }
    }
}

for material, changes in pairs(materials) do
    data.raw.recipe["textplate-"..material."-small"].unlocked_by = changes.unlocked_by
    data.raw.recipe["textplate-"..material."-large"].unlocked_by = changes.unlocked_by
    if materials.prerequisites then
        data.raw.technology[changes.unlocked_by].prerequisites = materials.prerequisites
    end
    if materials.type then
        data.raw.technology[changes.unlocked_by].unit = nil
        data.raw.technology[changes.unlocked_by].research_trigger = {
            type = changes.type, entity = changes.entity, item = changes.item,
            amount = materials.item and 1
        }
    end
    data.raw.technology[changes.unlocked_by].hidden = true
end