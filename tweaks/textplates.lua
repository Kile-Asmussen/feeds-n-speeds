require 'prelude'

local textplates = namespace 'tweaks.textplates'
textplates.enabled = true

function textplates.data()
    data:extend(require 'tweaks.textplates.tech')
end

function textplates.data_updates()

    textplates.fix_recipe('textplates-stone')
    textplates.fix_recipe('textplates-iron')
    textplates.fix_recipe('textplates-wood')
    textplates.fix_recipe('textplates-glass')
    textplates.fix_recipe('textplates-copper')

    textplates.fix_tech('textplates-plastic', 'plastic-bar')
    textplates.fix_tech('textplates-plasticcoloured', 'plastic-bar')
    textplates.fix_tech('textplates-steel', 'steel-plate')
    textplates.fix_tech('textplates-gold', 'sulfur')
    textplates.fix_tech('textplates-uranium', 'uranium-238')
    textplates.fix_tech('textplates-concrete', 'concrete')
end

function textplates.fix_recipe(name)
    if not data.raw.recipe[name] then return end
    data.raw.recipe[name].enabled = false
end

function textplates.fix_tech(name, material)
    if not data.raw.technology[name] then return end
    data.raw.technology[name].unit = nil
    data.raw.technology[name].prerequisite = {}
    data.raw.technology[name].research_trigger = {
        type="craft-item",
        item=material,
        amount=1
    }
end